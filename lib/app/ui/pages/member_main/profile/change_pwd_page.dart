import 'package:gap/gap.dart';

import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';

import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ChangePwdPage extends GetItHook<ProfileController> {
  const ChangePwdPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.changePwdPage);
  }

  @override
  Widget build(BuildContext context) {
    final oPassObscure = true.obs;
    final cPassObscure = true.obs;
    final nPssObscure = true.obs;

    return FocusScope(
      child: Form(
        key: controller.formChangePwdKey,
        child: Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const AppEdgeInsets.all16(),
                  child: AppCustomAppbar(
                    appTitle: AppStrings.T.changePassword,
                    isPadding: true,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const AppEdgeInsets.h16(),
                    children: [
                      Obx(
                        () => TextInputField(
                          type: InputType.password,
                          context: context,
                          controller: controller.passController,
                          hintLabel: AppStrings.T.enterCurrentPassword,
                          obscureText: oPassObscure,
                          prefixIcon: ImageView(Assets.svg.lock),
                          validator: AppValidations.passwordValidation,
                          errorMaxLines: 3,
                        ),
                      ),
                      const Gap(16),
                      Obx(
                        () => TextInputField(
                            type: InputType.password,
                            context: context,
                            controller: controller.newPassController,
                            hintLabel: AppStrings.T.enterNewPassword,
                            obscureText: cPassObscure,
                            prefixIcon: ImageView(Assets.svg.lock),
                            validator: AppValidations.passwordValidation,
                            errorMaxLines: 3),
                      ),
                      const Gap(16),
                      Obx(
                        () => TextInputField(
                          type: InputType.password,
                          context: context,
                          controller: controller.confirmPassController,
                          hintLabel: AppStrings.T.confirmNewPassword,
                          obscureText: nPssObscure,
                          textInputAction: TextInputAction.done,
                          validator: (val) =>
                              AppValidations.confirmPasswordValidation(val, controller.newPassController.text),
                          prefixIcon: ImageView(Assets.svg.lock),
                          errorMaxLines: 3,
                        ),
                      ),
                      const Gap(100),
                      AppButton(
                        label: AppStrings.T.update,
                        onPressed: () => controller.changePassword(context),
                      )
                    ],
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
    controller.newPassController = TextEditingController();
    controller.passController = TextEditingController();
    controller.confirmPassController = TextEditingController();
  }

  @override
  void onDispose() {
    controller.newPassController.dispose();
    controller.passController.dispose();
    controller.confirmPassController.dispose();
  }
}
