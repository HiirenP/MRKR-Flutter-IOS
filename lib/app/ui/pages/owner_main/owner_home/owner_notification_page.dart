import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/notifications/notifications_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/notifications/notifications_page.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class OwnerNotificationPage extends GetItHook<NotificationsController> {
  const OwnerNotificationPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.ownerNotificationsPage);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [Expanded(child: NotificationsPage())],
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.updateInitEntry();
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
