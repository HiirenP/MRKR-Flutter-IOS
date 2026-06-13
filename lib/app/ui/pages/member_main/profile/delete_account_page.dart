import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class DeleteAccountPage extends GetItHook<ProfileController> {
  const DeleteAccountPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.deleteAccountPage);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        child: Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppCustomAppbar(
                    appTitle: AppStrings.T.deleteAccount,
                    isPadding: true,
                  ),
                  const Gap(24),
                  AppText(
                    AppStrings.T.chooseReason,
                    style: context.textTheme.titleSmall,
                  ),
                  const Gap(10),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.deleteAccountList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (controller.selectedReason.value == index) {
                                return;
                              }
                              controller.selectedReason.value = index;
                              if (index != 4) {
                                controller.deleteWriteMessageController.clear();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: Get.width,
                                  padding: const AppEdgeInsets.all16(),
                                  margin: const AppEdgeInsets.oB15(),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10), color: context.colorScheme.secondary),
                                  child: AppText(
                                    controller.deleteAccountList[index],
                                    style: context.textTheme.bodySmall?.copyWith(
                                      color: controller.selectedReason.value == index
                                          ? context.colorScheme.onSecondary
                                          : context.colorScheme.secondaryFixedDim,
                                    ),
                                  ),
                                ),
                                if (index == controller.selectedReason.value && index == 4)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Gap(3),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context.colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: TextInputField(
                                          type: InputType.multiline,
                                          keyboardType: TextInputType.multiline,
                                          textInputAction: TextInputAction.newline,
                                          minLines: 4,
                                          maxLines: 4,
                                          controller: controller.deleteWriteMessageController,
                                          hintLabel: AppStrings.T.writeReason,
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  AppButton(
                    label: AppStrings.T.deleteAccount,
                    onPressed: () {
                      if (controller.selectedReason.value == 0) {
                        controller.deleteWriteMessageController.text = controller.deleteAccountList[0];
                      }
                      if (controller.selectedReason.value == 4 &&
                          controller.deleteWriteMessageController.text.isEmpty) {
                        showError(AppStrings.T.typeDeletingYourAccount);
                      } else {
                        deleteAccountBottomSheet();
                      }
                    },
                  ),
                ],
              ),
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
    controller.selectedReason = 0.obs;
    controller.deleteWriteMessageController = TextEditingController();
    controller.addDeleteReasonList();
  }

  @override
  void onDispose() {
    controller.deleteWriteMessageController.dispose();
  }

  Future<dynamic> deleteAccountBottomSheet() {
    final context = Get.context!;
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(Assets.svg.trash, color: context.colorScheme.primary),
        ),
        title: AppStrings.T.deleteAccount,
        subTitle: AppStrings.T.areYouDeleteAccount,
        subThirdTitle: AppStrings.T.youWillLose,
        positiveButtonTitle: AppStrings.T.yes,
        negativeButtonTitle: AppStrings.T.cancel,
        onNegativePressed: Get.back,
        onPositivePressed: () {
          Get.back();
          controller.deleteUserAccount();
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
