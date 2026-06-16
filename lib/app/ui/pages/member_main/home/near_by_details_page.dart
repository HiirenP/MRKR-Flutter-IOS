import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/member_main/home/near_by_details_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/home/drinks_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/bar_review_submit_page.dart';
import 'package:marker/app/ui/pages/member_main/home/map_location_page.dart';
import 'package:marker/app/ui/pages/member_main/home/review_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/drink_category_dropdown.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/helpers/image_url_util.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NearByDetailsPage extends GetItHook<NearByDetailsController> {
  const NearByDetailsPage({super.key});

  static Future<T?>? route<T>({required String barId, bool isFriend = false}) {
    return Get.toNamed(AppRoutes.nearByDetailsPage, arguments: [barId, isFriend]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Obx(() {
            if (controller.isSuccess.value) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Obx(
                        () => controller.selectedTab.value
                            ? SizedBox(
                                height: 240,
                                child: PageView.builder(
                                  itemCount: controller.barDetails.value.images?.length,
                                  padEnds: false,
                                  controller: controller.pageController,
                                  itemBuilder: (_, index) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(18),
                                        bottomRight: Radius.circular(18),
                                      ),
                                      child: ImageView(controller.barDetails.value.images?[index].url ?? ''),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox(),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: AppCustomAppbar(),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Obx(
                          () => controller.selectedTab.value
                              ? Center(
                                  child: SmoothPageIndicator(
                                    controller: controller.pageController,
                                    count: controller.barDetails.value.images?.length ?? 0,
                                    effect: WormEffect(
                                      dotHeight: 12,
                                      dotWidth: 12,
                                      activeDotColor: context.colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                  const Gap(5),
                  Padding(
                    padding: const AppEdgeInsets.h16(),
                    child: Obx(
                      () => controller.selectedTab.value
                          ? Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ImageView(
                                            controller.logo ?? '',
                                            shape: BoxShape.circle,
                                            inner: ImageSize(
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                          const Gap(6),
                                          Expanded(
                                            child: AppText(
                                              controller.barName ?? '',
                                              style: context.textTheme.titleSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(6),
                                      GestureDetector(
                                        onTap: () {
                                          ReviewPage.route(barId: controller.barDetails.value.barId);
                                        },
                                        child: Row(
                                          children: [
                                            ImageView(Assets.svg.sStar),
                                            const Gap(5),
                                            AppText(
                                              controller.averageRating ?? '0.0',
                                              style: context.textTheme.bodySmall,
                                            ),
                                            const Gap(5),
                                            SingleLineText(
                                              AppStrings.T.reviews(controller.totalReviews ?? '0.0'),
                                              style: context.textTheme.bodySmall,
                                            ),
                                            const Gap(12),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () async {
                                                final myReview = controller.barDetails.value.myReview;
                                                final updated = await Get.toNamed(
                                                  AppRoutes.barReviewSubmitPage,
                                                  arguments: {
                                                    'barId': controller.barDetails.value.barId ?? '',
                                                    'barName': controller.barName ?? '',
                                                    'reviewId': myReview?.sId,
                                                    'review': myReview?.review,
                                                    'reviewStars': myReview?.stars,
                                                  },
                                                );
                                                if (updated == true) {
                                                  await controller.getBarDetails(controller.barDetails.value.barId);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                child: Obx(
                                                  () => AppText(
                                                    controller.hasMyBarReview.value ? 'Edit Review' : AppStrings.T.writeReview,
                                                    style: context.textTheme.bodySmall?.copyWith(
                                                      color: context.colorScheme.primary,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                EllipsisContainer(
                                  label: controller.openClose,
                                  bgColor: controller.openClose != AppStrings.T.closed
                                      ? context.colorScheme.onPrimaryContainer
                                      : context.colorScheme.secondaryFixedDim,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ),
                  TabBar(
                    tabs: [Tab(text: AppStrings.T.about), Tab(text: AppStrings.T.drinks)],
                    unselectedLabelColor: context.colorScheme.secondaryFixedDim,
                    labelColor: context.colorScheme.onSecondary,
                    controller: controller.tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3, color: context.colorScheme.primary),
                      insets: EdgeInsets.symmetric(horizontal: Get.width / 3),
                    ),
                    unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                    dividerColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.5),
                    labelStyle: context.textTheme.bodyMedium,
                    onTap: (int tab) {},
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        Obx(
                          () => controller.selectedTab.value
                              ? ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: controller.aboutList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (index == 3) {
                                              MapLocationPage.route(
                                                data: controller.barDetails.value,
                                              );
                                            }
                                          },
                                          child: ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: CircularContainer(
                                                imagePath: controller.aboutList[index].icon!,
                                              ),
                                            ),
                                            title: AppText(
                                              controller.aboutList[index].title!,
                                              style: context.textTheme.displaySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: AppText(controller.aboutList[index].subTitle!, style: context.textTheme.bodySmall),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Container(
                                      height: 150,
                                      margin: const AppEdgeInsets.h16(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: GoogleMap(
                                          zoomControlsEnabled: false,
                                          onMapCreated: (controllers) {
                                            controller.googleMapController = controllers;
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target: controller.origin.value,
                                            zoom: 17,
                                          ),
                                          markers: Set<Marker>.of(controller.markers),
                                          onTap: (latLong) {}, // Ensure this is a Set
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      margin: const AppEdgeInsets.all16(),
                                      padding: const AppEdgeInsets.all8(),
                                      decoration: BoxDecoration(color: context.colorScheme.secondary, borderRadius: BorderRadius.circular(15)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppText(AppStrings.T.barOwner,
                                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryContainer)),
                                          Obx(
                                            () => controller.selectedTab.value
                                                ? ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    leading: ImageView(
                                                      controller.oProfile ?? Assets.svg.profileCircle,
                                                      shape: BoxShape.circle,
                                                      inner: ImageSize(height: 45, width: 45),
                                                    ),
                                                    title: AppText(controller.oName ?? '', style: context.textTheme.titleSmall),
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                        Obx(
                          () => !controller.selectedTab.value
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const AppEdgeInsets.h16(),
                                      child: DrinkCategoryDropdown(
                                        categories: controller.drinkCategories,
                                        selectedId: controller.selectedCategoryId.value,
                                        includeAllOption: true,
                                        allOptionLabel: 'All categories',
                                        onChanged: controller.onDrinkCategoryFilterChanged,
                                      ),
                                    ),
                                    Expanded(
                                      child: controller.drinkList.isEmpty
                                          ? EmptyScreen(title: AppStrings.T.drinkBarTitle)
                                          : GridView.builder(
                                              padding: const AppEdgeInsets.all16(),
                                              itemCount: controller.drinkList.length,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 15,
                                                  mainAxisSpacing: 15,
                                                  mainAxisExtent: 150),
                                              itemBuilder: (BuildContext context, int index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    debugPrint(
                                                        'drinkDetails------barId--------${controller.drinkList[index].sId}');
                                                    await DrinkDetailsView.route(
                                                      barId: controller.drinkList[index].sId,
                                                      isShow: true,
                                                      isFriend: controller.isFriend,
                                                    );
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.bottomCenter,
                                                    children: [
                                                      ImageView(
                                                        listImageUrl(
                                                          controller.drinkList[index].image,
                                                          thumbUrl: controller.drinkList[index].imageThumb,
                                                        ),
                                                        borderRadius: BorderRadius.circular(18),
                                                        inner: ImageSize(width: double.infinity, height: 175),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          width: 160,
                                                          height: 40,
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
                                                                    controller.drinkList[index].name ?? '',
                                                                    style: context.textTheme.bodySmall,
                                                                  ),
                                                                ),
                                                                AppText(
                                                                  AppValidations.getFormattedPrice(
                                                                      controller.drinkList[index].price ?? ''),
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
                                    ),
                                  ],
                                ),
                        )
                      ],
                    ),
                  ),
                  const CustomSizedBox()
                ],
              );
            }
            return Visibility(visible: controller.isSuccess.value, child: const SizedBox.shrink());
          }),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.isSuccess.value = false;
    controller.tabBarViewInit();

    if (Get.arguments != null) {
      if (Get.arguments[0] is String) {
        final id = Get.arguments[0] as String;
        controller.getBarDetails(id);
      }
      if (Get.arguments[1] is bool) {
        controller.isFriend = Get.arguments[1] as bool;
        debugPrint('controller.isFriend-->${controller.isFriend}');
      }
    }
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
