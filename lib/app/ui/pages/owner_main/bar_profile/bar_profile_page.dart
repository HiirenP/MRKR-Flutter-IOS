import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/bar_profile_controller.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/home/review_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/bar_profile_about_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/bar_profile_drink_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/edit_bar_profile_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BarProfilePage extends GetItHook<BarProfileController> {
  const BarProfilePage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.barProfilePage);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Obx(
          () {
            if (!controller.isFetch.value || controller.getBarDetailsData?.value == null) {
              return const SizedBox();
            }

            return Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        height: 290,
                        child: PageView.builder(
                          itemCount: controller.getBarDetailsData?.value.images?.length,
                          padEnds: false,
                          controller: controller.pageController,
                          itemBuilder: (_, index) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              child: ImageView(controller.getBarDetailsData!.value.images?[index].url ?? ''),
                            );
                          },
                        )),
                    AppConstant.isOwnerLogin(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 35, left: 10),
                      child: AppCustomAppbar(
                        isHideBackButton: true,
                        appTitle: AppStrings.T.barProfile,
                        isSecondaryIcon: true,
                        color: context.colorScheme.onPrimary,
                        secondaryIconName: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ImageView(Assets.svg.edit),
                        ),
                        onSecondaryTap: () {
                          EditBarProfilePage.route(controller.getBarDetailsData?.value)!.then((val) {
                            if (val != null && val is BarGetUpdateData) {
                              controller.isFetch.value = false;
                              controller.selectedTab.value = 0;
                              controller.tabController?.animateTo(controller.selectedTab.value);
                              controller.fetchBarOwnerData();
                            }
                          });
                        },
                      ),
                    )),
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: controller.pageController,
                          count: controller.getBarDetailsData?.value.images?.length ?? 0,
                          effect: WormEffect(
                            dotHeight: 12,
                            dotWidth: 12,
                            activeDotColor: context.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const AppEdgeInsets.h16(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Gap(8),
                              Row(
                                children: [
                                  ImageView(
                                    controller.getBarDetailsData?.value.logo ?? '',
                                    inner: ImageSize(height: 45, width: 45),
                                    shape: BoxShape.circle,
                                  ),
                                  const Gap(8),
                                  Expanded(
                                    child: AppText(
                                      controller.getBarDetailsData?.value.name ?? '',
                                      style: context.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              GestureDetector(
                                onTap: () {
                                  ReviewPage.route(barId: getIt<SharedPreferences>().getBarId);
                                },
                                child: Row(
                                  children: [
                                    ImageView(Assets.svg.sStar),
                                    const Gap(5),
                                    AppText(
                                      controller.getBarDetailsData?.value.averageRating?.toStringAsFixed(1) ?? '0',
                                      style: context.textTheme.bodySmall,
                                    ),
                                    const Gap(5),
                                    SingleLineText(
                                      AppStrings.T.reviews(controller.getBarDetailsData?.value.totalReviews?.toString() ?? '0'),
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () {
                            final isAvailable = isBarOpenOrClose(
                              isOpenToday: controller.getBarDetailsData?.value.isOpenToday ?? false,
                              openTime: controller.getBarDetailsData?.value.openingHours?.open ?? '',
                              closeTime: controller.getBarDetailsData?.value.openingHours?.close ?? '',
                            );
                            return EllipsisContainer(
                              label: isAvailable ? AppStrings.T.openNow : AppStrings.T.closed,
                              bgColor: isAvailable ? context.colorScheme.onPrimaryContainer : context.colorScheme.secondaryFixedDim,
                            );
                          },
                        ),
                      ],
                    )),
                if (controller.tabController != null)
                  TabBar(
                    tabs: [Tab(text: AppStrings.T.about), Tab(text: AppStrings.T.drinks)],
                    unselectedLabelColor: context.colorScheme.secondaryFixedDim,
                    labelColor: context.colorScheme.onSecondary,
                    controller: controller.tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3, color: context.colorScheme.primary),
                      insets: EdgeInsets.symmetric(horizontal: Get.width / 3),
                    ),
                    dividerColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.5),
                    unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                    labelStyle: context.textTheme.bodyMedium,
                    onTap: (int tab) {
                      controller.selectedTab.value = tab;
                      controller.tabSelection(tab);
                    },
                  ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: const [
                      BarProfileAboutPage(),
                      BarProfileDrinkPage(),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }

  @override
  bool get canDisposeController => true;

  @override
  Future<void> onInit() async {
    controller.resetValue();
    controller.pageController = PageController();
    controller.tabBarViewInit();

    await controller.fetchBarOwnerData();
  }

  @override
  void onDispose() {
    controller.tabController?.dispose();
    controller.resetValue();
  }
}
