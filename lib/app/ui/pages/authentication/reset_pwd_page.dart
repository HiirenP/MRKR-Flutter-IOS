import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';

import 'package:marker/app/controllers/auth/reset_pwd_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_auth_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ResetPwdPage extends GetItHook<ResetPwdController> {
  const ResetPwdPage({super.key});

  static Future<T?>? route<T>({dynamic argument}) {
    return Get.offNamed(AppRoutes.resetPassword, arguments: argument);
  }

  @override
  Widget build(BuildContext context) {
    final passObscure = true.obs;
    final confirmPassObscure = true.obs;
    return Form(
      key: controller.formKey,
      child: Scaffold(
        body: Padding(
          padding: const AppEdgeInsets.all16(),
          child: Column(
            children: [
              AppAuthAppbar(
                title: AppStrings.T.resetPassword,
                subTitle: AppStrings.T.yourNewPassword,
                iconName: ImageView(Assets.svg.resetPwd),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const Gap(24),
                    Obx(
                      () => TextInputField(
                          type: InputType.password,
                          context: context,
                          controller: controller.resetPassController,
                          hintLabel: AppStrings.T.newPasswordLabel,
                          obscureText: passObscure,
                          textInputAction: TextInputAction.done,
                          prefixIcon: ImageView(Assets.svg.lock),
                          validator: AppValidations.passwordValidation,
                          errorMaxLines: 3),
                    ),
                    const Gap(15),
                    Obx(
                      () => TextInputField(
                          type: InputType.password,
                          context: context,
                          controller: controller.confirmPassController,
                          hintLabel: AppStrings.T.confirmPasswordLabel,
                          obscureText: confirmPassObscure,
                          textInputAction: TextInputAction.done,
                          prefixIcon: ImageView(Assets.svg.lock),
                          validator: (value) =>
                              AppValidations.confirmPasswordValidation(value, controller.resetPassController.text),
                          errorMaxLines: 3),
                    ),
                    const Gap(60),
                    AppButton(
                      label: AppStrings.T.update,
                      onPressed: () {
                        controller.resetPassword(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.resetPassController = TextEditingController(text: kDebugMode ? 'Test#123' : '');
    controller.confirmPassController = TextEditingController(text: kDebugMode ? 'Test#123' : '');
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        controller.userId = Get.arguments as String;
      }
    }
  }

  @override
  void onDispose() {
    controller.userId = '';
    controller
      ..resetPassController.clear()
      ..confirmPassController.clear();
  }
}
