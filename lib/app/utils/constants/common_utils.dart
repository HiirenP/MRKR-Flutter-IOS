import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Helper method to display success messages
void showSuccess(String message) {
  Get.snackbar('Success', message);
}

// Helper method to display error messages
void showError(String message) {
  Get.snackbar(
    'Error',
    message,
    backgroundColor: AppColors.black,
    colorText: AppColors.white,
  );
}

void keyboardHide() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String hideText(String? text, {String? format, int limit = 3}) {
  if (text == null || text.trim().isEmpty) {
    return '';
  }
  if (text.length <= limit) {
    return text;
  }
  final char = format ?? '*';

  final data = char * (text.length - limit) + text.substring(text.length - limit);

  return data;
}

String formatNotificationBody(String? body) {
  if (body == null || body.isEmpty) return body ?? '';
  return body.replaceAllMapped(
    // Match $17.99 and float artifacts like $17.990000000000002
    RegExp(r'\$([\d]+\.?[\d]*)'),
    (match) {
      final amount = double.tryParse(match.group(1) ?? '');
      if (amount == null) return match.group(0)!;
      return AppValidations.getFormattedPrice(amount);
    },
  );
}

String formatDistance(double distance) {
  // `distance` is expected in miles throughout the UI.
  return '${distance.toStringAsFixed(1)} mi';
}

/// Miles label for bar list cards (`distanceMi` from API, else km → mi).
String formatBarDistanceMi({num? distanceMi, num? distanceKm}) {
  if (distanceMi != null) {
    return '${distanceMi.toDouble().toStringAsFixed(2)} mi';
  }
  if (distanceKm != null) {
    return '${(distanceKm.toDouble() * 0.621371).toStringAsFixed(2)} mi';
  }
  return '-';
}

bool barHasDistance({num? distanceMi, num? distanceKm}) =>
    distanceMi != null || distanceKm != null;

typedef MemberMapCoordinates = ({double lat, double lng, bool hasFix});

/// Cached GPS → last known → current position (for nearby bar distance).
Future<MemberMapCoordinates> resolveMemberMapCoordinates() async {
  final prefs = getIt<SharedPreferences>();
  var lat = prefs.getLatitude ?? 0.0;
  var lng = prefs.getLongitude ?? 0.0;

  try {
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      lat = lastKnown.latitude;
      lng = lastKnown.longitude;
    }

    final needsFreshFix = lat == 0.0 && lng == 0.0;
    if (needsFreshFix) {
      final current = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 10),
          accuracy: LocationAccuracy.medium,
        ),
      );
      lat = current.latitude;
      lng = current.longitude;
    }

    if (lat != 0.0 || lng != 0.0) {
      prefs.setLatitude = lat;
      prefs.setLongitude = lng;
    }
  } catch (e) {
    debugPrint('resolveMemberMapCoordinates error: $e');
  }

  return (lat: lat, lng: lng, hasFix: lat != 0.0 || lng != 0.0);
}

void shareMessage({String title = 'Marker', required String message}) {
  var link = '';
  if (Platform.isAndroid) {
    link = 'Download our app now! https://play.google.com/store/apps/details?id=com.kmtemp.marker.app';
  } else if (Platform.isIOS) {
    link = 'Download our app now! https://apps.apple.com/us/app/mrkr/id6748701173';
  }
  Share.share('$message\n$link', subject: title);
}

Future<Prediction?> placePickerForAddress() async {
  void onError(PlacesAutocompleteResponse response) {
    showError(response.errorMessage ?? 'Unknown error');
  }

  final p = await PlacesAutocomplete.show(
    context: Get.context!,
    apiKey: AppConstant.kGoogleApiKey,
    onError: onError,
    textStyle: Get.context!.theme.textTheme.bodyMedium?.copyWith(color: Get.context!.theme.colorScheme.onPrimary),
    resultTextStyle: Get.context!.theme.textTheme.bodyMedium?.copyWith(color: Get.context!.theme.colorScheme.onSecondary),
    // mode: Mode.overlay,
    // or Mode.fullscreen
    language: 'en',
    // components: [const Component(Component.country, 'fr')],
  );
  return p;
}

Future<Geometry?> latLongFromPlaceId(String placeId) async {
  final places = GoogleMapsPlaces(
    apiKey: AppConstant.kGoogleApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders(),
  );

  final detail = await places.getDetailsByPlaceId(placeId);
  final geometry = detail.result.geometry!;
  return geometry;
}

const platform = MethodChannel('com.example.system_ui');

Future<void> hideBottomBar() async {
  await platform.invokeMethod('hideBottomBar');
}

const channel = MethodChannel('com.marker.flutter.voip/token');

Future<void> initVoip() async {
  debugPrint('<<<---initVoip--->>>');

  channel.setMethodCallHandler((call) async {
    if (call.method == 'onVoipToken') {
      String? token = call.arguments as String?;
      log('VoIP Token from iOS: $token');
      getIt<SharedPreferences>().setVoipToken = token ?? '';
    }
  });
}

/// Get last saved token (from UserDefaults)
Future<String?> getSavedToken() async {
  try {
    return await channel.invokeMethod<String>('getVoipToken');
  } catch (_) {
    return null;
  }
}

bool isBarOpenOrClose({
  required bool isOpenToday,
  required String openTime,
  required String closeTime,
}) {
  if (openTime.isEmpty || closeTime.isEmpty) {
    return false;
  }
  if (isOpenToday) {
    try {
      final sDate = utcToLocalAvailableTime(openTime, format: DateUtil.instance.yyyyMMddHHmmSS);
      final eDate = utcToLocalAvailableTime(closeTime, format: DateUtil.instance.yyyyMMddHHmmSS);
      final now = DateTime.now();
      final dt1 = DateTime.parse(sDate);
      final dt2 = DateTime.parse(eDate);
      if (now.compareTo(dt1) >= 0 && now.compareTo(dt2) <= 0) {
        return true;
      }
    } catch (e) {
      debugPrint('Error check open now or not---->$e');
    }
  }
  return false;
}

Future<dynamic> permissionDialogForSettings({required String message}) async {
  return showDialog<bool>(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text(AppStrings.T.permissionRequired),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppStrings.T.noThanks),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppStrings.T.allow),
        ),
      ],
    ),
  );
}

Map<String, dynamic> parseCallkitExtra(String input) {
  var s = input.trim();
  if (s.startsWith('{') && s.endsWith('}')) {
    s = s.substring(1, s.length - 1);
  }
  final map = <String, dynamic>{};
  for (final part in s.split(RegExp(r',\s*'))) {
    final eq = part.indexOf('=');
    if (eq <= 0) continue;
    final key = part.substring(0, eq).trim();
    var value = part.substring(eq + 1).trim();
    if (value == 'null') {
      map[key] = null;
    } else if (value == 'true' || value == 'false') {
      map[key] = value == 'true';
    } else if (int.tryParse(value) != null && !value.contains('.')) {
      map[key] = int.parse(value);
    } else if (double.tryParse(value) != null) {
      map[key] = double.parse(value);
    } else {
      map[key] = value;
    }
  }
  return map;
}

Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;
  final buildNumber = packageInfo.buildNumber;
  return '$version ($buildNumber)';
}
