import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/auth/login_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/authentication/forgot_pwd_page.dart';
import 'package:marker/app/ui/pages/authentication/selection_page.dart';
import 'package:marker/app/ui/widgets/custom_auth_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends GetItHook<LoginController> {
  const LoginPage({super.key});

  static Future<T?>? offAllRouteLogin<T>({UserType userType = UserType.member}) {
    AppConstant.userType = userType;
    return Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final passObscure = true.obs;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: FocusScope(
        child: Form(
          key: controller.formKey,
          child: Obx(() {
            return Scaffold(
              body: SafeArea(
                top: false,
                bottom: false,
                child: Padding(
                  padding: const AppEdgeInsets.all16(),
                  child: Column(
                    children: [
                      AppAuthAppbar(
                        title: AppStrings.T.logIn,
                        subTitle: AppStrings.T.pleaseLogin,
                        iconName: ImageView(Assets.svg.logout),
                        isBack: false,
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const Gap(24),
                            TextInputField(
                              type: InputType.email,
                              controller: controller.emailController,
                              hintLabel: AppStrings.T.enterEmail,
                              context: context,
                              prefixIcon: ImageView(Assets.svg.email),
                              validator: AppValidations.emailValidation,
                            ),
                            const Gap(16),
                            Obx(
                              () => TextInputField(
                                type: InputType.password,
                                context: context,
                                controller: controller.passController,
                                hintLabel: AppStrings.T.enterPassword,
                                obscureText: passObscure,
                                textInputAction: TextInputAction.done,
                                prefixIcon: ImageView(Assets.svg.lock),
                              ),
                            ),
                            const Gap(16),
                            if (controller.userType.value != UserType.manager)
                              GestureDetector(
                                onTap: ForgotPasswordPage.route,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: AppText(
                                    AppStrings.T.forgotPasswordRedirect,
                                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                  ),
                                ),
                              ),
                            const Gap(30),
                            AppButton(
                              label: AppStrings.T.logIn,
                              onPressed: () {
                                controller.login(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      if (controller.userType.value == UserType.manager)
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const SelectionScreen())!.then(
                              (value) {
                                if (value != null && value is Map) {
                                  controller.userType.value = value['user_type'] as UserType;
                                }
                              },
                            );
                          },
                          child: AppText(
                            AppStrings.T.profileType,
                            style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary),
                          ),
                        )
                      else
                        Padding(
                          padding: const AppEdgeInsets.h16(),
                          child: AppRichText(
                            spans: [
                              AppSpan(
                                text: AppStrings.T.registerRedirect,
                                style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.secondaryFixedDim),
                              ),
                              AppSpan(
                                text: AppStrings.T.register,
                                style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const SelectionScreen())!.then(
                                      (value) {
                                        if (value != null && value is Map) {
                                          controller.userType.value = value['user_type'] as UserType;
                                        }
                                      },
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      const CustomSizedBox()
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  Future<void> onInit() async {
    controller.emailController = TextEditingController(text: kDebugMode ? 'sabhayabhumit@gmail.com' : '');
    controller.passController = TextEditingController(text: kDebugMode ? 'Bhumit@123' : '');
    final settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      criticalAlert: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = getIt<SharedPreferences>().getDeviceToken;
      if (token == null || (token.isEmpty)) {
        await PushNotifications.getDeviceToken();
      }
    } else {
      debugPrint('User declined or has not accepted permission');
    }
    if (Platform.isIOS) {
      final savedToken = await getSavedToken();
      if (savedToken != null) {
        debugPrint('Saved voip token: $savedToken');
        getIt<SharedPreferences>().setVoipToken = savedToken;
      }
      await initVoip();
    }
  }

  @override
  void onDispose() {
    controller.emailController.clear();
    controller.passController.clear();
  }
}
