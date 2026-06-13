import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/auth/owner/owner_register_controller.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/widgets/custom_auth_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_checkbox.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';

class OwnerRegisterPage extends GetItHook<OwnerRegisterController> {
  const OwnerRegisterPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.registerOwner);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: FocusScope(
        child: Form(
          key: controller.formKey,
          child: Scaffold(
            body: Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                children: [
                  AppAuthAppbar(
                    iconName: Padding(
                      padding: const AppEdgeInsets.all8(),
                      child: ImageView(
                        Assets.svg.userEdit,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    title: AppStrings.T.register,
                    subTitle: AppStrings.T.enterYourDetails,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const Gap(24),
                        CustomPhoneNumber(
                          showCountryOnly: true,
                          controller: controller.mobileNumberController,
                          onChanged: (country) {
                            controller.dialCode.value = country.dialCode;
                            controller.countryFlag.value = country.code;
                            controller.update();
                          },
                          // validator: AppValidations.phoneNumberValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.email,
                          controller: controller.emailController,
                          hintLabel: AppStrings.T.enterEmail,
                          textInputAction: TextInputAction.done,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.email),
                          validator: AppValidations.emailValidation,
                        ),
                        const Gap(20),
                        /*Row(
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
                        ),
                        const Gap(16),*/
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => CustomCheckbox(
                                value: controller.isChecked.value,
                                onTap: () {
                                  controller.isChecked.value = !controller.isChecked.value;
                                  controller.update();
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
                                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.normal),
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
                              controller.barOwnerRegisters();
                            })
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
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.authModel = Rxn<AuthModel>();
    controller.mobileNumberController = TextEditingController();
    controller.emailController = TextEditingController();
  }

  @override
  void onDispose() {
    controller.mobileNumberController.dispose();
    controller.emailController.dispose();
  }
}
