import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/auth/owner/owner_register_profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/core/country_picker_util.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class RegisterOwnerProfilePage extends GetItHook<OwnerRegisterProfileController> {
  const RegisterOwnerProfilePage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.ownerProfile);
  }

  @override
  Widget build(BuildContext context) {
    final passObscure = true.obs;
    final passNewObscure = true.obs;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: FocusScope(
        child: Form(
          key: controller.formKey,
          child: Scaffold(
            body: ListView(
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
                        if (controller.imagePath.value.isNotEmpty)
                          ImageView(
                            controller.imagePath.value,
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
                            child: ImageView(
                              Assets.svg.sCamera,
                              color: context.colorScheme.onSecondary,
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
                  controller: controller.fullNameController,
                  hintLabel: AppStrings.T.enterFullName,
                  context: context,
                  prefixIcon: ImageView(
                    Assets.svg.profileCircle,
                    color: context.colorScheme.secondaryContainer,
                  ),
                  validator: AppValidations.nameValidation,
                ),
                const Gap(16),
                Obx(
                  () => CustomPhoneNumber(
                    showCountryOnly: true,
                    readOnly: true,
                    initialSelection: controller.countryFlag.value,
                    controller: controller.mobileNumberController,
                  ),
                ),
                const Gap(16),
                TextInputField(
                  type: InputType.text,
                  controller: controller.emailController,
                  hintLabel: AppStrings.T.enterEmail,
                  readOnly: true,
                  context: context,
                  prefixIcon: ImageView(
                    Assets.svg.email,
                    color: context.colorScheme.secondaryContainer,
                  ),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: context.colorScheme.secondary,
                      border: !controller.isGenderSelected.value && controller.selectedGender.value.isEmpty
                          ? Border.all(color: AppColors.red)
                          : const Border()),
                  child: Row(
                    children: [
                      ImageView(
                        Assets.svg.gender,
                        color: context.colorScheme.secondaryContainer,
                      ),
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
                                  AppStrings.T.chooseGender,
                                  style: context.textTheme.labelMedium?.copyWith(color: AppColors.greyTextColor),
                                ),
                              ),
                              value: controller.selectedGender.value.isNotEmpty ? controller.selectedGender.value : null,
                              // Set value to null if empty
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
                                      style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, fontSize: 16),
                                    ),
                                  ),
                                );
                              }).toList(),
                              icon: ImageView(
                                Assets.svg.arrowDown,
                                color: context.colorScheme.secondaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*Obx(() {
                  if (!controller.isGenderSelected.value && controller.selectedGender.value.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppText(
                        AppStrings.T.emptyGender,
                        style: context.textTheme.bodySmall!
                            .copyWith(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Return an empty widget if no error
                }),*/
                const Gap(16),
                TextInputField(
                  type: InputType.text,
                  controller: controller.addressController,
                  hintLabel: AppStrings.T.enterAddress,
                  context: context,
                  prefixIcon: ImageView(
                    Assets.svg.location,
                    color: context.colorScheme.secondaryContainer,
                  ),
                  validator: AppValidations.addressValidation,
                  minLines: 1,
                  maxLines: 2,
                  readOnly: true,
                  onTap: () async {
                    final prediction = await placePickerForAddress();
                    if (prediction != null) {
                      controller.addressController.text = prediction.description.toString().trim();
                    }
                  },
                ),
                const Gap(16),
                TextInputField(
                  type: InputType.text,
                  controller: controller.countryController,
                  hintLabel: AppStrings.T.chooseCountry,
                  context: context,
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
                      controller.countryController.text = p0.name;
                    },
                  ),
                  validator: AppValidations.countryValidation,
                ),
                const Gap(16),
                Obx(
                  () => TextInputField(
                    type: InputType.password,
                    context: context,
                    controller: controller.passController,
                    hintLabel: AppStrings.T.enterPassword,
                    obscureText: passObscure,
                    prefixIcon: ImageView(
                      Assets.svg.lock,
                      color: context.colorScheme.secondaryContainer,
                    ),
                    validator: AppValidations.passwordValidation,
                    errorMaxLines: 3,
                  ),
                ),
                const Gap(16),
                Obx(
                  () => TextInputField(
                    type: InputType.password,
                    textInputAction: TextInputAction.done,
                    context: context,
                    controller: controller.confirmPassController,
                    hintLabel: AppStrings.T.confirmPassword,
                    obscureText: passNewObscure,
                    prefixIcon: ImageView(
                      Assets.svg.lock,
                      color: context.colorScheme.secondaryContainer,
                    ),
                    validator: (value) => AppValidations.confirmPasswordValidation(value, controller.passController.text),
                  ),
                ),
              ],
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
    controller.genderList = [];
    controller.genderList.addAll(['Male', 'Female', 'Other']);
  }

  @override
  void onDispose() {
    controller.fullNameController.clear();
    controller.mobileNumberController.clear();
    controller.emailController.clear();
    controller.genderController.clear();
    controller.addressController.clear();
    controller.countryController.clear();
    controller.passController.clear();
    controller.confirmPassController.clear();
  }

  Future<dynamic> successBottomSheet() {
    return Get.bottomSheet(
      isDismissible: false,
      enableDrag: false,
      AppBottomSheet(
        canPOP: false,
        iconName: ImageView(Assets.svg.allDone),
        title: AppStrings.T.allDone,
        subTitle: AppStrings.T.yourProfileCreated,
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: Get.back,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
