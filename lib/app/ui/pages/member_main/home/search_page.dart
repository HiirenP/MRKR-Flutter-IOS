import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/search_drink_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/home/search_drink_details_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';

class SearchPage extends GetItHook<SearchDrinkController> {
  const SearchPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.searchPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Padding(
            padding: const AppEdgeInsets.all16(),
            child: Column(
              children: [
                AppCustomAppbar(
                  appTitle: AppStrings.T.search,
                  isPadding: true,
                  isSecondaryIcon: true,
                  secondaryIconName: ImageView(Assets.svg.filter),
                  onSecondaryTap: () => controller.filterBottomSheet(),
                ),
                const Gap(20),
                TextInputField(
                  type: InputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controller.searchController,
                  hintLabel: AppStrings.T.searchForDrinks,
                  context: context,
                  circularValue: 30.0.obs,
                  prefixIcon: ImageView(
                    Assets.svg.searchNormal,
                    color: context.colorScheme.secondaryFixedDim,
                  ),
                  onChanged: (value) {
                    controller.setSearchValue(value);
                  },
                ),
                const Gap(20),
                Obx(
                  () => Expanded(
                    child: controller.isDataEmpty.value
                        ? EmptyScreen(
                            title: AppStrings.T.drinkTitle,
                            subTitle: AppStrings.T.drinkSubtitle,
                          )
                        : ListView.builder(
                            controller: controller.scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: controller.searchDrinkData.length + (controller.hasMoreData.value ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index > controller.searchDrinkData.length - 1 && controller.hasMoreData.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              final drink = controller.searchDrinkData[index];

                              return GestureDetector(
                                onTap: () => SearchDrinkDetailsPage.route(drink: drink),
                                child: Container(
                                  height: 140,
                                  margin: const AppEdgeInsets.oB15(),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const AppEdgeInsets.all8(),
                                        child: ImageView(
                                          drink.image ?? '',
                                          borderRadius: BorderRadius.circular(18),
                                          inner: ImageSize(width: 115, height: 140),
                                        ),
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              AppText(drink.name?.capitalize ?? '', style: context.textTheme.titleSmall),
                                              const Gap(5),
                                              Row(
                                                children: [
                                                  ImageView(
                                                    Assets.svg.owner,
                                                    color: context.colorScheme.primary,
                                                    inner: ImageSize(height: 16, width: 16),
                                                  ),
                                                  const Gap(5),
                                                  Expanded(
                                                    child: AppText(
                                                      drink.bar?.name ?? '',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: context.textTheme.bodySmall?.copyWith(
                                                        color: context.colorScheme.secondaryContainer,
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(1),
                                                ],
                                              ),
                                              Padding(
                                                padding: const AppEdgeInsets.v5(),
                                                child: Row(
                                                  children: [
                                                    ImageView(
                                                      Assets.svg.location,
                                                      color: context.colorScheme.primary,
                                                      inner: ImageSize(height: 16, width: 16),
                                                    ),
                                                    const Gap(5),
                                                    Expanded(
                                                      child: AppText(
                                                        drink.bar?.address ?? '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: context.colorScheme.secondaryContainer,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  ImageView(
                                                    Assets.svg.dollarCircle,
                                                    color: context.colorScheme.primary,
                                                    inner: ImageSize(height: 16, width: 16),
                                                  ),
                                                  const Gap(5),
                                                  Expanded(
                                                    child: AppText(
                                                      AppValidations.getFormattedPrice(drink.price),
                                                      maxLines: 1,
                                                      style: context.textTheme.bodySmall?.copyWith(
                                                        color: context.colorScheme.secondaryContainer,
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(20),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
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
    controller.searchController = TextEditingController();
    controller.cityController = TextEditingController();
    controller.countryController = TextEditingController();
    controller.stateController = TextEditingController();
    controller.allDrinkList();
    controller.loadDrinkCategories();
    controller.updateInitEntry();
  }

  @override
  void onDispose() {
    controller.searchController.dispose();
    controller.disposeAll();
  }
}
