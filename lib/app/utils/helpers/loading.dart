import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:marker/app/utils/constants/app_colors.dart';

class Loading {
  static bool isBackButton = true;

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..contentPadding = const EdgeInsets.all(18)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..lineWidth = 2
      ..radius = 20
      ..progressColor = Colors.white
      ..backgroundColor = AppColors.primaryColor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  static void show([String? text]) {
    isBackButton = false;
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show();
  }

  static void toast(String text) {
    EasyLoading.showToast(text);
  }

  static void dismiss() {
    isBackButton = true;
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }
}
