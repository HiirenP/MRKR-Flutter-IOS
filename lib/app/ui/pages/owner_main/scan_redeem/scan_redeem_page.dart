import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/scan_redeem/scan_redeem_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ScanRedeemPage extends GetItHook<ScanRedeemController> {
  const ScanRedeemPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.scanRedeemPage);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Padding(
        padding: const AppEdgeInsets.all16(),
        child: Column(
          children: [
            AppCustomAppbar(
              appTitle: AppStrings.T.redeem,
              isPadding: true,
              isHideBackButton: true,
            ),
            const Gap(25),
            GestureDetector(
              onTap: () => controller.viaCodeBottomSheet(),
              child: Container(
                padding: const AppEdgeInsets.v10(),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: context.colorScheme.secondary),
                child: ListTile(
                  leading: CircularContainer(
                    imagePath: Assets.svg.hashtag,
                    bgColor: context.colorScheme.onPrimary,
                  ),
                  trailing: ImageView(Assets.svg.arrowRight),
                  title: AppText(
                    AppStrings.T.viaMarkerCode,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const Gap(20),
            GestureDetector(
              onTap: () => controller.qrCodeBottomSheet(),
              child: Container(
                padding: const AppEdgeInsets.v10(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: context.colorScheme.secondary,
                ),
                child: ListTile(
                  leading: CircularContainer(
                    imagePath: Assets.svg.barMainScan,
                    bgColor: context.colorScheme.onPrimary,
                  ),
                  trailing: ImageView(Assets.svg.arrowRight),
                  title: AppText(
                    AppStrings.T.scanQRCode,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {}

  @override
  void onDispose() {}
}
