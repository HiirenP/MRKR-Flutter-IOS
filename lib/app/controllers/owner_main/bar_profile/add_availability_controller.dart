import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:intl/intl.dart';
import 'package:marker/app/data/models/bar_availability_model/bar_availability_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

@i.lazySingleton
@i.injectable
class AddAvailabilityController extends GetxController {
  AddAvailabilityController() {
    onInit();
  }

  RxList<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].obs;
  List<String> selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  Rx<DateTime> selectedDate = DateTime.now().obs;

  String range = '';
  RxBool isAdded = false.obs;
  RxBool isLoaded = false.obs;
  List<String> dateList = <String>[];
  RxList<String> selectedDates = <String>[].obs;

  RxList<String> daysOpen = <String>[].obs;
  RxList<String> specificDaysOff = <String>[].obs;
  RxList<Vacation> vacation = <Vacation>[].obs;
  List<DateTime> selectedIntiDates = <DateTime>[];
  List<PickerDateRange> selectedIntiRangeDates = <PickerDateRange>[];
  final barAvailabilityState = ApiState.initial().obs;

  void toggleSelection(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
    update();
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is List<DateTime>) {
      selectedDates.clear();
      final selected = args.value as List<DateTime>;
      selectedIntiDates = selected;
      for (final date in selected) {
        selectedDates.add(DateFormat(DateUtil.instance.yyyyMMdd).format(date));
      }
    } else if (args.value is List<PickerDateRange>) {
      final ranges = args.value as List<PickerDateRange>;
      dateList.clear();
      final selectedVacationDates = [];
      selectedIntiRangeDates = ranges;
      for (final range in ranges) {
        final start = range.startDate!;
        final end = range.endDate ?? start;
        final formattedStart = DateFormat(DateUtil.instance.yyyyMMdd).format(start);
        final formattedEnd = DateFormat(DateUtil.instance.yyyyMMdd).format(end);
        selectedVacationDates.add('$formattedStart - $formattedEnd');
        for (var date = start;
            date.isBefore(end) || date.isAtSameMomentAs(end);
            date = date.add(const Duration(days: 1))) {
          dateList.add(DateFormat(DateUtil.instance.yyyyMMdd).format(date));
        }
      }

      range = selectedVacationDates.join(', ');
    }

    update(); // If using GetX
  }

  Future<void> addBarAvailability() async {
    debugPrint('specificDaysOff-isSuccess----------------->$range');

    if (specificDaysOff.isEmpty && selectedDays.isEmpty && range.isEmpty) {
      return;
    }
    debugPrint('range.isEmpty----------------->');
    List<Map<String, String>>? vacation;
    if (range.isNotEmpty) {
      vacation = range.split(', ').map((range) {
        final parts = range.split(' - ');
        return {
          'fromDate': parts[0],
          'toDate': parts[1],
        };
      }).toList();
    }

    final requestData = <String, dynamic>{
      'barId': getIt<SharedPreferences>().getBarId,
    };
    if (selectedDays.isNotEmpty) {
      requestData.putIfAbsent('daysOpen', () => selectedDays);
    }
    if (selectedDates.isNotEmpty) {
      requestData.putIfAbsent('specificDaysOff', () => selectedDates);
    }
    if (vacation != null) {
      requestData.putIfAbsent('vacation', () => vacation);
    }
    await getIt<BarOwnerService>().addBarAvailability(requestData).handler(
      barAvailabilityState,
      onSuccess: (value) {
        isAdded.value = true;
        isLoaded.value = false;
        getBarAvailability();
        Get.back();
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> getBarAvailability() async {
    await getIt<BarOwnerService>().getBarAvailability(getIt<SharedPreferences>().getBarId ?? '').handler(
      barAvailabilityState,
      onSuccess: (value) {
        if (value.isSuccess && value.data != null) {
          isAdded.value = true;
          if (value.data?.daysOpen == null && value.data?.specificDaysOff == null && value.data?.vacation == null) {
            isLoaded.value = true;
          }
          if (value.data!.daysOpen != null) {
            debugPrint('daysOpen------------------->$daysOpen');
            daysOpen.value = value.data!.daysOpen!;
          }
          if (value.data!.specificDaysOff != null) {
            debugPrint('specificDaysOff------------------->$specificDaysOff');
            specificDaysOff.value = value.data!.specificDaysOff!;
          }
          if (value.data!.vacation != null) {
            debugPrint('vacation------------------->$vacation');
            vacation.value = value.data!.vacation!;
          }
        } else {
          isAdded.value = false;
          isLoaded.value = true;
        }
      },
      onFailed: (value) {
        if (value.statusCode == 404) {
          isLoaded.value = true;
        } else {
          showError(value.error.description);
        }
      },
    );
  }

  Future<void> updateAvailability() async {
    if (selectedDays.isEmpty) {
      return;
    }
    List<Map<String, String>>? vacation1;
    if (range.isNotEmpty) {
      vacation1 = range.split(', ').map((range) {
        final parts = range.split(' - ');
        return {
          'fromDate': parts[0],
          'toDate': parts[1],
        };
      }).toList();
    }

    final requestData = <String, dynamic>{
      'barId': getIt<SharedPreferences>().getBarId,
      'daysOpen': selectedDays,
      'specificDaysOff': selectedDates,
      'vacation': range.isNotEmpty ? vacation1 : vacation
    };
    await getIt<BarOwnerService>()
        .updateBarAvailability(getIt<SharedPreferences>().getBarId ?? '', requestData)
        .handler(
      barAvailabilityState,
      onSuccess: (value) {
        if (value.isSuccess || value.data != null) {
          isAdded.value = true;
          daysOpen.value = value.data!.daysOpen!;
          specificDaysOff.value = value.data!.specificDaysOff!;
          vacation.value = value.data!.vacation!;
          Get.back();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void onInitilized() {
    selectedDays = daysOpen;
    selectedDates = specificDaysOff;
    if (specificDaysOff.isNotEmpty) {
      selectedIntiDates = specificDaysOff.map(DateTime.parse).toList();
    }
    if (vacation.isNotEmpty) {
      selectedIntiRangeDates = [];
      dateList = [];
      selectedIntiRangeDates = vacation
          .map(
            (vac) => PickerDateRange(
              DateTime.parse(vac.fromDate ?? ''),
              DateTime.parse(vac.toDate ?? ''),
            ),
          )
          .toList();
      for (final vac in vacation) {
        final startDate = DateTime.parse(vac.fromDate ?? '');
        final endDate = DateTime.parse(vac.toDate ?? '');

        for (var date = startDate;
            date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
            date = date.add(const Duration(days: 1))) {
          dateList.add(DateFormat(DateUtil.instance.yyyyMMdd).format(date));
        }
      }
    }
  }
}
