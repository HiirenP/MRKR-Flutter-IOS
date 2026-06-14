import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends GetItHook<BaseHomeController> {
  const MainPage({super.key});

  static Future<T?>? route<T>({
    int selectedIndex = 0,
    String? from,
    Map<String, dynamic>? data,
  }) {
    // if (from != null) {
    //   showError('message>>$from');
    // }
    if (isVideoNavigate && Platform.isIOS && from == 'Splash') {
      fromCallScreen = from;
      return null;
    } else if (Platform.isIOS && from == 'iOS-Declined') {
      callDeclined(data);
    }
    return Get.offAllNamed(AppRoutes.mainPage, arguments: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          return controller.pages[controller.selectedIndex.value];
        }),
      ),
      bottomNavigationBar: Obx(() {
        return AppBottomNavigationBar(
          selectedCallback: controller.onItemTapped,
          currentIndex: controller.selectedIndex.value,
          counter: controller.notificationCount,
          chatUnreadBadge: controller.hasUnreadChat,
        );
      }),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onDispose() {
    controller.socketDisconnection();
  }

  @override
  void onInit() {
    final userData = getIt<SharedPreferences>().getUserData;
    if (userData != null) {
      AppConstant.userType = UserTypeExtension.fromString(userData.userType);
    }
    controller.selectedIndex = 0.obs;
    if (Get.arguments != null && Get.arguments is int) {
      controller.selectedIndex.value = Get.arguments as int;
    }
    controller.socketConnection();
  }
}
