import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/auth/owner/owner_register_profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class OwnerRegisterManage extends GetItHook<OwnerRegisterProfileController> {
  const OwnerRegisterManage({super.key});

  static Future<T?>? route<T>({dynamic map, bool isAllClear = false}) {
    if (isAllClear) {
      return Get.offAllNamed(AppRoutes.ownerRegisterManage, arguments: map);
    } else {
      return Get.toNamed(AppRoutes.ownerRegisterManage, arguments: map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        child: Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: controller.currentSelectionStep,
                    builder: (context, value, child) => Padding(
                      padding: const AppEdgeInsets.all16(),
                      child: Column(
                        children: [
                          AppCustomAppbar(
                            appTitle: controller.titleText(),
                            isPadding: true,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const AppEdgeInsets.v16(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: context.theme.colorScheme.primary,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: Container(
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: controller.currentSelectionStep.value >= 1
                                                  ? context.theme.colorScheme.primary
                                                  : context.theme.colorScheme.secondary,
                                              borderRadius: BorderRadius.circular(20),
                                            )),
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: Container(
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: controller.currentSelectionStep.value > 1
                                                ? context.theme.colorScheme.primary
                                                : context.theme.colorScheme.secondary,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(10),
                                  AppText(
                                    controller.subTitleText(),
                                    style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                  const Gap(10),
                                  Expanded(child: controller.managerPage()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const AppEdgeInsets.h16(),
                  child: AppButton(
                      label:
                          (controller.currentSelectionStep.value == 2 && controller.listDrinks.isNotEmpty) ? AppStrings.T.submit : AppStrings.T.next,
                      onPressed: () {
                        controller.nextPage();
                      }),
                ),
                const Gap(20),
                const CustomSizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.initialize();
    controller.genderList = [];
    controller.genderList.addAll(['Male', 'Female', 'Other']);
    controller.currentSelectionStep.value = 0;
    if (Get.arguments != null) {
      // print("value arguments---------->${Get.arguments['value']}");
      if (Get.arguments is Map<String, dynamic>) {
        final map = Get.arguments as Map<String, dynamic>;
        controller.emailController = TextEditingController(text: map['email'].toString());
        controller.mobileNumberController = TextEditingController(text: map['mobile'].toString());
        controller.dialCode.value = map['iso'].toString();
        controller.countryFlag.value = map['countryFlag'].toString();
      } else if (Get.arguments is int) {
        controller.currentSelectionStep.value = Get.arguments as int;
      }
    }
  }

  @override
  void onDispose() {}
}
