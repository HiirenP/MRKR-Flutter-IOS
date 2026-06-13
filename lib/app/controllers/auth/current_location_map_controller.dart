import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class LocationMapController extends GetxController {
  LocationMapController() {
    onInit();
  }

  GoogleMapController? googleMapController;
  RxList<Marker> markers = <Marker>[].obs;
  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  RxString fullAddress = ''.obs;
  StreamSubscription<Position>? positionStream;

  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    selectedIndex = 0;
  }

  Future<void> checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // Handle permission denied
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return; // Handle permission denied forever
    }
    startLocationUpdates();
  }

  void startLocationUpdates() {
    positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 100,
    )).listen((Position position) {
      currentPosition.value = LatLng(position.latitude, position.longitude);
      getIt<SharedPreferences>().setLatitude = position.latitude;
      getIt<SharedPreferences>().setLongitude = position.longitude;
      getAddressFromLatLng(position.latitude, position.longitude);
      update(); // Update the UI
    });
  }

  Future<void> getAddressFromLatLng(double lat, double long) async {
    try {
      final placeMarks = await placemarkFromCoordinates(lat, long);
      final place = placeMarks[0];
      final street = place.street ?? '';
      final subLocality = place.subLocality ?? '';
      final postalCode = place.postalCode ?? '';
      final locality = place.locality ?? '';
      final administrativeArea = place.administrativeArea ?? '';
      final country = place.country ?? '';
      var address = '';
      if (street.isNotEmpty) {
        address = street;
      }
      if (subLocality.isNotEmpty) {
        if (address.isNotEmpty) {
          address = '$address, $subLocality';
        } else {
          address = subLocality;
        }
      }
      if (postalCode.isNotEmpty) {
        if (address.isNotEmpty) {
          address = '$address, $postalCode';
        }
      }
      if (locality.isNotEmpty) {
        if (locality.isNotEmpty) {
          address = '$address, $locality';
        }
      }
      if (administrativeArea.isNotEmpty) {
        if (administrativeArea.isNotEmpty) {
          address = '$address, $administrativeArea';
        }
      }
      if (country.isNotEmpty) {
        if (country.isNotEmpty) {
          address = '$address, $country';
        }
      }

      fullAddress.value = address;
      debugPrint('fullAddress.value==========>${fullAddress.value}');
      update();
      await addMarkerAndPolyline(lat, long, place.street ?? place.locality ?? '');
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
    update();
  }

  Future<void> addMarkerAndPolyline(double lat, double long, String origin) async {
    final customIcon = await AssetMapBitmap.create(
      const ImageConfiguration(size: Size(45, 55)),
      Assets.images.png.currentLocationGrey.path,
    );

    markers.add(Marker(
      markerId: MarkerId(origin),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: origin),
      icon: customIcon, // Set the custom icon
    ));

    update();
  }
}
