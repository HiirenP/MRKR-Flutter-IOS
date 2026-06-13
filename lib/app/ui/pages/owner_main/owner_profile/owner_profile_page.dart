import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/owner_profile_controller.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_bank_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/change_pwd_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/contact_us_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/delete_account_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/my_profile_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/bank_details_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/my_wallet_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/withdraw_history_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerProfilePage extends GetItHook<OwnerProfileController> {
  const OwnerProfilePage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.ownerProfilePage);
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
              appTitle: AppStrings.T.profile,
              isPadding: true,
              isHideBackButton: true,
            ),
            const Gap(10),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.profileList.length,
                itemBuilder: (context, index) {
                  final model = controller.profileList[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (model.name == AppStrings.T.myProfile) {
                          MyProfilePage.route();
                        } else if (model.name == AppStrings.T.changePassword) {
                          ChangePwdPage.route();
                        } else if (model.name == AppStrings.T.myWallet) {
                          MyWalletPage.route();
                        } else if (model.name == AppStrings.T.bankDetails) {
                          if ((getIt<SharedPreferences>().getUserData?.isBankAdded == null ||
                                  getIt<SharedPreferences>().getUserData!.isBankAdded!.isEmpty) &&
                              AppConstant.userType == UserType.owner) {
                            AddBankPage.goRoute(true)!.then((val) {
                              if (val != null) {
                                BankDetailsPage.route();
                              }
                            });
                            return;
                          } else {
                            BankDetailsPage.route();
                          }
                        } else if (model.name == AppStrings.T.withdrawHistory) {
                          WithdrawHistoryPage.route();
                        } else if (model.name == AppStrings.T.contactUs) {
                          ContactUsPage.route();
                        } else if (model.name == AppStrings.T.aboutUs) {
                          PrivacyPolicyPage.route(model.name, url: AppConfig.aboutUs);
                        } else if (model.name == AppStrings.T.termsConditions) {
                          PrivacyPolicyPage.route(model.name, url: AppConfig.termsConditions);
                        } else if (model.name == AppStrings.T.privacyPolicy) {
                          PrivacyPolicyPage.route(model.name, url: AppConfig.privacyPolicy);
                        } else if (model.name == AppStrings.T.deleteAccount) {
                          DeleteAccountPage.route();
                        } else if (model.name == AppStrings.T.logOut) {
                          logoutBottomSheet(controller.changeState);
                        }
                      },
                      child: Container(
                        padding: const AppEdgeInsets.v8(),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: context.colorScheme.secondary),
                        child: ListTile(
                          leading: CircularContainer(
                            imagePath: model.icon ?? '',
                            bgColor: context.colorScheme.onPrimary,
                          ),
                          trailing: ImageView(Assets.svg.arrowRight),
                          title: AppText(
                            model.name ?? '',
                            style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
