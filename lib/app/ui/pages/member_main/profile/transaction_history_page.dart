import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/history_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';

import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class TransactionHistoryPage extends GetItHook<ProfileController> {
  const TransactionHistoryPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.transactionHistory);
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
                appTitle: AppStrings.T.transactionHistory,
                isPadding: true,
              ),
              const Gap(20),
              const HistoryPage(isMemberTransaction: true,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {}

  @override
  void onDispose() {}
}
