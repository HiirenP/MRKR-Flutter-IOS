import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_range_picker/time_range_picker.dart';

class TimePickerUtils {
  Future<dynamic> timerPicker({TimeOfDay? start, TimeOfDay? end}) async {
    final context = Get.context!;
    final result = await showTimeRangePicker(
      context: context,
      use24HourFormat: false,
      useRootNavigator: false,
      labels: ['12 am', '3 am', '6 am', '9 am', '12 pm', '3 pm', '6 pm', '9 pm'].asMap().entries.map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
      labelStyle: context.theme.textTheme.bodyMedium,
      activeTimeTextStyle: context.theme.textTheme.bodyMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.w600),
      timeTextStyle: context.theme.textTheme.bodyMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.w600),
      rotateLabels: false,
      padding: 50,
      start: start,
      end: end,
    );
    return result;
  }
}
