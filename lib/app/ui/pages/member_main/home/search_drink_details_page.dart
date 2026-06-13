import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart' show Gap;
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/search_drink_details_controller.dart';
import 'package:marker/app/data/models/search_drinks_model/search_drinks_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/home/drinks_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_details_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/review_list.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';

class SearchDrinkDetailsPage extends GetItHook<SearchDrinkDetailsController> {
  const SearchDrinkDetailsPage({super.key});

  static Future<T?>? route<T>({SearchDrinksList? drink}) {
    return Get.toNamed(AppRoutes.searchDrinkDetailsPage, arguments: drink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Obx(
            () => Column(
              children: [
                Stack(
                  children: [
                    if (controller.isFetch.value)
                      ImageView(
                        controller.drinkDetails.value.image ?? '',
                        inner: ImageSize(
                          height: 290,
                          width: double.infinity,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: AppCustomAppbar(
                        secondaryIconName: ImageView(Assets.svg.export),
                        isSecondaryIcon: true,
                        onSecondaryTap: () {
                          final message = AppStrings.T.shareDrinkBarMessage(controller.drinkDetails.value.name ?? '', controller.barName ?? '');
                          shareMessage(message: message);
                        },
                      ),
                    ),
                  ],
                ),
                if (controller.isFetch.value)
                  Expanded(
                    child: Column(
                      children: [
                        const Gap(5),
                        Padding(
                          padding: const AppEdgeInsets.h16(),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => AppText(
                                        controller.drinkDetails.value.name?.capitalize ?? '',
                                        style: context.textTheme.titleSmall,
                                      ),
                                    ),
                                    Obx(
                                      () => Row(
                                        children: [
                                          ImageView(Assets.svg.sStar),
                                          const Gap(5),
                                          AppText(
                                            controller.drinkDetails.value.reviewStats?.avgRating.toString() ?? '',
                                            style: context.textTheme.bodySmall,
                                          ),
                                          const Gap(5),
                                          SingleLineText(
                                            AppStrings.T.reviews(
                                              controller.drinkDetails.value.reviewStats?.total.toString() ?? '',
                                            ),
                                            style: context.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => AppText(
                                  AppValidations.getFormattedPrice(controller.drinkDetails.value.price ?? 0),
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(5),
                        TabBar(
                          tabs: [Tab(text: AppStrings.T.about), Tab(text: AppStrings.T.review)],
                          unselectedLabelColor: context.colorScheme.secondaryFixedDim,
                          labelColor: context.colorScheme.onSecondary,
                          unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                          controller: controller.tabController,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 3, color: context.colorScheme.primary),
                            insets: EdgeInsets.symmetric(horizontal: Get.width / 3),
                          ),
                          dividerColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.5),
                          labelStyle: context.textTheme.bodyMedium,
                          onTap: (int tab) {
                            controller.selectedTab.value = tab;
                            controller.update();
                          },
                        ),
                        const Gap(15),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [
                              ListView(
                                padding: const AppEdgeInsets.h16(),
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircularContainer(
                                        imagePath: Assets.svg.documentText,
                                      ),
                                      const Gap(5),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            AppStrings.T.beerDescription,
                                            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                          ),
                                          Padding(
                                            padding: const AppEdgeInsets.v5(),
                                            child: Obx(
                                              () => AppText(
                                                controller.drinkDetails.value.description ?? '',
                                                style: context.textTheme.bodySmall,
                                                maxLines: 15,
                                              ),
                                            ),
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => NearByDetailsPage.route(
                                      barId: controller.drinkDetails.value.barId ?? '',
                                    ),
                                    child: Container(
                                      padding: const AppEdgeInsets.all12(),
                                      margin: const AppEdgeInsets.v16(),
                                      decoration: BoxDecoration(color: context.colorScheme.secondary, borderRadius: BorderRadius.circular(18)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppText(AppStrings.T.barProfile, style: context.textTheme.bodyMedium),
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: SizedBox(
                                              width: 55,
                                              height: 55,
                                              child: CircleAvatar(
                                                radius: 30,
                                                child: ImageView(
                                                  controller.image ?? '',
                                                  shape: BoxShape.circle,
                                                  fit: BoxFit.fill,
                                                  outer: ImageSize(width: 55, height: 55),
                                                ),
                                              ),
                                            ),
                                            title: AppText(
                                              controller.barName?.capitalize ?? '',
                                              style: context.textTheme.titleSmall,
                                            ),
                                            trailing: ImageView(Assets.svg.exportCircle),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() {
                                if (controller.drinkDetails.value.latestReviews == null || controller.drinkDetails.value.latestReviews!.isEmpty) {
                                  return EmptyScreen(subTitle: AppStrings.T.drinkReviewSubtitle);
                                }
                                return Padding(
                                  padding: const AppEdgeInsets.all8(),
                                  child: ReviewList(reviews: controller.drinkDetails.value.latestReviews!),
                                );
                              })
                            ],
                          ),
                        ),
                        Padding(
                          padding: const AppEdgeInsets.all16(),
                          child: AppButton(
                              label: AppStrings.T.buyNow,
                              onPressed: () {
                                DrinkDetailsView.route(drink: controller.drinkData)?.then(
                                  (value) {
                                    if (value != null && value is bool) {
                                      Get.back(result: value);
                                    }
                                  },
                                );
                              }),
                        ),
                        const CustomSizedBox(),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.tabBarViewInit();

    if (Get.arguments != null) {
      if (Get.arguments is SearchDrinksList) {
        controller.drinkData = Get.arguments as SearchDrinksList;
        controller.drinksId = controller.drinkData.sId ?? '';
        controller.barName = controller.drinkData.bar?.name ?? '';
        controller.image = controller.drinkData.bar?.logo ?? '';
        controller.getDrinkDetails();
      }
    }
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
