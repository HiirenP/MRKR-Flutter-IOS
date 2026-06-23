import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends GetItHook<ProfileController> {
  const PrivacyPolicyPage({super.key});

  static Future<T?>? route<T>(String? title, {String? url, bool fullScreenWebView = false}) {
    return Get.toNamed(
      AppRoutes.privacyPolicyPage,
      arguments: [title, url, fullScreenWebView],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPaymentView = controller.isFullScreenWebView.value ||
          controller.title.value == AppStrings.T.payment;

      if (isPaymentView) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: ImageView(Assets.svg.arrowBack),
                      ),
                      Expanded(
                        child: Text(
                          controller.title.value,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              if (controller.url.value.isEmpty)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: ColoredBox(
                    color: Colors.white,
                    child: WebViewWidget(controller: controller.webViewController!),
                  ),
                ),
              SafeArea(
                top: false,
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }

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
              if (controller.url.value.isEmpty)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: WebViewWidget(controller: controller.webViewController!),
                ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    debugPrint('--------------${Get.arguments}');
    controller.isFullScreenWebView.value = false;
    controller.url.value = 'https://www.freeprivacypolicy.com/blog/privacy-policy-url/';
    final args = Get.arguments;
    if (args is List && args.isNotEmpty) {
      controller.title.value = args[0] as String;
      if (args.length > 1 && args[1] != null) {
        controller.url.value = args[1] as String;
      }
      if (args.length > 2 && args[2] is bool) {
        controller.isFullScreenWebView.value = args[2] as bool;
      }

      final isPayment = controller.isFullScreenWebView.value ||
          controller.title.value == AppStrings.T.payment;
      controller.addWebView(link: controller.url.value, isPayment: isPayment);
    }
  }

  @override
  void onDispose() {
    controller.url.value = '';
    controller.title.value = '';
    controller.isFullScreenWebView.value = false;
  }
}
