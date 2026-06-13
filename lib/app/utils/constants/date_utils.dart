import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtil {
  factory DateUtil() {
    return _singleton;
  }

  DateUtil._internal();

  static final DateUtil _singleton = DateUtil._internal();

  static DateUtil get instance => _singleton;

  String yyyyMMdd = 'yyyy-MM-dd';
  String yyyyMMddHHmmSS = 'yyyy-MM-dd HH:mm:ss';
  String yyyyMMddTHHmmSSZ = 'yyyy-MM-ddTHH:mm:ss.sssZ';
  String yyyyMMddTHHmmSS = 'yyyy-MM-ddTHH:mm:ss.sss';
  String ddMM = 'dd MMM, yyyy';
  String hhMMA = 'h:mm a';
  String hhMM = 'h:mm';
  String MMddyyyy = 'MM/dd/yyyy';

  // Date formatting method
  String changeDateFormat(String date, {String input = 'yyyy-MM-dd', String format = 'dd MMM, yyyy'}) {
    if (date.isEmpty) {
      return '';
    }
    final dateTime = DateFormat(input).parse(date);
    final dateLocal = dateTime.toLocal();
    return DateFormat(format).format(dateLocal);
  }

  // Date formatting method
  DateTime? changeStringToDate(String date, {String input = 'yyyy-MM-dd'}) {
    if (date.isEmpty) {
      return null;
    }
    final dateTime = DateFormat(input).parse(date);
    return dateTime;
  }

  // Date formatting method
  String dateFormat(String date, {String format = 'dd MMM, yyyy'}) {
    if (date.isEmpty) {
      return '';
    }
    final dateTime = DateFormat(format).parse(date, true);
    final dateLocal = dateTime.toLocal();
    return DateFormat(format).format(dateLocal);
  }

  // Date formatting method
  String dateDFormat(String date, {String format = 'dd MMM, yyyy'}) {
    if (date.isEmpty) {
      return '';
    }
    final dateTime = DateFormat('yyyy-MM-ddTHH:mm:ss.Z').parse(date, true);
    final dateLocal = dateTime.toLocal();
    return DateFormat(format).format(dateLocal);
  }

// 2025-05-19T06:45:46.142Z
  // Current date formatting method
  String currentDateFormat({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final now = DateTime.now().toUtc();
    return DateFormat(format).format(now);
  } // Current date formatting method

  String currentDDateFormat({String format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"}) {
    final now = DateTime.now().toUtc();
    return DateFormat(format).format(now);
  }

  // Current date formatting method
  String chatDaysLabelManage({required String date}) {
    if (date.trim().isEmpty) {
      return '';
    }
    final tempDate = DateTime.parse(date);
    if (tempDate.isToday) {
      return dateDFormat(date, format: hhMMA);
    } else if (tempDate.isYesterday) {
      return 'Yesterday';
    } else {
      return dateDFormat(date, format: MMddyyyy);
    }
  }

  Future<void> selectDate(BuildContext context, DateTime initialDate, {Function(DateTime)? selectedDate}) async {
    final picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2010),
    );
    if (picked != null && picked != initialDate) {
      if (selectedDate != null) {
        selectedDate(picked);
      }
    }
  }
}

String localToUtcAvailableTime(String time) {
  final timeFrom = time.split(' ');
  if (timeFrom.first.isNotEmpty) {
    const format = 'H:mm';
    final onlyTime = timeFrom.first.split(':');
    var hour = onlyTime.first;
    final minute = onlyTime.last;

    // Validate hour and minute are valid numbers
    if (hour == 'NaN' || minute == 'NaN') {
      return '';
    }

    if (time.contains('pm') || time.contains('PM')) {
      hour = convert24Hour(hour);
    }
    final now = DateTime.now();
    final localTime = DateTime(now.year, now.month, now.day, int.parse(hour), int.parse(minute));
    final utcTime = localTime.toUtc();
    final dateTime = DateFormat(format).format(utcTime);
    return dateTime;
  }
  return time;
}

String convert24Hour(String hour) {
  if (hour == '1' || hour == '01') {
    return '13';
  } else if (hour == '2' || hour == '02') {
    return '14';
  } else if (hour == '3' || hour == '03') {
    return '15';
  } else if (hour == '4' || hour == '04') {
    return '16';
  } else if (hour == '5' || hour == '05') {
    return '17';
  } else if (hour == '6' || hour == '06') {
    return '18';
  } else if (hour == '7' || hour == '07') {
    return '19';
  } else if (hour == '8' || hour == '08') {
    return '20';
  } else if (hour == '9' || hour == '09') {
    return '21';
  } else if (hour == '10') {
    return '22';
  } else if (hour == '11') {
    return '23';
  } else if (hour == '12') {
    return '00';
  }
  return hour;
}

String utcToLocalAvailableTime(String time, {String format = 'h:mm a'}) {
  if (time.isEmpty) {
    return time;
  }
  final tempTime = time.split(' ').first;
  if (tempTime.isNotEmpty) {
    final onlyTime = tempTime.split(':');
    final hour = onlyTime.first;
    final minute = onlyTime.last;

    // Validate hour and minute are valid numbers
    if (hour == 'NaN' || minute == 'NaN') {
      return '';
    }

    final now = DateTime.now().toUtc();
    final utcTime = DateTime(now.year, now.month, now.day, int.parse(hour), int.parse(minute));
    try {
      final utc = DateFormat('yyyy-MM-dd hh:mm:ss a').format(utcTime);
      final dateTime1 = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(utc, true);
      final local = dateTime1.toLocal();
      final dateTime = DateFormat(format).format(local);
      return dateTime;
    } catch (e) {
      debugPrint('-Error date--->$e');
    }
  }
  return time;
}

String utcToLocalTime(String time, {String format = 'h:mm a', int? index}) {
  if (time.isEmpty) {
    return time;
  }
  final tempTime = time.split(' ').first;
  final lastAmPM = time.split(' ').last.trim();
  if (lastAmPM.isNotEmpty) {
    var hour = '';
    if (lastAmPM.contains('PM') || lastAmPM.contains('pm')) {
      hour = convert24Hour(time.split(':').first);
    } else {
      hour = time.split(':').first;
    }
    final last = tempTime
        .split(':')[1]
        .split(' ')
        .first
        .replaceAll(' ', '')
        .replaceAll('am', '')
        .replaceAll('pm', '')
        .replaceAll('AM', '')
        .replaceAll('PM', '');

    // Validate hour and minute are valid numbers
    if (hour == 'NaN' || last == 'NaN') {
      return '';
    }

    final selectedTime = TimeOfDay(hour: int.parse(hour), minute: int.parse(last));
    final now = DateTime.now().toUtc();

    final fullDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    try {
      final utc = DateFormat('yyyy-MM-dd hh:mm:ss a').format(fullDateTime);
      final dateTime1 = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(utc, true);
      final local = dateTime1.toLocal();
      final dateTime = DateFormat(format).format(local);
      return dateTime;
    } catch (e) {
      debugPrint('-Error date-new-->$e');
    }
  }

  if (tempTime.isNotEmpty && lastAmPM.isEmpty) {
    final onlyTime = tempTime.split(':');
    final hour = onlyTime.first;
    final minute = onlyTime.last;

    // Validate hour and minute are valid numbers
    if (hour == 'NaN' || minute == 'NaN') {
      return '';
    }

    final now = DateTime.now().toUtc();

    final utcTime = DateTime(now.year, now.month, now.day, int.parse(hour), int.parse(minute));
    try {
      final utc = DateFormat('yyyy-MM-dd hh:mm:ss a').format(utcTime);
      final dateTime1 = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(utc, true);
      final local = dateTime1.toLocal();
      final dateTime = DateFormat(format).format(local);
      return dateTime;
    } catch (e) {
      debugPrint('-Error date--->$e');
    }
  }
  return time;
}

extension DateHelpers on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }
}
