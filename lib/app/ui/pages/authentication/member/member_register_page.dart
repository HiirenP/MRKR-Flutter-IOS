import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/auth/member/member_register_controller.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_auth_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_checkbox.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
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

class MemberRegisterPage extends GetItHook<MemberRegisterController> {
  const MemberRegisterPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.registerMember);
  }

  @override
  Widget build(BuildContext context) {
    final passObscure = true.obs;
    final confirmPassObscure = true.obs;
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
                    AppAuthAppbar(
                      isTopPadding: true,
                      title: AppStrings.T.register,
                      subTitle: AppStrings.T.enterYourDetails,
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const Gap(24),
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
                                      child: Obx(
                                        () => ImageView(
                                          controller.imagePath.value.isEmpty ? Assets.svg.sCamera : Assets.svg.edit,
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
                          CustomPhoneNumber(
                            showCountryOnly: true,
                            controller: controller.mobileNumberController,
                            onChanged: (country) {
                              controller.dialCode.value = country.dialCode;
                              controller.countryFlag.value = country.code;
                            },
                            // validator: AppValidations.phoneNumberValidation,
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.email,
                            controller: controller.emailController,
                            hintLabel: AppStrings.T.enterEmail,
                            context: context,
                            prefixIcon: ImageView(Assets.svg.email),
                            validator: AppValidations.emailValidation,
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
                          /* Obx(() {
                            if (!controller.isGenderSelected.value && controller.selectedGender.value.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4), // Add some space above the message
                                child: AppText(
                                  AppStrings.T.emptyGender, // Validation message
                                  style: context.textTheme.bodySmall!.copyWith(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500), // Style for the error message
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
                            minLines: 1,
                            maxLines: 2,
                            readOnly: true,
                            onTap: () async {
                              final prediction = await placePickerForAddress();
                              if (prediction != null) {
                                controller.addressController.text = prediction.description.toString().trim();
                              }
                            },
                            prefixIcon: ImageView(
                              Assets.svg.location,
                              color: context.colorScheme.secondaryContainer,
                            ),
                            validator: AppValidations.addressValidation,
                          ),
                          const Gap(16),
                          TextInputField(
                            type: InputType.text,
                            controller: controller.countryController,
                            hintLabel: AppStrings.T.chooseCountry,
                            context: context,
                            validator: AppValidations.countryValidation,
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
                          ),
                          const Gap(16),
                          Obx(
                            () => TextInputField(
                              type: InputType.password,
                              context: context,
                              controller: controller.passController,
                              validator: AppValidations.passwordValidation,
                              hintLabel: AppStrings.T.enterPassword,
                              errorMaxLines: 3,
                              obscureText: passObscure,
                              prefixIcon: ImageView(
                                Assets.svg.lock,
                                color: context.colorScheme.secondaryContainer,
                              ),
                            ),
                          ),
                          const Gap(16),
                          Obx(
                            () => TextInputField(
                              type: InputType.password,
                              context: context,
                              controller: controller.confirmPassController,
                              hintLabel: AppStrings.T.confirmPassword,
                              obscureText: confirmPassObscure,
                              textInputAction: TextInputAction.done,
                              onChanged: (value) {},
                              validator: (val) => AppValidations.confirmPasswordValidation(val, controller.passController.text),
                              prefixIcon: ImageView(
                                Assets.svg.lock,
                                color: context.colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          /*const Gap(20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => CustomCheckbox(
                                  value: controller.channelType.value == ChannelType.sms,
                                  onTap: () {
                                    if (controller.channelType.value == ChannelType.sms) {
                                      controller.channelType.value = ChannelType.email;
                                    } else {
                                      controller.channelType.value = ChannelType.sms;
                                    }
                                  },
                                ),
                              ),
                              const Gap(5),
                              Expanded(
                                child: AppText(
                                  AppStrings.T.getYourViaSMS,
                                  style: context.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.normal, color: context.colorScheme.secondaryFixedDim),
                                ),
                              ),
                            ],
                          ),*/
                          const Gap(20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => CustomCheckbox(
                                  value: controller.isChecked.value,
                                  onTap: () {
                                    controller.isChecked.value = !controller.isChecked.value;
                                  },
                                ),
                              ),
                              const Gap(5),
                              Expanded(
                                child: AppRichText(
                                  textAlign: TextAlign.start,
                                  spans: [
                                    AppSpan(
                                      text: AppStrings.T.iAgreeTo,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(color: context.colorScheme.secondaryFixedDim, fontWeight: FontWeight.normal),
                                    ),
                                    AppSpan(
                                        text: AppStrings.T.privacyPolicy,
                                        style:
                                            context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.normal),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            PrivacyPolicyPage.route(AppStrings.T.privacyPolicy, url: AppConfig.privacyPolicy);
                                          }),
                                    AppSpan(
                                      text: AppStrings.T.and,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(color: context.colorScheme.secondaryFixedDim, fontWeight: FontWeight.normal),
                                    ),
                                    AppSpan(
                                      text: AppStrings.T.termsConditions,
                                      style:
                                          context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.normal),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          PrivacyPolicyPage.route(AppStrings.T.termsConditions, url: AppConfig.termsConditions);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(30),
                          AppButton(
                              label: AppStrings.T.register,
                              onPressed: () {
                                controller.memberRegisters(context);
                              }),
                        ],
                      ),
                    ),
                    const Gap(10),
                    AppRichText(
                      spans: [
                        AppSpan(
                          text: AppStrings.T.alreadyAccount,
                          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.secondaryFixedDim),
                        ),
                        AppSpan(
                            text: AppStrings.T.logIn,
                            style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back(result: true);
                              }),
                      ],
                    ),
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
    controller.selectedGender.value = '';
    controller.isChecked.value = false;
    controller.isGenderSelected.value = true;
    controller.dialCode.value = '+376';
    controller.countryFlag.value = 'AD';
    controller.imagePath.value = '';
    controller.genderList = [];
    controller.genderList.addAll(['Male', 'Female', 'Other']);
  }

  @override
  void onDispose() {
    controller.dialCode.value = '+376';
    controller.countryFlag.value = 'AD';
    controller.imagePath.value = '';
    controller.isGenderSelected.value = true;
    controller.isChecked.value = false;
    controller.selectedGender.value = '';
    controller.fullNameController.clear();
    controller.mobileNumberController.clear();
    controller.emailController.clear();
    controller.genderController.clear();
    controller.addressController.clear();
    controller.countryController.clear();
    controller.passController.clear();
    controller.confirmPassController.clear();
  }
}
