import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/controllers/owner_main/owner_home/owner_home_controller.dart';
import 'package:marker/app/ui/pages/owner_main/owner_home/owner_notification_page.dart';
import 'package:marker/app/ui/widgets/custom_drop_down_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OwnerHomePage extends GetItHook<OHomeController> {
  const OwnerHomePage({super.key});

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
                  )),
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
                        AppText(
                          '${controller.userName} 👋🏻',
                          style: context.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        GestureDetector(
                          onTap: OwnerNotificationPage.route,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: context.colorScheme.onSecondary.withValues(alpha: 0.2),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: context.colorScheme.primary,
                              child: CircleAvatar(
                                radius: 27,
                                backgroundColor: context.colorScheme.onSecondary.withValues(alpha: 0.05),
                                child: ImageView(
                                  Assets.svg.notification,
                                  color: context.colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => getIt<BaseHomeController>().notificationCount.value > 0
                              ? CircleAvatar(
                                  radius: 10,
                                  backgroundColor: context.theme.colorScheme.onPrimary,
                                  child: Center(
                                      child: AppText(
                                    getIt<BaseHomeController>().notificationCount.value > 9
                                        ? '9+'
                                        : getIt<BaseHomeController>().notificationCount.value.toString(),
                                    style: context.textTheme.bodySmall?.copyWith(fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                )
                              : SizedBox.shrink(
                                  child: Visibility(visible: false, child: Text('${getIt<BaseHomeController>().notificationCount.value}')),
                                ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Gap(15),
                Padding(
                  padding: const AppEdgeInsets.h16(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => controller.selectedSales.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: context.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const Gap(5),
                                          Expanded(
                                            child: AppText(
                                              AppStrings.T.sales,
                                              style: context.textTheme.bodyMedium,
                                            ),
                                          ),
                                          AppDropdown(
                                            list: controller.salesList,
                                            selectedValue: controller.selectedSales,
                                            hintText: controller.selectedSales.value,
                                            onChanged: (newSales) {
                                              controller.selectedSales.value = newSales!;
                                              controller.updateSalesData(newSales); // ← this updates chartData
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 1.5,
                                      child: SfCartesianChart(
                                        zoomPanBehavior: controller.zoomPanBehavior,
                                        trackballBehavior: TrackballBehavior(
                                          enable: true,
                                          activationMode: ActivationMode.singleTap,
                                          lineDashArray: const [5, 5],
                                          lineColor: context.colorScheme.primary,
                                          markerSettings: controller.trackballMarkerSettings,
                                          tooltipSettings: controller.interactiveTooltip,
                                        ),
                                        onTrackballPositionChanging: (TrackballArgs args) => controller.toolTrip(args),
                                        primaryXAxis: controller.categoryAxis,
                                        primaryYAxis: NumericAxis(
                                          minimum: 0,
                                          majorTickLines: const MajorTickLines(width: 0),
                                          axisLine: const AxisLine(width: 0),
                                          maximum: controller.maxY.toDouble(),
                                          interval: controller.niceInterval,
                                          labelStyle: Get.context!.textTheme.bodySmall!.copyWith(
                                            color: Get.context!.colorScheme.onSecondary,
                                          ),
                                        ),
                                        series: [
                                          SplineSeries<ChartData, String>(
                                            dataSource: controller.chartData,
                                            xValueMapper: (ChartData data, _) => data.label ?? '',
                                            yValueMapper: (ChartData data, _) => double.tryParse(data.value ?? '') ?? 0,
                                            width: 3,
                                            color: context.colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                      const Gap(15),
                      Obx(
                        () => controller.selectedTips.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: context.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const Gap(5),
                                          Expanded(
                                            child: AppText(
                                              '${AppStrings.T.tips} ${controller.tipsTotalLabel.value}',
                                              style: context.textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          AppDropdown(
                                            list: controller.tipsFilterList,
                                            selectedValue: controller.selectedTips,
                                            hintText: controller.selectedTips.value,
                                            onChanged: (newFilter) {
                                              controller.selectedTips.value = newFilter!;
                                              controller.updateTipsData(newFilter);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 1.5,
                                      child: SfCartesianChart(
                                        zoomPanBehavior: controller.zoomPanBehavior,
                                        trackballBehavior: TrackballBehavior(
                                          enable: true,
                                          activationMode: ActivationMode.singleTap,
                                          lineDashArray: const [5, 5],
                                          lineColor: context.colorScheme.primary,
                                          markerSettings: controller.trackballMarkerSettings,
                                          tooltipSettings: controller.interactiveTooltip,
                                        ),
                                        onTrackballPositionChanging: (TrackballArgs args) =>
                                            controller.toolTrip(args, isTips: true),
                                        primaryXAxis: controller.categoryAxis,
                                        primaryYAxis: NumericAxis(
                                          minimum: 0,
                                          majorTickLines: const MajorTickLines(width: 0),
                                          axisLine: const AxisLine(width: 0),
                                          maximum: controller.maxYTips.toDouble(),
                                          interval: controller.niceIntervalTips,
                                          labelStyle: Get.context!.textTheme.bodySmall!.copyWith(
                                            color: Get.context!.colorScheme.onSecondary,
                                          ),
                                        ),
                                        series: [
                                          SplineSeries<ChartData, String>(
                                            dataSource: controller.chartTipsData,
                                            xValueMapper: (ChartData data, _) => data.label ?? '',
                                            yValueMapper: (ChartData data, _) =>
                                                double.tryParse(data.value ?? '') ?? 0,
                                            width: 3,
                                            color: context.colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (AppConstant.userType == UserType.owner) ...[
                                      const Divider(height: 24),
                                      Padding(
                                        padding: const AppEdgeInsets.h16(),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: AppText(
                                            AppStrings.T.tipsByManager,
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (controller.tipsByStaffList.isEmpty)
                                        Padding(
                                          padding: const AppEdgeInsets.hv1610(),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: AppText(
                                              'No tips recorded for this period.',
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.secondaryFixedDim,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        ...controller.tipsByStaffList.map(
                                          (staff) => Padding(
                                            padding: const AppEdgeInsets.hv1610(),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: AppText(
                                                    staff.name ?? 'Unknown',
                                                    style: context.textTheme.bodySmall,
                                                  ),
                                                ),
                                                AppText(
                                                  AppValidations.getFormattedPrice(staff.value ?? 0),
                                                  style: context.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const Gap(8),
                                    ],
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                      const Gap(15),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const AppEdgeInsets.all8(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Gap(5),
                                    Expanded(
                                      child: AppText(
                                        AppStrings.T.redemptionRates,
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ),
                                    AppDropdown(
                                      list: controller.salesList,
                                      selectedValue: controller.selectedRedemption,
                                      hintText: controller.selectedRedemption.value,
                                      onChanged: (newSales) {
                                        controller.selectedRedemption.value = newSales!;
                                        controller.updateRedemption(newSales);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.chartRedemptionData.isNotEmpty)
                                AspectRatio(
                                  aspectRatio: 1.90,
                                  child: SfCircularChart(
                                    annotations: [
                                      CircularChartAnnotation(
                                        widget: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText(
                                              AppStrings.T.total,
                                              style: context.textTheme.displaySmall?.copyWith(
                                                color: context.colorScheme.secondaryFixedDim,
                                              ),
                                            ),
                                            const Gap(5),
                                            AppText(controller.chartRedemptionData[0].label ?? '0', style: context.textTheme.bodyLarge),
                                          ],
                                        ),
                                      ),
                                    ],
                                    series: <DoughnutSeries<ChartData, String>>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: [
                                          ChartData(
                                            label: 'redeemed',
                                            value: controller.chartRedemptionData[0].value,
                                          ),
                                          ChartData(
                                            label: 'total',
                                            value: controller.chartRedemptionData[0].label,
                                          ),
                                        ],
                                        pointColorMapper: (ChartData data, _) {
                                          if (data.label == 'total') {
                                            return AppColors.grey;
                                          } else if (data.label == 'redeemed') {
                                            return context.colorScheme.primary;
                                          }
                                          return Colors.grey; // fallback
                                        },
                                        xValueMapper: (ChartData data, _) => data.label ?? '',
                                        yValueMapper: (ChartData data, _) => double.tryParse(data.value ?? '') ?? 0,
                                        radius: '90%',
                                        innerRadius: '65%',
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          labelAlignment: ChartDataLabelAlignment.top,
                                          builder: (dynamic data, _, dynamic point, __, ___) {
                                            final chartData = data as ChartData;
                                            if (chartData.label == 'redeemed') {
                                              return Wrap(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 40),
                                                    padding: const AppEdgeInsets.hv105(),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: context.colorScheme.onPrimary,
                                                    ),
                                                    child: AppText(
                                                      chartData.value ?? '0',
                                                      style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const SizedBox.shrink(); // Don't render anything
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (controller.chartRedemptionData.isNotEmpty)
                                Padding(
                                  padding: const AppEdgeInsets.all10(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: AppColors.grey,
                                          ),
                                          const Gap(5),
                                          AppText(
                                            AppStrings.T.totalMarkers,
                                            style: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.secondaryFixedDim,
                                              fontSize: 12,
                                            ),
                                          ),
                                          AppText(
                                            controller.chartRedemptionData[0].label ?? '0',
                                            style: context.textTheme.bodyLarge?.copyWith(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const Gap(3),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: context.colorScheme.primary,
                                          ),
                                          const Gap(5),
                                          AppText(
                                            AppStrings.T.redeemedMarkers,
                                            style: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.secondaryFixedDim,
                                              fontSize: 12,
                                            ),
                                          ),
                                          AppText(
                                            ' ${controller.chartRedemptionData[0].value ?? '0'}',
                                            style: context.textTheme.bodyLarge?.copyWith(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(15),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Gap(5),
                                    Expanded(
                                      child: AppText(
                                        AppStrings.T.userActivity,
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ),
                                    AppDropdown(
                                      list: controller.salesList,
                                      selectedValue: controller.selectedUserActivity,
                                      hintText: controller.selectedUserActivity.value,
                                      onChanged: (newSales) {
                                        controller.selectedUserActivity.value = newSales!;
                                        controller.updateSalesData(newSales, isUser: true); // ← this updates chartUserData
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 1.5,
                                child: SfCartesianChart(
                                  zoomPanBehavior: controller.zoomPanBehavior,
                                  trackballBehavior: TrackballBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.singleTap,
                                    lineDashArray: const [5, 5],
                                    lineColor: context.colorScheme.primary,
                                    markerSettings: controller.trackballMarkerSettings,
                                    tooltipSettings: controller.interactiveTooltip,
                                  ),
                                  onTrackballPositionChanging: (TrackballArgs args) => controller.toolTrip(args, isUser: true),
                                  primaryXAxis: controller.categoryAxis,
                                  primaryYAxis: NumericAxis(
                                    minimum: 0,
                                    majorTickLines: const MajorTickLines(width: 0),
                                    axisLine: const AxisLine(width: 0),
                                    maximum: controller.maxYUser.toDouble(),
                                    interval: controller.niceIntervalUser,
                                    labelStyle: Get.context!.textTheme.bodySmall!.copyWith(
                                      color: Get.context!.colorScheme.onSecondary,
                                    ),
                                  ),
                                  series: [
                                    SplineSeries<ChartData, String>(
                                      dataSource: controller.chartUserData,
                                      xValueMapper: (ChartData data, _) => data.label ?? '',
                                      yValueMapper: (ChartData data, _) => double.tryParse(data.value ?? '') ?? 0,
                                      width: 3,
                                      color: context.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.salesList.value = [];
    controller.tipsFilterList.value = [];
    controller.fetchBarOwnerHomeData();
    controller.getUserData();
    controller.addChatData(controller.salesList);
    controller.addTipsFilterData();
  }

  @override
  void onDispose() {
    controller.userName.value = '';
  }
}
