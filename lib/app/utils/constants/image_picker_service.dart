import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:marker/app/utils/helpers/image_compress_util.dart';

class ImagePickerService {
  factory ImagePickerService() => _instance;

  ImagePickerService._internal();

  static final ImagePickerService _instance = ImagePickerService._internal();

  File? image; // Variable to hold the selected image
  String? imagePath; // Variable to hold the image path

  Future<String?> pickImageCameraAndGallery(ImageSource imageSource) async {
    try {
      // Enable native Android Photo Picker for gallery selections on Android
      if (Platform.isAndroid && imageSource == ImageSource.gallery) {
        final platform = ImagePickerPlatform.instance;
        if (platform is ImagePickerAndroid) {
          platform.useAndroidPhotoPicker = true;
        }
       final image= await platform.getImageFromSource(source: imageSource);
       if (image == null) return null;
       return ImageCompressUtil.compressProfile(image.path);
      }

      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return null;
      final compressedPath = await ImageCompressUtil.compressProfile(image.path);
      final imageTemp = File(compressedPath);
      this.image = imageTemp;
      imagePath = compressedPath;
      return compressedPath;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
      return null;
    }
  }
}
