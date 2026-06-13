import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/my_wallet_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/history_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class WithdrawHistoryPage extends GetItHook<MyWalletController> {
  const WithdrawHistoryPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.withdrawHistoryPage);
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
            children: [
              AppCustomAppbar(
                appTitle: AppStrings.T.withdrawHistory,
                isPadding: true,
              ),
              const Gap(20),
              const HistoryPage(isWithdraw: true,),
              const CustomSizedBox()
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
  /*  controller.updateInitEntry();
    controller.withdrawalMoney();*/
  }

  @override
  void onDispose() {
    controller.totalRecord = 0;
    controller.hasMoreData = false.obs;
    controller.withdrawalHistoryData.value = [];
    controller.page = 1;
  }
}
