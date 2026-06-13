import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/add_availability_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_availability_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class AvailabilityPage extends GetItHook<AddAvailabilityController> {
  const AvailabilityPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.availabilityPage);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const AppEdgeInsets.all16(),
            child: Obx(
              () => Column(
                children: [
                  AppConstant.isOwnerLogin(
                    child: AppCustomAppbar(
                      appTitle: AppStrings.T.availability,
                      isPadding: true,
                      isSecondaryIcon: controller.isAdded.value,
                      secondaryIconName: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ImageView(Assets.svg.edit),
                      ),
                      onSecondaryTap: AddAvailabilityPage.route,
                    ),
                  ),
                  if (controller.isLoaded.value)
                    Column(
                      children: [
                        const Gap(200),
                        ImageView(Assets.svg.availability),
                        const Gap(20),
                        AppConstant.isOwnerLogin(
                          child: GestureDetector(
                            onTap: AddAvailabilityPage.route,
                            child: ImageView(Assets.svg.addAvailability),
                          ),
                        ),
                      ],
                    ),
                  if (controller.isAdded.value)
                    Column(
                      children: [
                        const Gap(20),
                        if (controller.daysOpen.isNotEmpty)
                          Container(
                            margin: const AppEdgeInsets.oB15(),
                            padding: const AppEdgeInsets.hv105(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: context.colorScheme.secondary,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: AppText(AppStrings.T.daysOpen, style: context.textTheme.bodyMedium),
                              subtitle: Padding(
                                padding: const AppEdgeInsets.v5(),
                                child: SizedBox(
                                  height: 20,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.daysOpen.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          AppText(
                                            controller.daysOpen[index],
                                            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                          ),
                                          if (index != controller.daysOpen.length - 1)
                                            AppText(
                                              ' - ',
                                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (controller.specificDaysOff.isNotEmpty)
                          Container(
                            width: Get.width,
                            margin: const AppEdgeInsets.oB15(),
                            padding: const AppEdgeInsets.hv105(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: context.colorScheme.secondary,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  AppStrings.T.specificDayOff,
                                  style: context.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                // spacing between title and wrap
                                Wrap(
                                  spacing: 8, // horizontal spacing
                                  runSpacing: 8, // vertical spacing
                                  children: controller.specificDaysOff.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final date = entry.value;
                                    final isLast = index == controller.specificDaysOff.length - 1;

                                    return AppText(
                                      '${DateFormat(DateUtil.instance.ddMM).format(DateTime.parse(date))}${isLast ? '' : '  | '}',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colorScheme.secondaryFixedDim,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        if (controller.vacation.isNotEmpty)
                          Container(
                            width: Get.width,
                            margin: const AppEdgeInsets.oB15(),
                            padding: const AppEdgeInsets.hv105(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: context.colorScheme.secondary,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  AppStrings.T.vacation,
                                  style: context.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: controller.vacation.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final vacationItem = entry.value;

                                    final fromDate = vacationItem.fromDate ?? '';
                                    final toDate = vacationItem.toDate ?? '';

                                    final formattedFrom = DateFormat(DateUtil.instance.ddMM).format(DateTime.parse(fromDate));
                                    final formattedTo = DateFormat(DateUtil.instance.ddMM).format(DateTime.parse(toDate));

                                    final isLast = index == controller.vacation.length - 1;

                                    return AppText(
                                      '$formattedFrom To $formattedTo${isLast ? '' : ' |'}',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colorScheme.secondaryFixedDim,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                ],
              ),
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
    controller.dateList = [];
    controller.selectedDays = [];
    controller.daysOpen.value = [];
    controller.selectedDates = <String>[].obs;
    controller.selectedIntiDates = [];
    controller.selectedIntiRangeDates = [];
    controller.getBarAvailability();
  }

  @override
  void onDispose() {
    controller.isAdded.value = false;
    controller.dateList = [];
    controller.selectedDays = [];
    controller.daysOpen.value = [];
    controller.selectedDates = <String>[].obs;
    controller.selectedIntiDates = [];
    controller.selectedIntiRangeDates = [];
    controller.isLoaded.value = false;
  }
}
