import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_home_model/bar_home_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/availability_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/model/common_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

@i.lazySingleton
@i.injectable
class OHomeController extends GetxController {
  OHomeController() {
    onInit();
  }

  RxString userName = ''.obs;

  /// Chart data
  RxList<ChartData> chartData = <ChartData>[].obs;
  RxList<ChartData> chartTipsData = <ChartData>[].obs;
  RxList<ChartData> chartRedemptionData = <ChartData>[].obs;
  RxList<ChartData> chartUserData = <ChartData>[].obs;

  /// Dropdown filters
  RxList<String> salesList = <String>[].obs;
  RxList<String> tipsFilterList = <String>[].obs;
  RxList<String> userList = <String>[].obs;

  /// Selected filter
  RxString selectedSales = ''.obs;
  RxString selectedTips = AppStrings.T.thisWeek.obs;
  RxString selectedUserActivity = ''.obs;
  RxString selectedRedemption = AppStrings.T.thisWeek.obs;
  RxString tipsTotalLabel = '\$0'.obs;
  RxList<TipsByStaffItem> tipsByStaffList = <TipsByStaffItem>[].obs;

  /// Sales data response model
  Rx<BarHomeData> salesData = BarHomeData().obs;
  int maxY = 5;
  int maxYTips = 5;
  int maxYUser = 5;

  double niceInterval = 1;
  double niceIntervalTips = 1;
  double niceIntervalUser = 1;

  TrackballMarkerSettings trackballMarkerSettings = const TrackballMarkerSettings();
  InteractiveTooltip interactiveTooltip = const InteractiveTooltip();
  CategoryAxis categoryAxis = const CategoryAxis();

  final ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
    enablePanning: true,
    enablePinching: true,
    enableDoubleTapZooming: true,
    enableMouseWheelZooming: true,
  );

  /// Map for label conversion
  final dayMap = {
    'Sun': 'Sunday',
    'Mon': 'Monday',
    'Tue': 'Tuesday',
    'Wed': 'Wednesday',
    'Thu': 'Thursday',
    'Fri': 'Friday',
    'Sat': 'Saturday',
  };

  Future<void> getUserData() async {
    final userData = getIt<SharedPreferences>().getUserData;
    if (userData != null) {
      userName.value = userData.name ?? '';
    }
  }

  final monthMap = {
    'Jan': 'January',
    'Feb': 'February',
    'Mar': 'March',
    'Apr': 'April',
    'May': 'May',
    'Jun': 'June',
    'Jul': 'July',
    'Aug': 'August',
    'Sep': 'September',
    'Oct': 'October',
    'Nov': 'November',
    'Dec': 'December',
  };

  /// Populate dropdowns
  Future<void> addChatData(RxList<String> list) async {
    list.addAll([
      AppStrings.T.thisWeek,
      AppStrings.T.thisMonth,
      AppStrings.T.thisYears,
    ]);
  }

  Future<void> addTipsFilterData() async {
    tipsFilterList.addAll([
      AppStrings.T.today,
      AppStrings.T.thisWeek,
      AppStrings.T.thisMonth,
      AppStrings.T.thisYears,
    ]);
  }

  /// Fetch API and update data
  Future<void> fetchBarOwnerHomeData() async {
    await getIt<BarOwnerService>().barHome().handler(
      ApiState.initial().obs,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          salesData.value = value.data!;
          selectedSales.value = AppStrings.T.thisWeek;
          selectedTips.value = AppStrings.T.thisWeek;
          selectedUserActivity.value = AppStrings.T.thisWeek;
          updateSalesData(selectedSales.value);
          updateTipsData(selectedTips.value);
          updateRedemption(selectedRedemption.value);
          updateSalesData(selectedUserActivity.value, isUser: true);
          final isAvailable = value.data?.barAvailability ?? false;
          if (!isAvailable) {
            openWarningPopup();
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  /// Convert raw data to ChartData
  ChartData mapSalesData(dynamic item, {bool isUser = false, bool isRedemption = false}) {
    if (isUser) {
      if (item is UserActivityThisWeek) {
        return ChartData(label: item.day, value: item.active.toString());
      } else if (item is UserActivityThisMonth) {
        return ChartData(label: item.date, value: item.active.toString());
      } else if (item is UserActivityThisYear) {
        return ChartData(label: item.month, value: item.active.toString());
      }
    } else {
      if (item is SalesThisToday) {
        return ChartData(label: item.hour, value: item.value.toString());
      } else if (item is SalesThisWeek) {
        return ChartData(label: item.day, value: item.value.toString());
      } else if (item is SalesThisMonth) {
        return ChartData(label: item.date, value: item.value.toString());
      } else if (item is SalesThisYear) {
        return ChartData(label: item.month, value: item.value.toString());
      }
    }
    if (isRedemption) {
      if (item is RedemptionRateThisWeek) {
        return ChartData(label: item.total.toString(), value: item.redeemed.toString());
      } else if (item is RedemptionRateThisMonth) {
        return ChartData(label: item.total.toString(), value: item.redeemed.toString());
      } else if (item is RedemptionRateThisYear) {
        return ChartData(label: item.total.toString(), value: item.redeemed.toString());
      }
    }
    return ChartData(label: '', value: '0');
  }

  void updateTipsData(String filter) {
    List<dynamic> rawData;

    if (filter == AppStrings.T.today) {
      rawData = salesData.value.tips?.thisToday ?? [];
    } else if (filter == AppStrings.T.thisMonth) {
      rawData = salesData.value.tips?.thisMonth ?? [];
    } else if (filter == AppStrings.T.thisYears) {
      rawData = salesData.value.tips?.thisYear ?? [];
    } else {
      rawData = salesData.value.tips?.thisWeek ?? [];
    }

    final converted = rawData.map((item) => mapSalesData(item)).toList();
    final total = converted.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.value ?? '0') ?? 0),
    );
    tipsTotalLabel.value = AppValidations.getFormattedPrice(total);
    generateChartValues(isTips: true, converted: converted);
    chartTipsData.assignAll(converted);

    List<TipsByStaffItem> staffTips;
    if (filter == AppStrings.T.today) {
      staffTips = salesData.value.tipsByStaff?.thisToday ?? [];
    } else if (filter == AppStrings.T.thisMonth) {
      staffTips = salesData.value.tipsByStaff?.thisMonth ?? [];
    } else if (filter == AppStrings.T.thisYears) {
      staffTips = salesData.value.tipsByStaff?.thisYear ?? [];
    } else {
      staffTips = salesData.value.tipsByStaff?.thisWeek ?? [];
    }
    tipsByStaffList.assignAll(staffTips);
  }

  void updateRedemption(String filter) {
    List<dynamic> rawData;

    if (filter == AppStrings.T.thisMonth) {
      rawData = salesData.value.redemptionRate?.thisMonth ?? [];
    } else if (filter == AppStrings.T.thisYears) {
      rawData = salesData.value.redemptionRate?.thisYear ?? [];
    } else {
      rawData = salesData.value.redemptionRate?.thisWeek ?? [];
    }
    final converted = rawData.map((item) => mapSalesData(item, isRedemption: true)).toList();
    chartRedemptionData.assignAll(converted);
  }

  Future<void> updateSalesData(String filter, {bool isUser = false}) async {
    List<dynamic> rawData;
    if (filter == AppStrings.T.thisMonth) {
      rawData = isUser ? salesData.value.userActivity?.thisMonth ?? [] : salesData.value.sales?.thisMonth ?? [];
    } else if (filter == AppStrings.T.thisYears) {
      rawData = isUser ? salesData.value.userActivity?.thisYear ?? [] : salesData.value.sales?.thisYear ?? [];
    } else {
      rawData = isUser ? salesData.value.userActivity?.thisWeek ?? [] : salesData.value.sales?.thisWeek ?? [];
    }

    final converted = rawData.map((item) => mapSalesData(item, isUser: isUser)).toList();
    debugPrint('isUser-->$isUser');
    if (isUser) {
      await generateChartValues(isUser: isUser, converted: converted);
      chartUserData.assignAll(converted);
    } else {
      await generateChartValues(isUser: isUser, converted: converted);
      chartData.assignAll(converted);
    }
  }

  Future<void> generateChartValues({
    bool isUser = false,
    bool isTips = false,
    required List<ChartData> converted,
  }) async {
    double rawMaxY = 0;

    final values = converted.map((e) => double.tryParse(e.value ?? '0') ?? 0).toList();
    final parsedMax = values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
    rawMaxY = parsedMax.toDouble();
    debugPrint('--rawMaxY-->$rawMaxY');
    double interval;
    if (rawMaxY <= 5) {
      interval = 1;
    } else if (rawMaxY <= 10) {
      interval = 2;
    } else if (rawMaxY <= 50) {
      interval = 5;
    } else if (rawMaxY <= 100) {
      interval = 20;
    } else if (rawMaxY <= 200) {
      interval = 30;
    } else {
      interval = (rawMaxY / 5).ceilToDouble();
    }

    if (isUser) {
      niceIntervalUser = interval;
      maxYUser = (((rawMaxY + interval) / interval).ceil() * interval).toInt();
    } else if (isTips) {
      niceIntervalTips = interval;
      maxYTips = (((rawMaxY + interval) / interval).ceil() * interval).toInt();
    } else {
      niceInterval = interval;
      maxY = (((rawMaxY + interval) / interval).ceil() * interval).toInt();
    }

    debugPrint('isUser--------------------------->$isUser');
    debugPrint('maxYUser--------------------------->$maxYUser');
    debugPrint('maxY--------------------------->$maxY');

    trackballMarkerSettings = TrackballMarkerSettings(
      markerVisibility: TrackballVisibilityMode.visible,
      height: 13,
      width: 13,
      borderWidth: 5,
      color: Get.context!.colorScheme.primary,
      borderColor: Get.context!.colorScheme.onPrimary,
    );

    interactiveTooltip = InteractiveTooltip(
      color: Get.context!.colorScheme.onSecondary,
      format: 'point.x : point.y',
      borderWidth: 1,
      arrowLength: 0,
      borderColor: Get.context!.colorScheme.onPrimary,
      canShowMarker: false,
      textStyle: Get.context!.textTheme.bodySmall!.copyWith(
        color: Get.context!.colorScheme.onPrimary,
      ),
    );

    categoryAxis = CategoryAxis(
      axisLine: const AxisLine(width: 0),
      majorTickLines: const MajorTickLines(width: 0),
      labelStyle: Get.context!.textTheme.bodySmall!.copyWith(
        color: Get.context!.colorScheme.onSecondary,
      ),
    );
  }

  /// Custom tooltip formatting
  void toolTrip(TrackballArgs args, {bool isUser = false, bool isTips = false}) {
    final shortX = args.chartPointInfo.chartPoint?.x.toString() ?? '';
    final yValue = args.chartPointInfo.chartPoint?.y ?? 0;
    final formattedY = isTips ? AppValidations.getFormattedPrice(yValue) : yValue.toString();
    final filter = isUser
        ? selectedUserActivity.value
        : isTips
            ? selectedTips.value
            : selectedSales.value;
    final fullDay = filter == AppStrings.T.today
        ? shortX
        : filter == AppStrings.T.thisYears
            ? monthMap[shortX]
            : dayMap[shortX] ?? shortX;

    args.chartPointInfo.label = isUser
        ? 'in $fullDay\n$formattedY'
        : filter == AppStrings.T.today
            ? 'At $fullDay\n$formattedY'
            : 'On $fullDay\n$formattedY';
  }

  Future<dynamic> openWarningPopup() {
    return Get.bottomSheet(
      isScrollControlled: true,
      AppBottomSheet(
        title: AppStrings.T.attention,
        subTitle: AppStrings.T.warningMessage,
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: () {
          Get.back();
          AvailabilityPage.route();
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
