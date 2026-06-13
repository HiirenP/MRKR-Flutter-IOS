import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/block_users_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/change_pwd_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/contact_us_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/delete_account_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/my_profile_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/transaction_history_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ProfilePage extends GetItHook<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppEdgeInsets.all16(),
      child: Column(
        children: [
          AppCustomAppbar(
            appTitle: AppStrings.T.profile,
            isHideBackButton: true,
            isPadding: true,
          ),
          const Gap(20),
          Expanded(
            child: ListView.builder(
              itemCount: controller.profileList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    final itemName = controller.profileList[index].name;
                    if (itemName == AppStrings.T.myProfile) {
                      MyProfilePage.route();
                    } else if (itemName == AppStrings.T.changePassword) {
                      ChangePwdPage.route();
                    } else if (itemName == AppStrings.T.transactionHistory) {
                      TransactionHistoryPage.route();
                    } else if (itemName == AppStrings.T.blockUsers) {
                      BlockUsersPage.route();
                    } else if (itemName == AppStrings.T.contactUs) {
                      ContactUsPage.route();
                    } else if (itemName == AppStrings.T.tapToPayiPhone) {
                      TapToPayEnablePage.route();
                    } else if (itemName == AppStrings.T.tapToPayGuide) {
                      TapToPayGuidePage.route();
                    } else if (itemName == AppStrings.T.aboutUs) {
                      PrivacyPolicyPage.route(itemName, url: AppConfig.aboutUs);
                    } else if (itemName == AppStrings.T.termsConditions) {
                      PrivacyPolicyPage.route(itemName, url: AppConfig.termsConditions);
                    } else if (itemName == AppStrings.T.privacyPolicy) {
                      PrivacyPolicyPage.route(itemName, url: AppConfig.privacyPolicy);
                    } else if (itemName == AppStrings.T.deleteAccount) {
                      DeleteAccountPage.route();
                    } else if (itemName == AppStrings.T.logOut) {
                      logoutBottomSheet(controller.changeState);
                    }
                  },
                  child: Container(
                    margin: const AppEdgeInsets.oB15(),
                    padding: const AppEdgeInsets.v5(),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: context.colorScheme.secondary),
                    child: ListTile(
                      contentPadding: const AppEdgeInsets.h12(),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: context.colorScheme.onPrimary,
                        child: ImageView(
                          controller.profileList[index].icon!,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      trailing: ImageView(Assets.svg.arrowRight),
                      title: AppText(
                        controller.profileList[index].name!,
                        style: context.textTheme.bodySmall?.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.addProfileList();
  }

  @override
  void onDispose() {}
}

Future<dynamic> logoutBottomSheet(Rx<ApiState> changeState) {
  return Get.bottomSheet(
    AppBottomSheet(
      iconName: Padding(
        padding: const AppEdgeInsets.all12(),
        child: ImageView(Assets.svg.logout),
      ),
      title: AppStrings.T.logOut,
      subTitle: AppStrings.T.areYouLogout,
      positiveButtonTitle: AppStrings.T.yes,
      negativeButtonTitle: AppStrings.T.cancel,
      onNegativePressed: Get.back,
      onPositivePressed: () {
        logoutUser(changeState);
      },
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
    ),
  );
}
