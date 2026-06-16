import 'package:dotted_line/dotted_line.dart' show DottedLine;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/upcoming_marker_details_controller.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/home/map_location_page.dart';
import 'package:marker/app/ui/pages/member_main/home/marker_redeemed_page.dart';
import 'package:marker/app/ui/pages/member_main/home/send_to_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown_section.dart';
import 'package:marker/app/ui/widgets/platform_fee_breakdown.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/marker_display_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UpcomingMarkerDetailsPage extends GetItHook<UpcomingMarkerDetailsController> {
  const UpcomingMarkerDetailsPage({super.key});

  static Future<T?>? route<T>({
    bool isShowBtn = false,
    String? data,
    RedeemedUpcomingListData? drink,
    String? qrCode,
    String? type,
    bool isHideCode = true,
  }) {
    debugPrint('type-->$type');
    return Get.toNamed(AppRoutes.upcomingMarkerDetailsPage, arguments: [data, drink, qrCode, type ?? 'qr', isHideCode, isShowBtn]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          if (controller.isSuccess.value) {
            final drink = controller.drinkData.value;
            return Column(
              children: [
                Padding(
                  padding: const AppEdgeInsets.all16(),
                  child: AppCustomAppbar(
                    appTitle: drink.drinkId?.name ?? '',
                    isPadding: true,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const AppEdgeInsets.h16(),
                          children: [
                            Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  padding: const AppEdgeInsets.all8(),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      ImageView(
                                        drink.drinkId?.image ?? '',
                                        borderRadius: BorderRadius.circular(18),
                                        inner: ImageSize(height: 230, width: Get.width - 48),
                                      ),
                                      const Gap(25),
                                      DottedLine(dashColor: context.colorScheme.secondaryFixedDim.withAlpha(35)),
                                      const Gap(20),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: ImageView(
                                          drink.holder?.profile ?? '',
                                          shape: BoxShape.circle,
                                          inner: ImageSize(height: 40, width: 40),
                                        ),
                                        trailing: controller.isHideCode.value
                                            ? blurredText(
                                                hideText(drink.secretCode, format: '#'),
                                                isBlur: AppConstant.userType != UserType.member,
                                                style: context.textTheme.bodyMedium?.copyWith(
                                                  color: controller.isOwnerUpcoming.value ? context.colorScheme.primary : context.colorScheme.primary,
                                                ),
                                              )
                                            : AppText(
                                                drink.secretCode ?? '',
                                                style: context.textTheme.bodyMedium,
                                              ),
                                        title: AppText(
                                          drink.holder?.name ?? '',
                                          style: context.textTheme.bodyMedium,
                                        ),
                                        subtitle: (drink.redeemedAt?.isNotEmpty ?? false)
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      AppText(
                                                        '${DateUtil.instance.dateDFormat(drink.redeemedAt ?? '')} | ',
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: context.colorScheme.secondaryContainer,
                                                        ),
                                                      ),
                                                      AppText(
                                                        DateUtil.instance.dateDFormat(
                                                          drink.redeemedAt ?? '',
                                                          format: DateUtil.instance.hhMMA,
                                                        ),
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: context.colorScheme.secondaryContainer,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if ((drink.scannedBy?.name ?? '').isNotEmpty) ...[
                                                    const Gap(2),
                                                    AppText(
                                                      'Redeemed by - ${drink.scannedBy!.name}',
                                                      style: context.textTheme.bodySmall?.copyWith(
                                                        color: context.colorScheme.secondaryContainer,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              )
                                            : AppText(
                                                '${DateUtil.instance.dateDFormat(drink.holderDate ?? '')} | ${DateUtil.instance.dateDFormat(drink.holderDate ?? '', format: DateUtil.instance.hhMMA)}',
                                                style: context.textTheme.bodySmall?.copyWith(
                                                  color: context.colorScheme.secondaryContainer,
                                                ),
                                              ),
                                      ),
                                      DottedLine(
                                        dashColor: context.colorScheme.secondaryFixedDim.withAlpha(35),
                                        dashLength: 8,
                                      ),
                                      const Gap(15),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: context.colorScheme.onPrimary,
                                            child: ImageView(
                                              Assets.svg.documentText,
                                              color: context.colorScheme.primary,
                                            ),
                                          ),
                                          const Gap(5),
                                          Expanded(
                                            child: AppText(
                                              maxLines: 5,
                                              drink.drinkId?.description ?? '',
                                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryContainer),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(15),
                                      if (AppConstant.userType == UserType.member)
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                MapLocationPage.route(drink: drink);
                                              },
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 22,
                                                    backgroundColor: context.colorScheme.onPrimary,
                                                    child: ImageView(
                                                      Assets.svg.location,
                                                      color: context.colorScheme.primary,
                                                    ),
                                                  ),
                                                  const Gap(5),
                                                  Expanded(
                                                    child: AppText(
                                                      drink.barId?.address ?? '',
                                                      style: context.textTheme.bodySmall?.copyWith(
                                                        color: context.colorScheme.secondaryContainer,
                                                        decoration: TextDecoration.underline,
                                                        decorationColor: context.colorScheme.secondaryContainer,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Gap(30),
                                          ],
                                        ),
                                      if (AppConstant.userType == UserType.member)
                                        Padding(
                                          padding: const AppEdgeInsets.oB16(),
                                          child: Center(
                                            child: QrImageView(
                                              data: drink.qrCode ?? '',
                                              size: 150,
                                              gapless: false,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 245,
                                  left: -20,
                                  child: CircleAvatar(
                                    backgroundColor: context.colorScheme.onPrimary,
                                  ),
                                ),
                                Positioned(
                                  top: 245,
                                  right: -20,
                                  child: CircleAvatar(
                                    backgroundColor: context.colorScheme.onPrimary,
                                  ),
                                )
                              ],
                            ),
                            const Gap(16),
                            MarkerPriceBreakdownSection(
                              child: AppConstant.userType == UserType.member
                                  ? PlatformFeeBreakdownView(
                                      basePrice: drink.resolvedBasePrice,
                                      tip: drink.resolvedTip,
                                      breakdown: drink.platformFeeBreakdown ?? [],
                                      platformFeesTotal: drink.platformFeesTotal ?? 0,
                                      amountPaid: drink.amountPaid,
                                    )
                                  : BarMarkerPriceBreakdownView(
                                      basePrice: drink.resolvedBasePrice,
                                      tip: drink.resolvedTip,
                                    ),
                            ),
                            const Gap(8),
                          ],
                        ),
                      ),
                      if ((!controller.isRedeemed.value) && AppConstant.userType == UserType.member)
                        Padding(
                          padding: const AppEdgeInsets.hv1610(),
                          child: AppButton(
                              label: AppStrings.T.sendMarker,
                              onPressed: () async {
                                await SendToPage.route(model: controller.drinkData.value)!.then(
                                  (value) {},
                                );
                              }),
                        ),
                      if ((AppConstant.userType != UserType.member && controller.isOwnerUpcoming.value) ||
                          (AppConstant.userType == UserType.member && controller.isRedeemed.value))
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const AppEdgeInsets.hv1610(),
                            child: AppButton(
                              label: AppConstant.userType == UserType.member ? AppStrings.T.reviewLabel : AppStrings.T.done,
                              onPressed: () {
                                if (AppConstant.userType == UserType.member) {
                                  MarkerRedeemedPage.route(drink: drink)?.then(
                                    (value) {
                                      if (value != null && value is bool) {
                                        if (value) {
                                          Get.back(result: value);
                                        }
                                      }
                                    },
                                  );
                                } else {
                                  controller.getRedeemedData();
                                }
                              },
                            ),
                          ),
                        ),
                      if (controller.isOwnerUpcoming.value) const CustomSizedBox(),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.dataGet();
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
