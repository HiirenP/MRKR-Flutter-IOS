import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/upcoming_marker_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_details_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/marker_display_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class UpcomingMarkerPage extends GetItHook<UpcomingMarkerController> {
  const UpcomingMarkerPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.upcomingMarkerPage);
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
                  appTitle: AppStrings.T.myMarkers,
                  isPadding: true,
                ),
                const Gap(20),
                Obx(
                  () => Expanded(
                    child: controller.isDataEmpty.value
                        ? EmptyScreen(
                            title: AppStrings.T.upcomingTitle,
                            subTitle: AppStrings.T.upcomingSubtitle,
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: controller.upComingList.length + (controller.hasMoreData.value ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index > controller.upComingList.length - 1 && controller.hasMoreData.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              final upcoming = controller.upComingList[index];
                              final isRedeemed = upcoming.status == 'redeemed';

                              return GestureDetector(
                                onTap: () {
                                  UpcomingMarkerDetailsPage.route(isShowBtn: true, data: upcoming.sId, isHideCode: false)?.then(
                                    (value) {
                                      if (value != null && value is bool) {
                                        if (value) {
                                          final model = controller.upComingList[index];
                                          model.status = 'redeemed';
                                          controller.upComingList[index] = model;
                                        }
                                      }
                                    },
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
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
                                              upcoming.drinkId?.image ?? '',
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
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: AppText(upcoming.drinkId?.name ?? '', style: context.textTheme.bodyMedium),
                                                    ),
                                                    AppText(
                                                      AppValidations.getFormattedPrice(upcoming.memberSpendTotal),
                                                      style: context.textTheme.bodyMedium?.copyWith(
                                                        color: context.colorScheme.primary,
                                                      ),
                                                    ),
                                                    const Gap(10),
                                                  ],
                                                ),
                                                const Gap(3),
                                                Row(
                                                  children: [
                                                    ImageView(
                                                      upcoming.holder?.profile ?? '',
                                                      shape: BoxShape.circle,
                                                      inner: ImageSize(height: 22, width: 22),
                                                    ),
                                                    const Gap(5),
                                                    Expanded(
                                                      child: AppText(
                                                        upcoming.holder?.name ?? '',
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: context.colorScheme.secondaryContainer,
                                                        ),
                                                      ),
                                                    ),
                                                    const Gap(1),
                                                  ],
                                                ),
                                                const Gap(3),
                                                Row(
                                                  children: [
                                                    ImageView(
                                                      Assets.svg.location,
                                                      color: context.colorScheme.primary,
                                                      inner: ImageSize(height: 18, width: 18),
                                                    ),
                                                    const Gap(5),
                                                    Expanded(
                                                      child: AppText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        upcoming.barId?.address ?? '',
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: context.colorScheme.secondaryContainer,
                                                        ),
                                                      ),
                                                    ),
                                                    const Gap(1),
                                                  ],
                                                ),
                                                const Gap(3),
                                                Row(
                                                  children: [
                                                    ImageView(
                                                      Assets.svg.ticket,
                                                      color: context.colorScheme.primary,
                                                      inner: ImageSize(height: 18, width: 18),
                                                    ),
                                                    const Gap(5),
                                                    AppText(
                                                      upcoming.secretCode ?? '',
                                                      style: context.textTheme.bodySmall?.copyWith(
                                                        color: context.colorScheme.secondaryContainer,
                                                      ),
                                                    ),
                                                    const Gap(1),
                                                  ],
                                                ),
                                                if (!isRedeemed) ...[
                                                  const Gap(3),
                                                  AppText(
                                                    '${DateUtil.instance.dateDFormat(upcoming.holderDate ?? '')} | ${DateUtil.instance.dateDFormat(upcoming.holderDate ?? '', format: DateUtil.instance.hhMMA)}',
                                                    style: context.textTheme.bodySmall?.copyWith(
                                                      color: context.colorScheme.secondaryContainer,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (isRedeemed)
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const AppEdgeInsets.oB15(),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                              child: Container(
                                                color: Colors.black.withValues(alpha: 0.5),
                                                alignment: Alignment.center,
                                                child: AppText(
                                                  AppStrings.T.redeemed,
                                                  style: context.textTheme.bodySmall?.copyWith(
                                                    color: context.colorScheme.onPrimary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
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
  void onInit() {
    controller.updateInitEntry();
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
