import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/image_compress_util.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/service/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class EditBarProfileController extends GetxController {
  EditBarProfileController() {
    onInit();
  }

  RxString countryFlag = ''.obs;
  RxString iso = ''.obs;
  RxString barLogo = ''.obs;
  RxString image = ''.obs;

  RxList<String> galleryImage = <String>[].obs;
  bool isDeleted = false;
  RxList<Images> images = <Images>[].obs;
  RxList<String> removeImage = <String>[].obs;
  final barUpdateState = ApiState.initial().obs;
  TextEditingController barNameController = TextEditingController();
  TextEditingController barMobileNumberController = TextEditingController();
  TextEditingController barEmailController = TextEditingController();
  TextEditingController barTimeController = TextEditingController();
  TextEditingController barAddressController = TextEditingController();
  TextEditingController barCityController = TextEditingController();
  TextEditingController barStateController = TextEditingController();
  TextEditingController barCountryController = TextEditingController();
  RxString fromTime = ''.obs;
  RxString toTime = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final locationService = LocationService();
  Rx<LatLng> currentPosition = Rx<LatLng>(const LatLng(0, 0));
  String startHour = '';
  String startMin = '';
  String endHour = '';
  String endMin = '';

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  String checkAmPm(int value) {
    return value == 0 ? 'AM' : 'PM';
  }

  void setEditProfileData(BarGetUpdateData data) {
    startHour = '';
    startMin = '';
    endHour = '';
    endMin = '';
    final updateFromTime = utcToLocalAvailableTime(data.openingHours?.open ?? '');
    final updateToTime = utcToLocalAvailableTime(data.openingHours?.close ?? '');
    startHour = utcToLocalAvailableTime(data.openingHours?.open ?? '', format: 'k');
    startMin = utcToLocalAvailableTime(data.openingHours?.open ?? '', format: 'm');
    endHour = utcToLocalAvailableTime(data.openingHours?.close ?? '', format: 'k');
    endMin = utcToLocalAvailableTime(data.openingHours?.close ?? '', format: 'm');
    final openingHours = '$updateFromTime - $updateToTime';
    barNameController.text = data.name ?? '';
    barMobileNumberController.text = data.mobile ?? '';
    barEmailController.text = data.email ?? '';
    barTimeController.text = openingHours;
    barAddressController.text = data.address ?? '';
    barCityController.text = data.city ?? '';
    barCountryController.text = data.country ?? '';
    barStateController.text = data.state ?? '';
    countryFlag.value = data.countryFlag ?? '';
    iso.value = data.iso ?? '';
    barLogo.value = data.logo ?? '';
    images.value = data.images ?? [];

    currentPosition.value = LatLng(data.location?.coordinates?[0] ?? 0, data.location?.coordinates?[1] ?? 0);

    fromTime.value = updateFromTime;
    toTime.value = updateToTime;
  }

  Future<void> updateBarOwnerData() async {
    var isEmpty = false;
    final tempFrom = localToUtcAvailableTime(fromTime.value);
    final tempTo = localToUtcAvailableTime(toTime.value);
    final barPhotos = <MultipartFile>[];

    if (!formKey.currentState!.validate()) {
      return;
    }

    final fi = <String, dynamic>{};
    if (removeImage.isNotEmpty) {
      for (var i = 0; i < removeImage.length; i++) {
        fi.addAll({'imagesToRemove[$i]': removeImage[i]});
      }
    }
    final locations = await locationFromAddress(barAddressController.text.trim());
    var latitude = 0.0;
    var longitude = 0.0;
    if (locations.isNotEmpty) {
      latitude = locations.first.latitude;
      longitude = locations.first.longitude;
    }
    fi.putIfAbsent('name', () => barNameController.text.trim());
    fi.putIfAbsent('email', () => barEmailController.text.trim());
    fi.putIfAbsent('address', () => barAddressController.text.trim());
    fi.putIfAbsent('latitude', () => '$latitude');
    fi.putIfAbsent('longitude', () => '$longitude');
    fi.putIfAbsent('iso', () => iso.value);
    fi.putIfAbsent('countryFlag', () => countryFlag.value);
    fi.putIfAbsent('mobile', () => barMobileNumberController.text.trim());
    fi.putIfAbsent('city', () => barCityController.text.trim());
    fi.putIfAbsent('state', () => barStateController.text.trim());
    fi.putIfAbsent('country', () => barCountryController.text.trim());
    fi.putIfAbsent('opensFrom', () => tempFrom);
    fi.putIfAbsent('openTill', () => tempTo);
    if (barLogo.value.isNotEmpty && !barLogo.value.startsWith('http')) {
      debugPrint('barLogo.value===>${barLogo.value}');
      final barTempLogo = await ImageCompressUtil.multipartFromCompressed(
        barLogo.value,
        filename: barLogo.value.split('/').last,
      );
      fi.putIfAbsent('logo', () => barTempLogo);
    }

    if (galleryImage.isEmpty && !isDeleted) {
      isEmpty = true;
    } else if (galleryImage.isNotEmpty) {
      final allImages = galleryImage;
      if (allImages.isNotEmpty) {
        for (final imagePath in allImages) {
          if (imagePath.trim().isNotEmpty) {
            final file = await ImageCompressUtil.multipartFromCompressed(
              imagePath.trim(),
              filename: imagePath.trim().split('/').last,
            );
            barPhotos.add(file);
          }
        }
      }
    }
    if (!isEmpty) {
      fi.putIfAbsent('images', () => barPhotos);
    }
    final imgRemove = FormData.fromMap(fi);

    barUpdateState.value = LoadingState();
    await getIt<BarOwnerService>().updateBar(getIt<SharedPreferences>().getBarId ?? '', imagesToRemove: imgRemove).handler(
      barUpdateState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          Get.back(result: value.data);
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void disposeAll() {
    galleryImage.value = [];
    images.value = [];
    isDeleted = false;
    barNameController.dispose();
    barMobileNumberController.dispose();
    barEmailController.dispose();
    barTimeController.dispose();
    barAddressController.dispose();
    barCityController.dispose();
    barStateController.dispose();
    barCountryController.dispose();
  }

  void removeImages(int index) {
    if (index < images.length) {
      final image = images[index];
      if (image.sId != null) {
        removeImage.add(image.sId!);
      }
      images.removeAt(index);
    } else {
      final galleryIndex = index - images.length;
      galleryImage.removeAt(galleryIndex);
    }
  }

  void uploadImages() {
    profilePictureBottomSheet(
      title: AppStrings.T.uploadBarPhotos,
      subTitle: AppStrings.T.chooseBarPhotos,
      selectedPath: (String path) {
        galleryImage.add(path);
      },
    );
  }
}
