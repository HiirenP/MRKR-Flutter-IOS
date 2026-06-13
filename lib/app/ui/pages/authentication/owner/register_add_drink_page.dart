import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/auth/owner/owner_register_profile_controller.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_drink_widget.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';

class RegisterAddDrinkPage extends GetItHook<OwnerRegisterProfileController> {
  const RegisterAddDrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OwnerRegisterProfileController>(
        init: getIt.get<OwnerRegisterProfileController>(),
        builder: (controllerOwner) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Obx(() => controller.listDrinks.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.listDrinks.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final drinkModel = controller.listDrinks[index];
                        return Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                          child: Padding(
                            padding: const AppEdgeInsets.all8(),
                            child: Row(
                              children: [
                                ImageView(
                                  drinkModel.profileImage ?? '',
                                  inner: ImageSize(width: 100, height: 114),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const AppEdgeInsets.all8(),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppText(drinkModel.name ?? '', style: context.textTheme.bodyMedium),
                                          ),
                                          PopupMenuButton<String>(
                                            borderRadius: BorderRadius.circular(15),
                                            elevation: 0,
                                            color: context.colorScheme.onPrimary,
                                            child: ImageView(
                                              Assets.svg.moreVertical,
                                              inner: ImageSize(width: 20, height: 20),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            onSelected: (value) {
                                              if (value == 'delete') {
                                                deleteAccountBottomSheet(index);
                                              } else if (value == 'edit') {
                                                controller.addDrinkBottomSheet(index);
                                              }
                                            },
                                            itemBuilder: (context) {
                                              return <PopupMenuEntry<String>>[
                                                PopupMenuItem(
                                                    height: 28,
                                                    value: AppStrings.T.edit.toLowerCase(),
                                                    child: Column(
                                                      children: [
                                                        CenterText(AppStrings.T.edit, style: context.textTheme.bodyMedium),
                                                        const Divider(height: 0, color: Colors.transparent)
                                                      ],
                                                    )),
                                                PopupMenuItem(
                                                  height: 10,
                                                  value: AppStrings.T.edit.toLowerCase(),
                                                  child: Divider(
                                                    color: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.2),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  height: 28,
                                                  value: AppStrings.T.delete.toLowerCase(),
                                                  child: Column(
                                                    children: [
                                                      CenterText(AppStrings.T.delete,
                                                          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.red)),
                                                      const Divider(height: 0, color: Colors.transparent)
                                                    ],
                                                  ),
                                                ),
                                              ];
                                            },
                                          ),
                                        ],
                                      ),
                                      const Gap(2),
                                      Row(
                                        children: [
                                          ImageView(
                                            Assets.svg.dollarCircle,
                                            inner: ImageSize(width: 16, height: 16),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const AppEdgeInsets.h5(),
                                            child: AppText(AppValidations.getFormattedPrice(drinkModel.price ?? ''),
                                                style: context.textTheme.bodySmall
                                                    ?.copyWith(color: context.theme.colorScheme.secondaryContainer, fontWeight: FontWeight.w400)),
                                          ))
                                        ],
                                      ),
                                      const Gap(6),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ImageView(
                                            Assets.svg.documentText,
                                            color: context.theme.colorScheme.primary,
                                            inner: ImageSize(width: 16, height: 16),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const AppEdgeInsets.h5(),
                                            child: AppText(drinkModel.des ?? '',
                                                maxLines: 3,
                                                style: context.textTheme.bodySmall
                                                    ?.copyWith(color: context.theme.colorScheme.secondaryContainer, fontWeight: FontWeight.w400)),
                                          ))
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const AddDrinkWidget()),
              const Gap(8),
              GestureDetector(
                onTap: () {
                  controller.addDrink();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [ImageView(Assets.svg.addCircle), const Gap(5), AppText(AppStrings.T.addMore, style: context.textTheme.bodyMedium)],
                ),
              ),
              const CustomSizedBox()
            ],
          );
        });
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {}

  @override
  void onDispose() {}

  Future<dynamic> deleteAccountBottomSheet(int index) async {
    final context = Get.context!;
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(
            Assets.svg.trash,
            color: context.colorScheme.primary,
          ),
        ),
        title: AppStrings.T.deleteDrink,
        subTitle: AppStrings.T.areYouSureDeleteDrink,
        positiveButtonTitle: AppStrings.T.yes,
        negativeButtonTitle: AppStrings.T.cancel,
        onNegativePressed: Get.back,
        onPositivePressed: () => {controller.removeAt(index)},
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
