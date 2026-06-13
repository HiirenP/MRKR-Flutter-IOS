import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/auth/verification_controller.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_auth_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodePage extends GetItHook<VerificationController> {
  const VerifyCodePage({super.key});

  static Future<T?>? route<T>({dynamic argument}) async {
    return Get.toNamed(AppRoutes.verifyCode, arguments: argument);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const AppEdgeInsets.all16(),
            child: Obx(() {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        AppAuthAppbar(
                          title: AppStrings.T.authentication,
                          subTitle: AppStrings.T.enterVerification(controller.channelType.value.backendValue),
                          iconName: ImageView(Assets.svg.auth),
                        ),
                        const Gap(24),
                        PinCodeTextField(
                          length: 4,
                          animationType: AnimationType.fade,
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: 60,
                            fieldWidth: 76,
                            selectedColor: context.colorScheme.secondary,
                            activeFillColor: context.colorScheme.secondary,
                            activeColor: context.colorScheme.secondary,
                            inactiveFillColor: context.colorScheme.secondary,
                            inactiveColor: context.colorScheme.secondary,
                            selectedFillColor: context.colorScheme.secondary,
                            disabledColor: context.colorScheme.secondary,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: context.colorScheme.onPrimary,
                          enableActiveFill: true,
                          controller: controller.verificationCode,
                          textStyle: context.theme.textTheme.headlineMedium,
                          onCompleted: (v) {
                            debugPrint('Completed');
                          },
                          onChanged: (value) {
                            debugPrint(value);
                          },
                          beforeTextPaste: (text) {
                            debugPrint('Allowing0 to paste $text');
                            return true;
                          },
                          validator: AppValidations.otpValidation,
                          appContext: context,
                        ),
                        const Gap(100),
                        AppButton(
                          label: AppStrings.T.verify,
                          onPressed: () {
                            if (!controller.formKey.currentState!.validate()) {
                              return;
                            }
                            if (controller.verificationCode.text.length != 4) {
                              showError(AppStrings.T.emptyOTP);
                              return;
                            }
                            if (controller.isMemberResister) {
                              controller.memberRegister(controller.firstArg);
                            } else if (controller.isResister) {
                              controller.verifyRegisterOTP(context);
                            } else {
                              controller.verifyForgotPassOTP();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.channelType.value = ChannelType.sms;
                      controller.resendOtp();
                    },
                    child: AppText(
                      AppStrings.T.getYourViaSMS,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal, color: context.colorScheme.primary, decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppRichText(
                    spans: [
                      AppSpan(
                        text: AppStrings.T.dontReceive,
                        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                      ),
                      AppSpan(
                        text: ' ',
                        style: context.textTheme.bodyMedium,
                      ),
                      AppSpan(
                          text: AppStrings.T.resend,
                          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              controller.resendOtp();
                            }),
                    ],
                  ),
                  const Gap(5),
                  const CustomSizedBox()
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.verificationCode = TextEditingController();

    final args = Get.arguments;

    if (args != null) {
      final firstArg = args;
      if (firstArg is Map<String, dynamic>) {
        controller.firstArg = firstArg;
        if (firstArg['userType'] != null && firstArg['userType'] == 'member') {
          controller.isMemberResister = true;
          // controller.sendOTPForRegister();
        } else {
          controller.strEmail = firstArg['email'] as String?;
          if (kDebugMode) {
            controller.verificationCode.text = firstArg['otpCode'] as String? ?? '';
          }
        }
      } else if (firstArg is AuthData) {
        controller.isResister = true;
        controller.otpCode = '${firstArg.otpCode}';
        controller.firstArg = {
          'email': firstArg.email,
          'mobile': firstArg.mobile,
          'name': firstArg.email?.split('@').first,
          'flag': firstArg.countryFlag,
          'iso': firstArg.iso,
          'channel': firstArg.channel,
        };
        controller.strEmail = firstArg.email;
      }
      controller.channelType.value = ChannelTypeExtension.fromString(controller.firstArg['channel'].toString());
    }
  }

  @override
  void onDispose() {
    debugPrint('onDispose');
    controller.onDisposeController();
  }
}
