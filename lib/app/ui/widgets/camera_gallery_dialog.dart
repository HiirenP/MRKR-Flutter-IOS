import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/image_picker_service.dart';
import 'package:marker/app/utils/helpers/image_compress_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<dynamic> profilePictureBottomSheet(
    {required String title, required String subTitle, Function(String)? selectedPath}) async {
  final context = Get.context!;
  return Get.bottomSheet(
    AppBottomSheet(
      title: title,
      subTitle: subTitle,
      isPadding: true,
      content: Padding(
        padding: const AppEdgeInsets.oT15(),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final reqStatus = await [Permission.camera].request();
                  if (reqStatus[Permission.camera]!.isGranted) {
                    final imagePath = await ImagePickerService().pickImageCameraAndGallery(ImageSource.camera);
                    if (imagePath != null && selectedPath != null) {
                      final image = await imageCropping(imagePath);
                      if (image != null) {
                        selectedPath(image);
                      }
                      Get.back();
                    }
                  } else {
                    await openAppSettingView();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const AppEdgeInsets.all16(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(10),
                      CircularContainer(
                        imagePath: Assets.svg.sCamera,
                        bgColor: context.theme.colorScheme.onPrimary,
                      ),
                      const Gap(15),
                      CenterText(
                        AppStrings.T.camera,
                        style: context.textTheme.bodyMedium,
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(15),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final reqStatus = await [Permission.storage, Permission.photos, Permission.photosAddOnly].request();
                  if (reqStatus[Permission.storage]!.isGranted ||
                      reqStatus[Permission.photos]!.isGranted ||
                      reqStatus[Permission.photosAddOnly]!.isGranted) {
                    final imagePath = await ImagePickerService().pickImageCameraAndGallery(ImageSource.gallery);
                    if (imagePath != null && selectedPath != null) {
                      final image = await imageCropping(imagePath);
                      if (image != null) {
                        selectedPath(image);
                      }
                      Get.back();
                    }
                  } else {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                    if(Platform.isAndroid && androidInfo.version.sdkInt>=33){
                      final imagePath = await ImagePickerService().pickImageCameraAndGallery(ImageSource.gallery);
                      if (imagePath != null && selectedPath != null) {
                      final image = await imageCropping(imagePath);
                      if (image != null) {
                        selectedPath(image);
                      }
                      Get.back();
                    }
                    } else {
                      await openAppSettingView();
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const AppEdgeInsets.all16(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(10),
                      CircularContainer(
                        imagePath: Assets.svg.gallery,
                        bgColor: context.colorScheme.onPrimary,
                      ),
                      const Gap(15),
                      CenterText(
                        AppStrings.T.gallery,
                        style: context.textTheme.bodyMedium,
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
    ),
  );
}

Future<void> openAppSettingView() async {
  final value = await permissionDialogForSettings(message: AppStrings.T.requiredPermissionCGSMessage);
  if (value != null && value is bool) {
    if (value) {
      await openAppSettings();
    }
  }
}

Future<String?> imageCropping(String imagePath) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 82,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPresetCustom(),
        ],
      ),
    ],
  );
  if (croppedFile != null) {
    return ImageCompressUtil.compressForUpload(croppedFile.path);
  } else {
    return null;
  }
}
