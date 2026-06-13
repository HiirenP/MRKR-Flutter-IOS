import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/auth/owner/owner_register_profile_controller.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/core/country_picker_util.dart';
import 'package:marker/app/utils/core/time_picker_util.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:time_range_picker/time_range_picker.dart';

class RegisterBarProfilePage extends GetItHook<OwnerRegisterProfileController> {
  const RegisterBarProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        key: controller.formBarKey,
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                onTap: () {
                  profilePictureBottomSheet(
                      title: AppStrings.T.uploadBarLogo,
                      subTitle: AppStrings.T.chooseBarLogo,
                      selectedPath: (String path) {
                        controller.barLogoPath.value = path;
                      });
                },
                child: Obx(
                  () => Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      if (controller.barLogoPath.value.isNotEmpty)
                        ImageView(
                          controller.barLogoPath.value,
                          inner: ImageSize(height: 130, width: 130),
                          shape: BoxShape.circle,
                        )
                      else
                        CircleAvatar(
                          radius: 60,
                          child: ImageView(
                            Assets.svg.user,
                            inner: ImageSize(height: 70, width: 70),
                          ),
                        ),
                      Positioned(
                        bottom: -13,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: context.colorScheme.primary,
                          child: Obx(
                            () => ImageView(
                              controller.barLogoPath.value.isEmpty ? Assets.svg.sCamera : Assets.svg.edit,
                              color: context.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Gap(26),
              TextInputField(
                type: InputType.text,
                controller: controller.barNameController,
                hintLabel: AppStrings.T.enterBarName,
                context: context,
                prefixIcon: ImageView(
                  Assets.svg.barMainBuilding,
                  color: context.colorScheme.secondaryContainer,
                ),
                validator: AppValidations.barNameValidation,
              ),
              const Gap(16),
              CustomPhoneNumber(
                showCountryOnly: true,
                // validator: AppValidations.phoneNumberValidation,
                controller: controller.barMobileNumberController,
                onChanged: (country) {
                  controller.dialCode.value = country.dialCode;
                  controller.countryFlag.value = country.code;
                },
              ),
              const Gap(16),
              TextInputField(
                type: InputType.email,
                validator: AppValidations.emailValidation,
                controller: controller.barEmailController,
                hintLabel: AppStrings.T.enterEmail,
                context: context,
                prefixIcon: ImageView(
                  Assets.svg.email,
                  color: context.colorScheme.secondaryContainer,
                ),
              ),
              const Gap(16),
              TextInputField(
                type: InputType.text,
                controller: controller.barTimeController,
                hintLabel: AppStrings.T.selectOpeningHours,
                context: context,
                readOnly: true,
                prefixIcon: ImageView(
                  Assets.svg.clock,
                  color: AppColors.greyIconColor,
                ),
                suffixIcon: ImageView(
                  Assets.svg.arrowRight,
                  color: AppColors.greyIconColor,
                ),
                onTap: () async {
                  final result = await TimePickerUtils().timerPicker();
                  if (result != null) {
                    final time = result as TimeRange;
                    controller.fromTime.value = DateUtil().changeDateFormat(
                        '${time.startTime.hour}:${time.startTime.minute}',
                        format: DateUtil.instance.hhMMA,
                        input: DateUtil.instance.hhMM);

                    controller.toTime.value = DateUtil().changeDateFormat('${time.endTime.hour}:${time.endTime.minute}',
                        format: DateUtil.instance.hhMMA, input: DateUtil.instance.hhMM);
                    controller.barTimeController.text = '${controller.fromTime.value} - ${controller.toTime.value}';
                  }
                },
                validator: (value) =>
                    AppValidations.openingHourValidation(controller.toTime.value, controller.fromTime.value, value),
              ),
              const Gap(16),
              TextInputField(
                type: InputType.text,
                controller: controller.barAddressController,
                hintLabel: AppStrings.T.enterAddress,
                context: context,
                prefixIcon: ImageView(
                  Assets.svg.location,
                  color: context.colorScheme.secondaryContainer,
                ),
                minLines: 1,
                maxLines: 2,
                validator: AppValidations.addressValidation,
                readOnly: true,
                onTap: () async {
                  final prediction = await placePickerForAddress();
                  if (prediction != null) {
                    controller.barAddressController.text = prediction.description.toString().trim();
                    final geometry = await latLongFromPlaceId(prediction.placeId ?? '');
                    if (geometry != null) {
                      controller.currentPosition.value = LatLng(geometry.location.lat, geometry.location.lng);
                    }
                  }
                },
              ),
              const Gap(16),
              TextInputField(
                type: InputType.text,
                context: context,
                controller: controller.barCityController,
                hintLabel: AppStrings.T.enterCity,
                prefixIcon: ImageView(Assets.svg.buliding),
                validator: AppValidations.cityValidation,
              ),
              const Gap(16),
              TextInputField(
                type: InputType.text,
                context: context,
                controller: controller.barStateController,
                hintLabel: AppStrings.T.enterState,
                prefixIcon: ImageView(Assets.svg.routing),
                validator: AppValidations.stateValidation,
              ),
              const Gap(16),
              TextInputField(
                type: InputType.text,
                controller: controller.barCountryController,
                hintLabel: AppStrings.T.chooseCountry,
                context: context,
                textInputAction: TextInputAction.done,
                prefixIcon: ImageView(
                  Assets.svg.global,
                  color: context.colorScheme.secondaryContainer,
                ),
                suffixIcon: ImageView(
                  Assets.svg.arrowDown,
                  color: context.colorScheme.secondaryContainer,
                ),
                readOnly: true,
                onTap: () => CountryPickerUtil().countryPick(
                  context: context,
                  selectedItem: (p0) {
                    controller.barCountryController.text = p0.name;
                  },
                ),
                validator: AppValidations.countryValidation,
              ),
              const Gap(16),
              GestureDetector(
                onTap: () {
                  profilePictureBottomSheet(
                      title: AppStrings.T.uploadBarPhotos,
                      subTitle: AppStrings.T.chooseBarPhotos,
                      selectedPath: (String path) {
                        controller.barPhotosPathList.add(path);
                      });
                },
                child: Container(
                  width: Get.width,
                  height: 124,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageView(
                        Assets.svg.export,
                        color: context.colorScheme.secondaryContainer,
                        inner: ImageSize(width: 25, height: 25),
                      ),
                      const Gap(15),
                      CenterText(
                        AppStrings.T.uploadBarPhotos,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.theme.colorScheme.secondaryFixedDim,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),
              Obx(
                () => GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisExtent: 100, mainAxisSpacing: 10),
                  itemCount: controller.barPhotosPathList.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ImageView(
                          controller.barPhotosPathList[index],
                          borderRadius: BorderRadius.circular(12),
                          inner: ImageSize(width: 100, height: 110),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.removeImage(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3, right: 10),
                            child: ImageView(Assets.svg.closeCircle),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {}

  @override
  void onDispose() {}

/*  Future<dynamic> openingHourBottomSheet() async {
    final context = Get.context!;
    return Get.bottomSheet(
      isScrollControlled: true,
      AppBottomSheet(
        title: AppStrings.T.openingHours,
        positiveButtonTitle: AppStrings.T.set,
        isDivider: true,
        content: Column(
          children: [
            Padding(
              padding: const AppEdgeInsets.h16(),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (!controller.isFromTime.value) {
                          controller.isFromTime.value = true;
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const AppEdgeInsets.h16(),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageView(Assets.svg.clock,
                                color: controller.isFromTime.value ? AppColors.black : AppColors.greyIconColor,
                                inner: ImageSize(height: 24, width: 24)),
                            const Gap(5),
                            AppText(controller.fromTime.value,
                                style: context.theme.textTheme.labelSmall?.copyWith(
                                    color: controller.isFromTime.value ? AppColors.black : AppColors.greyIconColor)),
                          ],
                        ),
                      ),
                    )),
                    const Gap(15),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (controller.isFromTime.value) {
                          controller.isFromTime.value = false;
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const AppEdgeInsets.h16(),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageView(
                              Assets.svg.clock,
                              color: !controller.isFromTime.value ? AppColors.black : AppColors.greyIconColor,
                              inner: ImageSize(height: 24, width: 24),
                            ),
                            const Gap(5),
                            AppText(controller.toTime.value,
                                style: context.theme.textTheme.labelSmall?.copyWith(
                                    color: !controller.isFromTime.value ? AppColors.black : AppColors.greyIconColor)),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                    value: controller.hourTime.value,
                    minValue: 1,
                    maxValue: 12,
                    itemCount: 5,
                    itemWidth: 50,
                    selectedTextStyle: context.textTheme.titleSmall,
                    textStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                    onChanged: (value) {
                      controller.hourTime.value = value;
                      if (controller.isFromTime.value) {
                        controller.fromTime.value =
                            '$value:${controller.minuteTime} ${controller.checkAmPm(controller.amPm.value)}';
                      } else {
                        controller.toTime.value =
                            '$value:${controller.minuteTime} ${controller.checkAmPm(controller.amPm.value)}';
                      }
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                  ),
                  const Gap(15),
                  NumberPicker(
                    value: controller.minuteTime.value,
                    minValue: 0,
                    maxValue: 59,
                    itemCount: 5,
                    itemWidth: 50,
                    selectedTextStyle: context.textTheme.titleSmall,
                    textStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                    onChanged: (value) {
                      controller.minuteTime.value = value;
                      if (controller.isFromTime.value) {
                        controller.fromTime.value =
                            '${controller.hourTime.value}:$value ${controller.checkAmPm(controller.amPm.value)}';
                      } else {
                        controller.toTime.value =
                            '${controller.hourTime.value}:$value ${controller.checkAmPm(controller.amPm.value)}';
                      }
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                  ),
                  const Gap(15),
                  NumberPicker(
                    value: controller.amPm.value,
                    textMapper: (numberText) {
                      final value = numberText;
                      return value == '0' ? 'AM' : 'PM';
                    },
                    minValue: 0,
                    maxValue: 1,
                    itemCount: 5,
                    itemWidth: 50,
                    selectedTextStyle: context.textTheme.titleSmall,
                    textStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                    onChanged: (value) {
                      controller.amPm.value = value;
                      if (controller.isFromTime.value) {
                        controller.fromTime.value =
                            '${controller.hourTime.value}:${controller.minuteTime.value} ${controller.checkAmPm(value)}';
                      } else {
                        controller.toTime.value =
                            '${controller.hourTime.value}:${controller.minuteTime.value} ${controller.checkAmPm(value)}';
                      }
                    },
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ],
        ),
        onPositivePressed: () {
          controller.barTimeController.text = '${controller.fromTime.value}-${controller.toTime.value}';
          Get.back();
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }*/
}
