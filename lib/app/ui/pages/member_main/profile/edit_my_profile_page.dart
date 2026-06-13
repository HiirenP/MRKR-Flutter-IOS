import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/core/country_picker_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';

class EditMyProfilePage extends GetItHook<ProfileController> {
  const EditMyProfilePage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.editMyProfilePage);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
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
                  AppCustomAppbar(appTitle: AppStrings.T.editProfile, isPadding: true),
                  const Gap(20),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        GestureDetector(
                          onTap: () {
                            profilePictureBottomSheet(
                                title: AppStrings.T.uploadPhoto,
                                subTitle: AppStrings.T.chooseUploadPhoto,
                                selectedPath: (String path) {
                                  controller.imagePath.value = path;
                                });
                          },
                          child: Obx(
                            () => Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                ImageView(
                                  controller.imagePath.value.isNotEmpty
                                      ? controller.imagePath.value
                                      : controller.profileImage.value,
                                  inner: ImageSize(height: 130, width: 130),
                                  shape: BoxShape.circle,
                                ),
                                Positioned(
                                  bottom: -13,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: context.colorScheme.primary,
                                    child: Obx(
                                      () => ImageView(
                                        controller.profileImage.value.isEmpty ? Assets.svg.sCamera : Assets.svg.edit,
                                        color: context.colorScheme.onSecondary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Gap(24),
                            TextInputField(
                              type: InputType.text,
                              controller: controller.fullNameController,
                              hintLabel: AppStrings.T.enterFullName,
                              context: context,
                              prefixIcon: ImageView(
                                Assets.svg.profileCircle,
                                color: context.colorScheme.onSecondary,
                              ),
                              validator: AppValidations.nameValidation,
                            ),
                            const Gap(16),
                            CustomPhoneNumber(
                              showCountryOnly: true,
                              controller: controller.mobileNumberController,
                              initialSelection: controller.flag.isNotEmpty ? controller.flag : 'US',
                              onChanged: (value) {
                                debugPrint('controller.dialCode.value-->${value.dialCode}');
                              controller.dialCode.value=value.dialCode;
                              controller.flag=value.code;
                              debugPrint('controller.flagUri.value-->${value.code}');
                              },
                              // validator: AppValidations.phoneNumberValidation,
                            ),
                            const Gap(16),
                            TextInputField(
                              type: InputType.email,
                              controller: controller.emailController,
                              hintLabel: AppStrings.T.enterEmail,
                              context: context,
                              readOnly: true,
                              prefixIcon: ImageView(Assets.svg.email),
                              labelStyle: context.textTheme.labelMedium?.copyWith(color: AppColors.greyTextColor),
                            ),
                            const Gap(16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.colorScheme.secondary,
                              ),
                              child: Row(
                                children: [
                                  ImageView(Assets.svg.gender),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Obx(
                                        () => DropdownButton<String>(
                                          isExpanded: true,
                                          underline: const SizedBox.shrink(),
                                          style: context.textTheme.labelMedium,
                                          hint: Padding(
                                            padding: const EdgeInsets.only(left: 6),
                                            child: AppText(
                                              controller.selectedGender.value,
                                              style: context.textTheme.labelMedium,
                                            ),
                                          ),
                                          value: controller.selectedGender.value,
                                          onChanged: (String? newGender) {
                                            controller.selectedGender.value = newGender ?? '';
                                          },
                                          items: controller.genderList.map<DropdownMenuItem<String>>((String gender) {
                                            return DropdownMenuItem<String>(
                                              value: gender,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 6),
                                                child: AppText(
                                                  gender,
                                                  style: context.textTheme.bodyMedium
                                                      ?.copyWith(fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          icon: ImageView(
                                            Assets.svg.arrowDown,
                                            color: context.colorScheme.onSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),
                            TextInputField(
                              type: InputType.text,
                              textInputAction: TextInputAction.done,
                              controller: controller.addressController,
                              hintLabel: AppStrings.T.enterAddress,
                              context: context,
                              readOnly: true,
                              onTap: () async {
                                final prediction = await placePickerForAddress();
                                if (prediction != null) {
                                  controller.addressController.text = prediction.description.toString().trim();
                                }
                              },
                              minLines: 1,
                              maxLines: 2,
                              prefixIcon: ImageView(Assets.svg.location),
                            ),
                            const Gap(16),
                            TextInputField(
                              type: InputType.text,
                              controller: controller.countryController,
                              hintLabel: AppStrings.T.chooseCountry,
                              context: context,
                              readOnly: true,
                              suffixIcon: ImageView(Assets.svg.arrowDown),
                              prefixIcon: ImageView(Assets.svg.global),
                              onTap: () {
                                CountryPickerUtil().countryPick(
                                  context: context,
                                  selectedItem: (p0) {
                                    controller.countryController.text = p0.name;
                                  },
                                );
                              },
                            ),
                            const Gap(60),
                            AppButton(
                              label: AppStrings.T.save,
                              onPressed: () => controller.updateProfileAPI(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
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
    controller.getUserData();
  }

  @override
  void onDispose() {
    controller.imagePath.value = '';
    controller.fullNameController.dispose();
    controller.mobileNumberController.dispose();
    controller.emailController.dispose();
    controller.addressController.dispose();
    controller.countryController.dispose();
    controller.selectedGender.value = AppStrings.T.male;
  }
}
