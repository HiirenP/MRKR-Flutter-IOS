import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/my_wallet_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/history_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class MyWalletPage extends GetItHook<MyWalletController> {
  const MyWalletPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.myWalletPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const AppEdgeInsets.all16(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppCustomAppbar(
                appTitle: AppStrings.T.myWallet,
                isPadding: true,
              ),
              const Gap(10),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ImageView(
                    Assets.svg.walletCard,
                    borderRadius: BorderRadius.circular(18),
                    inner: ImageSize(height: 230, width: Get.width),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => AppText(
                          '\$${controller.walletAmount.value.toStringAsFixed(1)}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: context.textTheme.headlineLarge?.copyWith(fontSize: 32),
                        ),
                      ),
                      const Gap(10),
                      AppText(
                        AppStrings.T.yourBalance,
                        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: () => controller.withdrawBottomSheet(),
                        child: Container(
                          height: 60,
                          width: Get.width,
                          alignment: Alignment.center,
                          margin: const AppEdgeInsets.all10(),
                          padding: const AppEdgeInsets.hv105(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: context.colorScheme.onPrimary,
                          ),
                          child: AppText(
                            AppStrings.T.withdraw,
                            style: context.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Gap(20),
              AppText(
                AppStrings.T.transactionHistory,
                style: context.textTheme.labelSmall,
              ),
              const Gap(10),
              const HistoryPage(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.isDataEmpty.value = false;
    controller.amountController = TextEditingController();
    controller.walletAmount.value = 0.0;
  }

  @override
  void onDispose() {
    controller.isDataEmpty.value = false;
    controller.withdrawalHistoryData.value = [];
    controller.page = 1;
  }
}
