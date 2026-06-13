import 'package:gap/gap.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/contact_us_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ContactUsPage extends GetItHook<ContactUsController> {
  const ContactUsPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.contactUsPage);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        key: controller.formKeyContact,
        child: Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                children: [
                  AppCustomAppbar(appTitle: AppStrings.T.contactUs, isPadding: true),
                  const Gap(5),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const Gap(20),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.cFullNameController,
                          hintLabel: controller.cFullNameController.text.trim(),
                          context: context,
                          readOnly: true,
                          validator: AppValidations.nameValidation,
                          prefixIcon: ImageView(Assets.svg.profileCircle),
                          labelStyle: context.textTheme.labelMedium?.copyWith(color: AppColors.greyTextColor),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.email,
                          readOnly: true,
                          controller: controller.cEmailController,
                          hintLabel: AppStrings.eadd,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.email),
                          labelStyle: context.textTheme.labelMedium?.copyWith(color: AppColors.greyTextColor),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.subjectController,
                          hintLabel: AppStrings.T.enterSubject,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.subtitle),
                          validator: AppValidations.subjectValidation,
                        ),
                        const Gap(16),
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextInputField(
                              type: InputType.text,
                              controller: controller.cWriteMessageController,
                              hintLabel: AppStrings.T.writeMessage,
                              context: context,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 4,
                              maxLines: 4,
                              validator: AppValidations.messageValidation,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 60),
                                child: ImageView(Assets.svg.documentText),
                              )),
                        ),
                        const Gap(60),
                        AppButton(
                          label: AppStrings.T.submit,
                          onPressed: () {
                            controller.contactUs(context);
                          },
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
    controller.cWriteMessageController.dispose();
    controller.subjectController.dispose();
    controller.cEmailController.dispose();
    controller.cFullNameController.dispose();
  }
}
