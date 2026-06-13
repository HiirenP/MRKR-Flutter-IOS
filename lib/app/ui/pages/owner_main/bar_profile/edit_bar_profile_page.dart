import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart' show Gap;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/edit_bar_profile_controller.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/core/country_picker_util.dart';
import 'package:marker/app/utils/core/time_picker_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditBarProfilePage extends GetItHook<EditBarProfileController> {
  const EditBarProfilePage({super.key});

  static Future<T?>? route<T>(BarGetUpdateData? barData) {
    return Get.toNamed(AppRoutes.editBarProfilePage, arguments: barData);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: FocusScope(
        child: Form(
          key: controller.formKey,
          child: Scaffold(
            body: SafeArea(
              top: false,
              bottom: false,
              child: Padding(
                padding: const AppEdgeInsets.all16(),
                child: Column(
                  children: [
                    AppCustomAppbar(
                      appTitle: AppStrings.T.editBarProfile,
                      isPadding: true,
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          GestureDetector(
                            onTap: () => profilePictureBottomSheet(
                              title: AppStrings.T.uploadBarLogo,
                              subTitle: AppStrings.T.chooseBarLogo,
                              selectedPath: (p0) {
                                controller.barLogo.value = p0;
                              },
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  child: Obx(
                                    () => ImageView(
                                      controller.barLogo.value.isEmpty ? Assets.svg.user : controller.barLogo.value,
                                      shape: BoxShape.circle,
                                      outer: controller.barLogo.value.isEmpty ? ImageSize(dimension: 60) : ImageSize(dimension: 120),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -13,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: context.colorScheme.primary,
                                    child: ImageView(Assets.svg.edit),
                                  ),
                                )
                              ],
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
                              color: context.colorScheme.onSecondary,
                            ),
                            validator: AppValidations.barNameValidation,
                          ),
                          const Gap(16),
                          CustomPhoneNumber(
                            showCountryOnly: true,
                            // validator: AppValidations.phoneNumberValidation,
                            controller: controller.barMobileNumberController,
                            initialSelection: controller.countryFlag.value,
                            onChanged: (country) {
                              controller.iso.value = country.dialCode;
                              controller.countryFlag.value = country.code;
                              controller.update();
                            },
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            validator: AppValidations.emailValidation,
                            controller: controller.barEmailController,
                            hintLabel: AppStrings.T.enterEmail,
                            context: context,
                            prefixIcon: ImageView(
                              Assets.svg.email,
                              color: context.colorScheme.onSecondary,
                            ),
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            validator: (value) => AppValidations.openingHourValidation(controller.toTime.value, controller.fromTime.value, value),
                            controller: controller.barTimeController,
                            hintLabel: AppStrings.T.selectOpeningHours,
                            context: context,
                            readOnly: true,
                            prefixIcon: ImageView(
                              Assets.svg.clock,
                              color: context.colorScheme.onSecondary,
                            ),
                            suffixIcon: ImageView(
                              Assets.svg.arrowRight,
                              color: context.colorScheme.onSecondary,
                            ),
                            onTap: () async {
                              // Validate and parse time values, use defaults if invalid
                              var startHourValue = 9; // Default 9 AM
                              var startMinValue = 0;
                              var endHourValue = 17; // Default 5 PM
                              var endMinValue = 0;

                              try {
                                if (controller.startHour.isNotEmpty && controller.startHour != 'NaN') {
                                  startHourValue = int.parse(controller.startHour);
                                }
                                if (controller.startMin.isNotEmpty && controller.startMin != 'NaN') {
                                  startMinValue = int.parse(controller.startMin);
                                }
                                if (controller.endHour.isNotEmpty && controller.endHour != 'NaN') {
                                  endHourValue = int.parse(controller.endHour);
                                }
                                if (controller.endMin.isNotEmpty && controller.endMin != 'NaN') {
                                  endMinValue = int.parse(controller.endMin);
                                }
                              } catch (e) {
                                debugPrint('Error parsing time values: $e');
                              }

                              final result = await TimePickerUtils().timerPicker(
                                start: TimeOfDay(hour: startHourValue, minute: startMinValue),
                                end: TimeOfDay(hour: endHourValue, minute: endMinValue),
                              );
                              if (result != null) {
                                final time = result as TimeRange;
                                controller.fromTime.value = DateUtil().changeDateFormat('${time.startTime.hour}:${time.startTime.minute}',
                                    format: DateUtil.instance.hhMMA, input: DateUtil.instance.hhMM);

                                controller.toTime.value = DateUtil().changeDateFormat('${time.endTime.hour}:${time.endTime.minute}',
                                    format: DateUtil.instance.hhMMA, input: DateUtil.instance.hhMM);
                                controller.barTimeController.text = '${controller.fromTime.value} - ${controller.toTime.value}';
                                controller.startHour =
                                    DateUtil().changeDateFormat(controller.fromTime.value, format: 'k', input: DateUtil.instance.hhMMA);
                                controller.startMin =
                                    DateUtil().changeDateFormat(controller.fromTime.value, format: 'm', input: DateUtil.instance.hhMMA);
                                controller.endHour =
                                    DateUtil().changeDateFormat(controller.toTime.value, format: 'k', input: DateUtil.instance.hhMMA);
                                controller.endMin = DateUtil().changeDateFormat(controller.toTime.value, format: 'm', input: DateUtil.instance.hhMMA);
                              }
                            },
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            controller: controller.barAddressController,
                            hintLabel: AppStrings.T.enterAddress,
                            context: context,
                            prefixIcon: ImageView(
                              Assets.svg.location,
                              color: context.colorScheme.onSecondary,
                            ),
                            readOnly: true,
                            onTap: () async {
                              final prediction = await placePickerForAddress();
                              if (prediction != null) {
                                controller.barAddressController.text = prediction.description.toString().trim();
                                final id = prediction.placeId;
                                if (id != null) {
                                  final geoLocation = await latLongFromPlaceId(id);
                                  if (geoLocation != null) {
                                    controller.currentPosition.value = LatLng(geoLocation.location.lat, geoLocation.location.lng);
                                    debugPrint('controller.currentPosition.value-->${controller.currentPosition.value}');
                                  }
                                }
                              }
                            },
                            validator: AppValidations.addressValidation,
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            context: context,
                            controller: controller.barCityController,
                            hintLabel: AppStrings.T.enterCity,
                            textInputAction: TextInputAction.done,
                            prefixIcon: ImageView(
                              Assets.svg.buliding,
                              color: context.colorScheme.onSecondary,
                            ),
                            validator: AppValidations.cityValidation,
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            context: context,
                            controller: controller.barStateController,
                            hintLabel: AppStrings.T.enterState,
                            validator: AppValidations.stateValidation,
                            textInputAction: TextInputAction.done,
                            prefixIcon: ImageView(
                              Assets.svg.routing,
                              color: context.colorScheme.onSecondary,
                            ),
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            controller: controller.barCountryController,
                            hintLabel: AppStrings.T.chooseCountry,
                            context: context,
                            prefixIcon: ImageView(
                              Assets.svg.global,
                              color: context.colorScheme.onSecondary,
                            ),
                            suffixIcon: ImageView(
                              Assets.svg.arrowDown,
                              color: context.colorScheme.onSecondary,
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
                            onTap: () => controller.uploadImages(),
                            child: Container(
                              width: Get.width,
                              height: 124,
                              alignment: Alignment.center,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
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
                          Obx(() {
                            final allImagePaths = [
                              ...controller.images.map((e) => e.url ?? ''),
                              // convert Images to String path
                              ...controller.galleryImage
                            ];

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 100,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: allImagePaths.length,
                              itemBuilder: (context, index) {
                                final image = allImagePaths[index];
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ImageView(
                                      image,
                                      borderRadius: BorderRadius.circular(12),
                                      inner: ImageSize(width: 100, height: 110),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.removeImages(index),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3, right: 10),
                                        child: ImageView(Assets.svg.closeCircle),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                          const Gap(30),
                        ],
                      ),
                    ),
                    AppButton(
                        label: AppStrings.T.save,
                        onPressed: () {
                          controller.updateBarOwnerData();
                        }),
                    const CustomSizedBox()
                  ],
                ),
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
    controller.isDeleted = false;
    controller.images.value = [];
    controller.galleryImage.value = [];
    controller.barNameController = TextEditingController();
    controller.barMobileNumberController = TextEditingController();
    controller.barEmailController = TextEditingController();
    controller.barTimeController = TextEditingController();
    controller.barAddressController = TextEditingController();
    controller.barCityController = TextEditingController();
    controller.barStateController = TextEditingController();
    controller.barCountryController = TextEditingController();
    if (Get.arguments != null) {
      if (Get.arguments is BarGetUpdateData) {
        final data = Get.arguments;
        controller.setEditProfileData(data as BarGetUpdateData);
      }
    }
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
