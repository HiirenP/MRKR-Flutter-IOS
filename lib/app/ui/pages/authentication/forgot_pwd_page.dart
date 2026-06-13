import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/auth/forgot_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_auth_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_checkbox.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ForgotPasswordPage extends GetItHook<ForgotController> {
  const ForgotPasswordPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.forgotPassword);
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
            child: Column(
              children: [
                AppAuthAppbar(
                  title: AppStrings.T.forgotPassword,
                  subTitle: AppStrings.T.noWorries,
                  iconName: ImageView(Assets.svg.forgotLock),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const Gap(24),
                      TextInputField(
                        type: InputType.email,
                        textInputAction: TextInputAction.done,
                        controller: controller.forgotEmailController,
                        hintLabel: AppStrings.T.enterEmail,
                        context: context,
                        prefixIcon: ImageView(Assets.svg.email),
                        validator: AppValidations.emailValidation,
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
                              style:
                                  context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: context.colorScheme.secondaryFixedDim),
                            ),
                          ),
                        ],
                      ),*/
                      const Gap(150),
                      AppButton(
                          label: AppStrings.T.send,
                          onPressed: () {
                            controller.forgotPassword();
                          }),
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
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.forgotEmailController = TextEditingController(text: kDebugMode ? 'darshak@gmail.com' : '');
  }

  @override
  void onDispose() {
    controller.onDisposeAll();
  }
}
