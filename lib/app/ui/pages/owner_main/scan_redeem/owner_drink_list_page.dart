import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/scan_redeem/owner_drink_list_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class OwnerDrinkListPage extends GetItHook<OwnerDrinkListController> {
  const OwnerDrinkListPage({super.key});

  static Future<T?>? route<T>({String? markerId}) {
    AppConstant.instance.isAlreadyIn = true;
    return Get.offNamed(AppRoutes.ownerDrinkPage, arguments: markerId);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.onGoBack();
      },
      child: Scaffold(
          body: SafeArea(
              top: false,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AppCustomAppbar(
                      appTitle: AppStrings.T.drinks,
                      isPadding: true,
                      onTap: controller.onGoBack,
                    ),
                    const Gap(20),
                    TextInputField(
                      type: InputType.text,
                      controller: controller.searchController,
                      hintLabel: AppStrings.T.search,
                      context: context,
                      circularValue: 30.0.obs,
                      prefixIcon: ImageView(
                        Assets.svg.searchNormal,
                        color: context.colorScheme.secondaryFixedDim,
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        controller.setSearchValue(value);
                      },
                    ),
                    const Gap(20),
                    Obx(() {
                      return Expanded(
                        child: controller.isDataEmpty.value
                            ? Visibility(
                                visible: controller.isDataEmpty.value,
                                child: EmptyScreen(
                                  title: AppStrings.T.drinkBarTitle,
                                  subTitle: AppStrings.T.drinkBarSubtitle,
                                ),
                              )
                            : GridView.builder(
                                itemCount: controller.drinksListData.length + (controller.hasMoreData.value ? 1 : 0),
                                controller: controller.scrollController,
                                padding: const AppEdgeInsets.all16(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, mainAxisExtent: 175),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index > controller.drinksListData.length - 1 && controller.hasMoreData.value) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  final model = controller.drinksListData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      controller.selectedIndex.value = index;
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        ImageView(
                                          model.image ?? '',
                                          borderRadius: BorderRadius.circular(18),
                                          inner: ImageSize(width: double.infinity, height: 175),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            width: 160,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: context.colorScheme.secondary,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(18),
                                                bottomRight: Radius.circular(18),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const AppEdgeInsets.h8(),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: AppText(
                                                      model.name ?? '',
                                                      style: context.textTheme.bodySmall,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  AppText(
                                                    AppValidations.getFormattedPrice(model.price ?? ' '),
                                                    style: context.textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => controller.selectedIndex.value == index
                                              ? Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: ImageView(Assets.svg.tickCircle),
                                                  ))
                                              : const SizedBox(),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                      );
                    }),
                    Obx(
                      () {
                        if (controller.selectedIndex.value != -1) {
                          return AppButton(
                              label: AppStrings.T.done,
                              onPressed: () {
                                controller.updateDrink();
                              });
                        }
                        return const SizedBox();
                      },
                    ),
                    const Gap(20),
                    const CustomSizedBox()
                  ],
                ),
              ))),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onDispose() {
    controller.onDisposeData();
  }

  @override
  void onInit() {
    controller.initData();
  }
}
