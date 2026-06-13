import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends GetItHook<ProfileController> {
  const PrivacyPolicyPage({super.key});

  static Future<T?>? route<T>(String? title, {String? url}) {
    return Get.toNamed(AppRoutes.privacyPolicyPage, arguments: [title, url]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const AppEdgeInsets.all16(),
              child: AppCustomAppbar(
                appTitle: controller.title.value,
                isPadding: true,
              ),
            ),
            Obx(() {
              if (controller.url.value.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: WebViewWidget(controller: controller.webViewController!),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    debugPrint('--------------${Get.arguments}');
    controller.url.value = 'https://www.freeprivacypolicy.com/blog/privacy-policy-url/';
    if (Get.arguments != null) {
      controller.title.value = Get.arguments[0] as String;
      if (Get.arguments[1] != null) {
        controller.url.value = Get.arguments[1] as String;
      }

      controller.addWebView(link: controller.url.value);
    }
  }

  @override
  void onDispose() {
    controller.url.value = '';
    controller.title.value = '';
  }
}
