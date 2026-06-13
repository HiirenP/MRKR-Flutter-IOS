import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/member_main/home/home_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_page.dart';
import 'package:marker/app/ui/pages/member_main/home/search_page.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart';
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_page.dart';
import 'package:marker/app/ui/pages/member_main/message/video_call_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/image_url_util.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends GetItHook<HomeController> {
  const HomePage({super.key});

  static Future<T?>? offAllRoute<T>() {
    return Get.offNamed(AppRoutes.homePage);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                child: ImageView(
                  Assets.svg.mainBg,
                  inner: ImageSize(height: 200, width: Get.width),
                ),
              ),
              Padding(
                padding: const AppEdgeInsets.all16(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          AppStrings.T.welcome,
                          style: context.textTheme.labelSmall,
                        ),
                        const Gap(5),
                        Obx(
                          () => AppText(
                            '${controller.userName.value} 👋🏻',
                            style: context.textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: SearchPage.route,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: context.colorScheme.onSecondary.withAlpha(35),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: context.colorScheme.primary,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: context.colorScheme.onSecondary.withAlpha(35),
                            child: ImageView(
                              Assets.svg.searchNormal,
                              color: context.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Gap(15),
          Expanded(
            child: ListView(
              padding: const AppEdgeInsets.h12(),
              children: [
                // FutureBuilder<SharedPreferences>(
                //   future: SharedPreferences.getInstance(),
                //   builder: (context, snapshot) {
                //     final isEnabled = snapshot.data?.getTapToPayEnabled ?? false;
                //     if (isEnabled) {
                //       return const SizedBox();
                //     }
                //     return Container(
                //       margin: const AppEdgeInsets.oB15(),
                //       padding: const AppEdgeInsets.all14(),
                //       decoration: BoxDecoration(
                //         color: context.colorScheme.secondary,
                //         borderRadius: BorderRadius.circular(16),
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           AppText(
                //             AppStrings.T.acceptPaymentsWithTapToPay,
                //             style: context.textTheme.bodyMedium,
                //           ),
                //           const Gap(8),
                //           AppButton(
                //             label: AppStrings.T.enableNow,
                //             onPressed: () async {
                //               await TapToPayEnablePage.route();
                //             },
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
                Obx(() {
                  if (!controller.isUpcoming.value) {
                    return const SizedBox();
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: AppText(
                          AppStrings.T.myMarkers,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      GestureDetector(
                        onTap: UpcomingMarkerPage.route,
                        child: AppText(
                          AppStrings.T.seeAll,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  if (!controller.isUpcoming.value) {
                    return const SizedBox();
                  }
                  if (controller.upComingMarker.isEmpty) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: controller.upComingMarker.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final upcoming = controller.upComingMarker[index];
                        return GestureDetector(
                          onTap: () {
                            UpcomingMarkerDetailsPage.route(isShowBtn: true, data: upcoming.sId, isHideCode: false)?.then(
                              (value) {
                                if (value != null && value is bool) {
                                  if (value) {
                                    controller.upComingMarker.removeAt(index);
                                  }
                                }
                              },
                            );
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const AppEdgeInsets.oR8(),
                                child: ImageView(
                                  upcoming.drinkId?.image ?? '',
                                  borderRadius: BorderRadius.circular(18),
                                  inner: ImageSize(width: 150, height: 140),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 8,
                                child: Container(
                                  width: 160,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.onSecondary.withValues(alpha: 0.4),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(18),
                                      bottomRight: Radius.circular(18),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const AppEdgeInsets.h10(),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: AppText(
                                            upcoming.drinkId?.name ?? '',
                                            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onPrimary),
                                          ),
                                        ),
                                        ImageView(
                                          upcoming.ownerId?.profile ?? '',
                                          shape: BoxShape.circle,
                                          inner: ImageSize(width: 22, height: 22),
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
                Obx(() {
                  if (!controller.isNear.value) {
                    return const SizedBox();
                  }
                  return Row(
                    children: [
                      AppText(
                        AppStrings.T.nearByMarkerBars,
                        style: context.textTheme.titleSmall,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: NearByPage.route,
                        child: AppText(
                          AppStrings.T.seeAll,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  );
                }),
                const Gap(5),
                Obx(() {
                  if (!controller.isNear.value) {
                    return const SizedBox();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.nearbyBars.length,
                    itemBuilder: (BuildContext context, int index) {
                      final nearby = controller.nearbyBars[index];
                      final image = barListImageUrl(
                        logo: nearby.logo,
                        logoThumb: nearby.logoThumb,
                        images: nearby.images
                            ?.map((img) => (url: img.url, urlThumb: img.urlThumb))
                            .toList(),
                      );
                      return GestureDetector(
                        onTap: () {
                          debugPrint('BAR-ID==>${nearby.barId}');
                          NearByDetailsPage.route(barId: nearby.barId ?? '');
                        },
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
                                  image,
                                  borderRadius: BorderRadius.circular(18),
                                  inner: ImageSize(width: 115, height: 140),
                                ),
                              ),
                              const Gap(5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: AppText(nearby.name?.capitalize ?? '', style: context.textTheme.titleSmall),
                                    ),
                                    const Gap(3),
                                    Row(
                                      children: [
                                        ImageView(Assets.svg.clock),
                                        const Gap(5),
                                        AppText(
                                          '${utcToLocalTime(nearby.openingHours?.open ?? '')} - ${utcToLocalTime(nearby.openingHours?.close ?? '', index: index)}',
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: context.colorScheme.secondaryContainer,
                                          ),
                                        ),
                                        const Gap(1),
                                      ],
                                    ),
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
                                            distanceMi: nearby.distanceMi,
                                            distanceKm: nearby.distance,
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
                                          '${double.tryParse(nearby.averageRating.toString())?.toStringAsFixed(1) ?? '0.0'}',
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: context.colorScheme.secondaryContainer,
                                          ),
                                        ),
                                        const Gap(5),
                                        AppText(
                                          AppStrings.T.reviews('${nearby.reviewCount ?? nearby.totalReviews ?? 0}'),
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
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  Future<void> onInit() async {
    await controller.getUserData();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (!prefs.getTapToPayAwarenessShown && Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Get.bottomSheet(
          AppBottomSheet(
            title: AppStrings.T.tapToPayiPhone,
            subTitle: AppStrings.T.acceptPaymentsWithTapToPay,
            positiveButtonTitle: AppStrings.T.enableNow,
            negativeButtonTitle: AppStrings.T.noThanks,
            onPositivePressed: () async {
              prefs.setTapToPayAwarenessShown = true;
              Get.back();
              await TapToPayEnablePage.route();
            },
            onNegativePressed: () {
              prefs.setTapToPayAwarenessShown = true;
              Get.back();
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
          ),
        );
      });
    }
    final data = prefs.getString('call_data');

    debugPrint('data==>$data');
    Map<String, dynamic>? map;
    if (data != null && data.trim().isNotEmpty && data != 'null') {
      try {
        if (data.contains('"data":')) {
          final temp = jsonDecode(data);
          map = jsonDecode(temp['data'].toString()) as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint('data==>catch<===>$e');
        e.printError();
      }

      await prefs.remove('call_data');
      getIt<SharedPreferences>().setDisconnect = 'false';
      final isRemoteDeclined = prefs.getBool('remote_user_declined') ?? false;
      if (!isRemoteDeclined) {
        await prefs.setBool('remote_user_declined', false);
        await VideoCallPage.route(model: map ?? jsonDecode(data));
      }
    }
    await prefs.setBool('remote_user_declined', false);
    await controller.fetchBarOwnerHomeData();
  }

  @override
  void onDispose() {
    controller.nearbyBars.value = [];
    controller.upComingMarker.value = [];
  }
}
