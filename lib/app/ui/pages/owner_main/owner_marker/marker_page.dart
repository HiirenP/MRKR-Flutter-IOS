import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/owner_marker/marker_controller.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_details_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';

class MarkerPage extends GetItHook<MarkerController> {
  const MarkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Padding(
        padding: const AppEdgeInsets.all16(),
        child: Column(
          children: [
            AppCustomAppbar(
              appTitle: AppStrings.T.markers,
              isHideBackButton: true,
              isPadding: true,
            ),
            const Gap(20),
            Container(
              padding: const AppEdgeInsets.all8(),
              decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(
                () => Row(
                  children: [
                    buildButton(
                      AppStrings.T.upcoming,
                      controller.isSelected.value,
                      () {
                        if (!controller.isSelected.value) {
                          controller.isSelected.value = true;
                          controller.isEndPage.value = false;
                          controller.redeemedUpcomingData.clear();
                          controller.page = 1;
                          controller.fetchRedeemedUpcomingData();
                        }
                      },
                    ),
                    const Gap(5),
                    buildButton(
                      AppStrings.T.redeemed,
                      !controller.isSelected.value,
                      () {
                        if (controller.isSelected.value) {
                          controller.isSelected.value = false;
                          controller.isEndPage.value = false;
                          controller.redeemedUpcomingData.clear();
                          controller.page = 1;
                          controller.fetchRedeemedUpcomingData();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),
            Obx(() {
              final markers = controller.redeemedUpcomingData;
              final isLoading = controller.upcomingState.value.isLoading;
              if (isLoading && markers.isEmpty) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (markers.isEmpty) {
                return Expanded(
                  child: EmptyScreen(
                    title: controller.isSelected.value ? AppStrings.T.upcomingTitle : AppStrings.T.redeemedTitle,
                    subTitle: AppStrings.T.upcomingSubtitle,
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                        controller: controller.scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: markers.length + (controller.hasMoreData.value ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index > markers.length - 1 && controller.hasMoreData.value) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final list = markers[index];

                          return GestureDetector(
                            onTap: () {
                              UpcomingMarkerDetailsPage.route(drink: list, isHideCode: controller.isSelected.value);
                            },
                            child: Container(
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
                                      list.drinkId?.image ?? '',
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
                                            Expanded(child: AppText(list.drinkId?.name ?? '', style: context.textTheme.titleSmall)),
                                            AppText(
                                              AppValidations.getFormattedPrice(list.barMarkerTotal),
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
                                              list.ownerId?.profile ?? '',
                                              inner: ImageSize(height: 20, width: 20),
                                              shape: BoxShape.circle,
                                            ),
                                            const Gap(5),
                                            AppText(
                                              list.ownerId?.name ?? '',
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
                                            ImageView(Assets.svg.ticket),
                                            const Gap(5),
                                            AppText(
                                              !controller.isSelected.value ? '${list.secretCode}' : hideText(list.secretCode, format: '#'),
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.secondaryContainer,
                                              ),
                                            )
                                          ],
                                        ),
                                        if (controller.isSelected.value) ...[
                                          const Gap(3),
                                          AppText(
                                            '${DateUtil.instance.dateDFormat(list.createdAt ?? '')} | ${DateUtil.instance.dateDFormat(list.createdAt ?? '', format: DateUtil.instance.hhMMA)}',
                                            style: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.secondaryContainer,
                                            ),
                                          ),
                                        ],
                                        if (!controller.isSelected.value && (list.redeemedAt?.isNotEmpty ?? false)) ...[
                                          const Gap(3),
                                          Row(
                                            children: [
                                              AppText(
                                                '${DateUtil.instance.dateDFormat(list.redeemedAt ?? '')} | ',
                                                style: context.textTheme.bodySmall?.copyWith(
                                                  color: context.colorScheme.secondaryContainer,
                                                ),
                                              ),
                                              AppText(
                                                DateUtil.instance.dateDFormat(
                                                  list.redeemedAt ?? '',
                                                  format: DateUtil.instance.hhMMA,
                                                ),
                                                style: context.textTheme.bodySmall?.copyWith(
                                                  color: context.colorScheme.secondaryContainer,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if ((list.scannedBy?.name ?? '').isNotEmpty) ...[
                                            const Gap(3),
                                            AppText(
                                              'Redeemed by - ${list.scannedBy!.name}',
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.secondaryContainer,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? Get.context!.colorScheme.primary : Get.context!.colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: AppText(
            label,
            style: Get.context!.textTheme.labelMedium?.copyWith(
              color: isSelected ? Get.context!.colorScheme.onSecondary : Get.context!.colorScheme.secondaryFixedDim,
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
  void onDispose() {}
}
