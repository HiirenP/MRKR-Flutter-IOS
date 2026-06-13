import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/bank_details_controller.dart';
import 'package:marker/app/data/models/bank_details_model/bank_details_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_bank_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/edit_bank_details_page.dart';
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
import 'package:marker/model/common_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankDetailsPage extends GetItHook<BankDetailsController> {
  const BankDetailsPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.bankDetailsPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: Padding(
          padding: const AppEdgeInsets.all16(),
          child: Column(
            children: [
              AppCustomAppbar(
                  appTitle: AppStrings.T.bankDetails,
                  isPadding: true,
                  isSecondaryIcon: true,
                  secondaryIconName: ImageView(Assets.svg.edit),
                  onSecondaryTap: (){

                    if((getIt<SharedPreferences>().getUserData?.isBankAdded == null || getIt<SharedPreferences>().getUserData!.isBankAdded!.isEmpty) && AppConstant.userType == UserType.owner){
                      AddBankPage.goRoute(true)!.then((val){
                        if(val!=null){
                          controller.getBankDetails();
                        }
                      });
                      return;
                    }else{
                      EditBankDetailsPage.route();
                    }
                  }),
              const Gap(10),
               Expanded(
                child: Obx(
                  () =>  (controller.banDetailsList.isEmpty)?

               Center(
               child: AppText(
               AppStrings.T.noBankDetailsFound,
                 style: context.textTheme.bodyMedium?.copyWith(
                   color: context.colorScheme.secondaryFixedDim,
                   fontSize: 18,
                 ),
               ),
        ):
       Column(
                    children: [

                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              Obx(() {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.banDetailsList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final model = controller.banDetailsList[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircularContainer(
                                            imagePath: model.icon!,
                                          ),
                                          title: AppText(
                                            model.title!,
                                            style: context.textTheme.displaySmall
                                                ?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: AppText(model.subTitle ?? '', style: context.textTheme.bodySmall),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 60),
                                          child: Divider(
                                            height: 1,
                                            color: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.1),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                              const Gap(10),
                              AppText(AppStrings.T.frontImage, style: context.textTheme.bodyMedium),
                              const Gap(10),
                              Obx(
                                () => controller.getBankData.value.frontImage != null
                                    ? ImageView(
                                        controller.getBankData.value.frontImage!,
                                        inner: ImageSize(height: 150, width: Get.width),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const Gap(10),
                              AppText(AppStrings.T.backImage, style: context.textTheme.bodyMedium),
                              const Gap(10),
                              Obx(
                                () => controller.getBankData.value.backImage != null
                                    ? ImageView(
                                        controller.getBankData.value.backImage!,
                                        inner: ImageSize(height: 150, width: Get.width),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const Gap(50),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
    controller.getBankDetails();
  }

  @override
  void onDispose() {
    controller.banDetailsList.value = <CommonModel>[];
    controller.getBankData.value = BankDetailsData();
  }
}
