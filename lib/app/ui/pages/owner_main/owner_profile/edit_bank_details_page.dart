import 'package:gap/gap.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/bank_details_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class EditBankDetailsPage extends GetItHook<BankDetailsController> {
  const EditBankDetailsPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.editBankDetailsPage);
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
                  AppCustomAppbar(appTitle: AppStrings.T.editBankDetails, isPadding: true),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const Gap(20),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.fNameNameController,
                          hintLabel: AppStrings.T.enterFirstName,
                          context: context,
                          readOnly: true,
                          prefixIcon: ImageView(Assets.svg.profileCircle),
                          validator: AppValidations.firstNameValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          readOnly: true,
                          controller: controller.lNameNameController,
                          hintLabel: AppStrings.T.enterLastName,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.profileCircle),
                          validator: AppValidations.lastNameValidation,
                        ),
                        const Gap(16),
                        CustomPhoneNumber(
                          showCountryOnly: true,
                          readOnly: true,
                          controller: controller.mobileNumberController,
                          validator: AppValidations.phoneNumberValidation,
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
                        TextInputField(
                          type: InputType.text,
                          controller: controller.addressController,
                          hintLabel: AppStrings.T.enterAddress,
                          context: context,
                          prefixIcon: ImageView(
                            Assets.svg.location,
                            color: AppColors.greyIconColor,
                          ),
                          validator: AppValidations.addressValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.digits,
                          controller: controller.postalCodeController,
                          hintLabel: AppStrings.T.enterPostalCode,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.postalCode),
                          validator: AppValidations.postalValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.cityController,
                          hintLabel: AppStrings.T.enterCity,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.buliding),
                          validator: AppValidations.cityValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.stateController,
                          hintLabel: AppStrings.T.enterState,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.routing),
                          validator: AppValidations.stateValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.digits,
                          controller: controller.bankAccountNumberController,
                          hintLabel: AppStrings.T.enterBankAccountNumber,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.bank),
                          validator: AppValidations.bankAccountNumberValidation,
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.digits,
                          textInputAction: TextInputAction.done,
                          controller: controller.routingController,
                          hintLabel: AppStrings.T.enterRoutingNumber,
                          context: context,
                          prefixIcon: ImageView(
                            Assets.svg.hashtag,
                            color: context.colorScheme.secondaryFixedDim,
                          ),
                          validator: AppValidations.routingValidation,
                        ),
                        const Gap(16),
                      ],
                    ),
                  ),
                  const Gap(10),
                  AppButton(
                      label: AppStrings.T.save,
                      onPressed: () {
                        controller.updateBankDetailAPI();
                      }),
                  const Gap(10),
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
    final data = controller.getBankData.value;
    controller.fNameNameController = TextEditingController(text: data.fname);
    controller.lNameNameController = TextEditingController(text: data.lname);
    controller.mobileNumberController = TextEditingController(text: data.phone!=null?data.phone.toString():"");
    controller.emailController = TextEditingController(text: data.email);
    controller.addressController = TextEditingController(text: data.addressLine1);
    controller.postalCodeController = TextEditingController(text: data.pincode);
    controller.cityController = TextEditingController(text: data.city);
    controller.stateController = TextEditingController(text: data.state);
    controller.routingController = TextEditingController(text: data.routingNumber);
    controller.bankAccountNumberController = TextEditingController(text: data.accNumber);
  }

  @override
  void onDispose() {
    controller.fNameNameController.dispose();
    controller.lNameNameController.dispose();
    controller.mobileNumberController.dispose();
    controller.emailController.dispose();
    controller.addressController.dispose();
    controller.postalCodeController.dispose();
    controller.cityController.dispose();
    controller.stateController.dispose();
    controller.routingController.dispose();
  }
}
