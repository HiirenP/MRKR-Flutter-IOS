import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/add_availability_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddAvailabilityPage extends GetItHook<AddAvailabilityController> {
  const AddAvailabilityPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.addAvailabilityPage);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAvailabilityController>(
        init: getIt.get<AddAvailabilityController>(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              top: false,
              bottom: false,
              child: Padding(
                padding: const AppEdgeInsets.all16(),
                child: Column(
                  children: [
                    AppCustomAppbar(
                      appTitle: controller.isAdded.value
                          ? AppStrings.T.editAvailability
                          : AppStrings.T.addAvailability,
                      isPadding: true,
                    ),
                    const Gap(5),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(20),
                            AppText(
                              AppStrings.T.daysOpen,
                              style: context.textTheme.titleSmall,
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 120,
                              child: GridView.builder(
                                padding: const AppEdgeInsets.oB16(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  mainAxisExtent: 45,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: controller.days.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final day = controller.days[index];
                                  final isSelected = controller.selectedDays.contains(day);
                                  return GestureDetector(
                                    onTap: () => controller.toggleSelection(day),
                                    child: Container(
                                      padding: const AppEdgeInsets.hv105(),
                                      decoration: BoxDecoration(
                                        color: isSelected ? context.colorScheme.primary : context.colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      alignment: Alignment.center,
                                      child: AppText(
                                        controller.days[index],
                                        style: context.textTheme.bodySmall?.copyWith(
                                          color: isSelected
                                              ? context.colorScheme.onSecondary
                                              : context.colorScheme.secondaryFixedDim,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            AppText(AppStrings.T.blockOff, style: context.textTheme.titleSmall),
                            const Gap(10),
                            GestureDetector(
                              onTap: specificDayBottomSheet,
                              child: Container(
                                padding: const AppEdgeInsets.all20(),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13), color: context.colorScheme.secondary),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        AppStrings.T.specificDayOff,
                                        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    ImageView(Assets.svg.addCircle),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(10),
                            Obx(
                              () => controller.selectedDates.isNotEmpty
                                  ? Wrap(
                                      spacing: 5,
                                      children: List.generate(controller.selectedDates.length, (index) {
                                        final date = controller.selectedDates[index];
                                        return Chip(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: context.colorScheme.primary,
                                          deleteIcon: Icon(
                                            Icons.cancel,
                                            color: context.colorScheme.onPrimary,
                                          ),
                                          onDeleted: () {
                                            controller.selectedDates.removeAt(index);
                                            controller.selectedIntiDates.removeAt(index);
                                          },
                                          label: AppText(
                                            DateUtil.instance
                                                .changeDateFormat(date, format: DateUtil.instance.MMddyyyy),
                                            style: context.textTheme.bodySmall?.copyWith(fontSize: 13),
                                          ),
                                        );
                                      }),
                                    )
                                  : const SizedBox(),
                            ),
                            GestureDetector(
                              onTap: vacationBottomSheet,
                              child: Container(
                                padding: const AppEdgeInsets.all20(),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: context.colorScheme.secondary,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        AppStrings.T.vacation,
                                        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    ImageView(Assets.svg.addCircle),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.dateList.isNotEmpty)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 16, bottom: 50),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 40,
                                  crossAxisSpacing: 3,
                                ),
                                itemCount: controller.dateList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Chip(
                                    padding: const AppEdgeInsets.h5(),
                                    backgroundColor: context.colorScheme.primary,
                                    label: AppText(
                                      DateUtil.instance.changeDateFormat(controller.dateList[index],
                                          format: DateUtil.instance.MMddyyyy),
                                      style: context.textTheme.bodySmall?.copyWith(fontSize: 13),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    AppButton(
                      label: controller.isAdded.value ? AppStrings.T.save : AppStrings.T.add,
                      onPressed: () {
                        if (controller.isAdded.value) {
                          controller.updateAvailability();
                        } else {
                          controller.addBarAvailability();
                        }
                      },
                    ),
                    const CustomSizedBox()
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.onInitilized();
  }

  @override
  void onDispose() {}

  Future<dynamic> specificDayBottomSheet() async {
    final context = Get.context!;
    return Get.bottomSheet(
      isScrollControlled: true,
      AppBottomSheet(
        title: AppStrings.T.specificDayOff,
        positiveButtonTitle: AppStrings.T.done,
        isDivider: true,
        content: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: context.colorScheme.secondary,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //ImageView(Assets.svg.arrowLeft),
                    const Gap(10),
                    AppText(
                      ' | ',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.secondaryFixedDim.withAlpha(40),
                      ),
                    ),
                    const Gap(10),
                    //ImageView(Assets.svg.sRightArrow),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 380,
              child: SfDateRangePicker(
                showNavigationArrow: true,
                enablePastDates: false,
                minDate: DateTime.now(),
                backgroundColor: Colors.transparent,
                onSelectionChanged: controller.onSelectionChanged,
                initialSelectedDates: controller.selectedIntiDates,
                rangeTextStyle: context.textTheme.bodySmall,
                selectionTextStyle: context.textTheme.bodySmall,
                selectionMode: DateRangePickerSelectionMode.multiple,
                headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: Colors.transparent, textStyle: context.textTheme.labelSmall),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  trailingDatesTextStyle:
                      context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                  leadingDatesTextStyle:
                      context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                  disabledDatesTextStyle: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.secondaryFixedDim
                  ),
                  textStyle: context.textTheme.bodySmall,
                  cellDecoration: BoxDecoration(color: context.colorScheme.secondary, shape: BoxShape.circle),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  dayFormat: 'EEE',
                  showTrailingAndLeadingDates: true,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary, fontWeight: FontWeight.w500), // Customize header style
                  ),
                ),
              ),
            ),
          ],
        ),
        onPositivePressed: Get.back,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<dynamic> vacationBottomSheet() async {
    final context = Get.context!;
    final initialSelectedRanges = <PickerDateRange>[];
    if (controller.dateList.length >= 2) {
      final startV = controller.dateList.first;
      final endV = controller.dateList.last;

      debugPrint(startV);
      debugPrint(endV);

      initialSelectedRanges.add(
          PickerDateRange(DateUtil.instance.changeStringToDate(startV), DateUtil.instance.changeStringToDate(endV)));
    }

    return Get.bottomSheet(
      isScrollControlled: true,
      AppBottomSheet(
        title: AppStrings.T.vacation,
        isDivider: true,
        content: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(top: 8, right: 8),
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: context.colorScheme.secondary,
                ),
                alignment: Alignment.center,
                child: AppText(
                  ' | ',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.secondaryFixedDim.withAlpha(40),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 380,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SfDateRangePicker(
                  enablePastDates: false,
                  minDate: DateTime.now(),
                  backgroundColor: Colors.transparent,
                  onSelectionChanged: controller.onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.multiRange,
                  initialSelectedRanges: initialSelectedRanges,
                  rangeTextStyle: context.textTheme.bodySmall,
                  selectionTextStyle: context.textTheme.bodySmall,
                  headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: Colors.transparent, textStyle: context.textTheme.labelSmall),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    trailingDatesTextStyle:
                        context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                    leadingDatesTextStyle:
                        context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                    disabledDatesTextStyle: context.textTheme.bodySmall,
                    textStyle: context.textTheme.bodySmall,
                    cellDecoration: BoxDecoration(color: context.colorScheme.secondary, shape: BoxShape.circle),
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    dayFormat: 'EEE',
                    showTrailingAndLeadingDates: true,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary, fontWeight: FontWeight.w500), // Customize header style
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        positiveButtonTitle: AppStrings.T.done,
        onPositivePressed: Get.back,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
