import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';

class MonthYearPicker extends StatefulWidget {
  const MonthYearPicker(
      {required this.initialYear,
      required this.startYear,
      required this.endYear,
      this.currentYear,
      required this.selectedValue,
      required this.month,
      super.key});

  final int initialYear;
  final int startYear;
  final int endYear;
  final int? currentYear;
  final int month;
  final Function(String) selectedValue;

  @override
  State<MonthYearPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthYearPicker> {
  final List<String> _monthList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  final List<String> _yearList = [];
  late int selectedMonthIndex;
  late int selectedYearIndex;
  String selectedMonth = '';
  String selectedYear = '';

  @override
  void initState() {
    for (var i = widget.startYear; i <= widget.endYear; i++) {
      _yearList.add(i.toString());
    }
    selectedMonthIndex = widget.month - 1;
    selectedYearIndex = _yearList.indexOf(
        widget.currentYear?.toString() ?? widget.initialYear.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedMonth = _monthList[selectedMonthIndex];
        selectedYear = _yearList[selectedYearIndex];
        widget.selectedValue(
            '$selectedMonth/${selectedYear.substring(selectedYear.length - 2)}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              underline: Container(),
              isExpanded: true,
              items: _monthList.map((e) {
                return DropdownMenuItem<String>(
                    value: e,
                    child: AppText(
                      e,
                      style: context.textTheme.bodyMedium,
                    ));
              }).toList(),
              value: selectedMonth.isEmpty ? null : selectedMonth,
              onChanged: (val) {
                setState(() {
                  selectedMonthIndex = _monthList.indexOf(val!);
                  selectedMonth = val;
                  widget.selectedValue(
                      '$selectedMonth/${selectedYear.substring(selectedYear.length - 2)}');
                });
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: DropdownButton<String>(
              underline: Container(),
              isExpanded: true,
              items: _yearList.map((e) {
                return DropdownMenuItem<String>(
                    value: e,
                    child: AppText(
                      e,
                      style: context.textTheme.bodyMedium,
                    ));
              }).toList(),
              value: selectedYear.isEmpty ? null : selectedYear,
              onChanged: (val) {
                setState(() {
                  selectedYear = val ?? '';
                  widget.selectedValue(
                      '$selectedMonth/${selectedYear.substring(selectedYear.length - 2)}');
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
