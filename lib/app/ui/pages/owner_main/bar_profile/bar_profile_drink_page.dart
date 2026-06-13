import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/bar_profile_controller.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_drink_details_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_drink_page.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/drink_category_dropdown.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class BarProfileDrinkPage extends GetItHook<BarProfileController> {
  const BarProfileDrinkPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.barProfileDrinkPage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(10),
        Padding(
          padding: const AppEdgeInsets.h16(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(
                  () => DrinkCategoryDropdown(
                    categories: controller.drinkCategories,
                    selectedId: controller.selectedCategoryId.value,
                    includeAllOption: true,
                    allOptionLabel: 'All categories',
                    onChanged: controller.onDrinkCategoryFilterChanged,
                  ),
                ),
              ),
              AppConstant.isOwnerLogin(
                child: GestureDetector(
                  onTap: () => AddDrinkPage.route()!.then((val) {
                    if (val is List<BarDrinkData>) {
                      controller.drinksListData.add(val.first);
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageView(Assets.svg.addCircle),
                        const Gap(5),
                        AppText(
                          AppStrings.T.addDrink,
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          return Expanded(
            child: controller.isDataEmpty.value
                ? EmptyScreen(
                    title: AppStrings.T.drinkBarTitle,
                    subTitle: AppStrings.T.drinkBarSubtitle,
                  )
                : GridView.builder(
                    itemCount: controller.drinksListData.length + (controller.hasMoreData.value ? 1 : 0),
                    controller: controller.scrollController,
                    padding: const AppEdgeInsets.all16(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, mainAxisExtent: 190),
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
                          AddDrinkDetailsPage.route(model.sId, barName: controller.barName)!.then(
                            (value) {
                              if (value != null) {
                                if (value is BarDrinkData) {
                                  controller.drinksListData[index] = value;
                                } else if (value is bool) {
                                  controller.drinksListData.removeAt(index);
                                }
                              }
                            },
                          );
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText(
                                              model.name ?? '',
                                              style: context.textTheme.bodySmall,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            if ((model.category?.name ?? '').isNotEmpty) ...[
                                              const Gap(2),
                                              AppText(
                                                model.category!.name!,
                                                style: context.textTheme.bodySmall?.copyWith(
                                                  color: context.colorScheme.onSecondary,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      AppText(
                                        '\$${model.price ?? ' '}',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
        }),
        const CustomSizedBox()
      ],
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.updateInitEntry();
  }

  @override
  void onDispose() {}
}
