import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/near_by_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/home/map_near_by_bar_page.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_details_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/image_url_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class NearByPage extends GetItHook<NearByController> {
  const NearByPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.nearByPage);
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
                  appTitle: AppStrings.T.nearByMarkerBars,
                  isPadding: true,
                  isSecondaryIcon: true,
                  secondaryIconName: Icon(
                    Icons.pin_drop_outlined,
                    size: 20,
                    color: context.theme.primaryColor,
                  ),
                  onSecondaryTap: MapNearByBarPage.route,
                ),
                const Gap(15),
                Obx(
                  () => Expanded(
                    child: controller.isDataEmpty.value
                        ? EmptyScreen(title: AppStrings.T.nearByBarTitle)
                        : ListView.builder(
                            controller: controller.scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: controller.nearByList.length + (controller.hasMoreData.value ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index > controller.nearByList.length - 1 && controller.hasMoreData.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              final list = controller.nearByList[index];
                              final image = barListImageUrl(
                                logo: list.logo,
                                logoThumb: list.logoThumb,
                                images: list.images
                                    ?.map((img) => (url: img.url, urlThumb: img.urlThumb))
                                    .toList(),
                              );
                              return GestureDetector(
                                onTap: () => NearByDetailsPage.route(barId: list.barId ?? ''),
                                child: Container(
                                  height: 135,
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
                                          image,
                                          borderRadius: BorderRadius.circular(18),
                                          inner: ImageSize(width: 104, height: 114),
                                        ),
                                      ),
                                      const Gap(5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AppText(
                                              list.name?.capitalize ?? '',
                                              style: context.textTheme.bodyMedium,
                                            ),
                                            const Gap(3),
                                            Row(
                                              children: [
                                                ImageView(Assets.svg.clock),
                                                const Gap(5),
                                                AppText(
                                                  '${utcToLocalTime(list.openingHours?.open ?? '')} - ${utcToLocalTime(list.openingHours?.close ?? '')}',
                                                  style: context.textTheme.bodySmall?.copyWith(
                                                    color: context.colorScheme.secondaryContainer,
                                                  ),
                                                ),
                                                const Gap(1),
                                              ],
                                            ),
                                            const Gap(3),
                                            Row(
                                              children: [
                                                ImageView(
                                                  Assets.svg.routing,
                                                  color: context.colorScheme.primary,
                                                  inner: ImageSize(height: 20, width: 20),
                                                ),
                                                const Gap(5),
                                                AppText(
                                                  formatBarDistanceMi(
                                                    distanceMi: list.distanceMi,
                                                    distanceKm: list.distance,
                                                  ),
                                                  style: context.textTheme.bodySmall?.copyWith(
                                                    color: context.colorScheme.secondaryContainer,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ImageView(Assets.svg.sStar),
                                                const Gap(5),
                                                AppText(
                                                  '${double.tryParse(list.averageRating.toString())?.toStringAsFixed(1) ?? '0.0'}',
                                                  style: context.textTheme.bodySmall?.copyWith(
                                                    color: context.colorScheme.secondaryContainer,
                                                  ),
                                                ),
                                                const Gap(5),
                                                AppText(
                                                  AppStrings.T.reviews('${list.reviewCount ?? list.totalReviews ?? 0}'),
                                                  style: context.textTheme.bodySmall?.copyWith(
                                                    color: context.colorScheme.secondaryContainer,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
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
  Future<void> onInit() async {
    controller.updateInitEntry();
  }

  @override
  void onDispose() {
    controller.page = 1;
    controller.hasMoreData = false.obs;
    controller.isDataEmpty = false.obs;
    controller.isEndPage = false.obs;
    controller.nearByList.value = [];
    controller.locationService.stopListening();
  }
}
