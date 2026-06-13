import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:marker/app/controllers/auth/owner/add_bank_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_phone_number.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/date_utils.dart' show DateUtil;
import 'package:marker/app/utils/core/country_picker_util.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class AddBankPage extends GetItHook<AddBankController> {
  const AddBankPage({super.key});

  static Future<T?>? route<T>() {
    return Get.offAllNamed(AppRoutes.addBank);
  }

  static Future<T?>? goRoute<T>(dynamic arguments) {
    return Get.toNamed(AppRoutes.addBank, arguments: arguments);
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
                  AppCustomAppbar(
                    appTitle: AppStrings.T.addBank,
                    isPadding: true,
                    onTap: () {
                      if(controller.showSkipButton){
                        Get.offAllNamed(AppRoutes.login);
                      }else{
                        Get.back();
                      }
                    },
                      isSecondaryIcon:controller.showSkipButton,
                    onSecondaryTap: controller.skipOnTap,
                    action: Text(
                      AppStrings.T.skip,
                      textAlign: TextAlign.center,

                    ),
                  ),
                  const Gap(2),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                       shrinkWrap: true,
                      children: [
                        const Gap(10),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.fNameController,
                          hintLabel: AppStrings.T.enterFirstName,
                          context: context,
                          validator: AppValidations.firstNameValidation,
                          prefixIcon: ImageView(Assets.svg.profileCircle),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.lNameController,
                          hintLabel: AppStrings.T.enterLastName,
                          context: context,
                          validator: AppValidations.lastNameValidation,
                          prefixIcon: ImageView(Assets.svg.profileCircle),
                        ),
                        const Gap(16),
                        CustomPhoneNumber(
                          showCountryOnly: true,
                          controller: controller.mobileNumberController,
                          validator: AppValidations.phoneNumberValidation,
                          onChanged: (country) {
                            controller.iso.value = country.dialCode;
                            controller.countryFlag.value = country.code;
                            controller.update();
                          },
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.email,
                          controller: controller.emailController,
                          hintLabel: AppStrings.T.enterEmail,
                          context: context,
                          validator: AppValidations.emailValidation,
                          prefixIcon: ImageView(Assets.svg.email),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.dobController,
                          hintLabel: AppStrings.T.enterDOB,
                          context: context,
                          validator: AppValidations.dobValidation,
                          prefixIcon: ImageView(Assets.svg.calendar),
                          readOnly: true,
                          onTap: () {
                            DateUtil().selectDate(
                              context,
                              DateTime(2010),
                              selectedDate: (p0) {
                                final dateFormat = DateFormat(DateUtil.instance.MMddyyyy);
                                final fudgeThis = dateFormat.format(p0);
                                controller.dobController.text = fudgeThis;
                                controller.bDay.value = DateFormat('dd').format(p0);
                                controller.bMonth.value = DateFormat('MM').format(p0);
                                controller.bYear.value = DateFormat('yyyy').format(p0);
                              },
                            );
                          },
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.phoneNumber,
                          controller: controller.identityNumberController,
                          hintLabel: AppStrings.T.enterIdentityNumber,
                          context: context,
                          validator: AppValidations.identifyValidation,
                          prefixIcon: ImageView(Assets.svg.card),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.addressController,
                          hintLabel: AppStrings.T.enterAddress,
                          context: context,
                          validator: AppValidations.addressValidation,
                          prefixIcon: ImageView(
                            Assets.svg.location,
                            color: context.theme.colorScheme.secondaryContainer,
                          ),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.digits,
                          controller: controller.postalCodeController,
                          hintLabel: AppStrings.T.enterPostalCode,
                          context: context,
                          validator: AppValidations.postalValidation,
                          prefixIcon: ImageView(Assets.svg.postalCode),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.cityController,
                          hintLabel: AppStrings.T.enterCity,
                          context: context,
                          validator: AppValidations.cityBankValidation,
                          prefixIcon: ImageView(Assets.svg.buliding),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.stateController,
                          hintLabel: AppStrings.T.enterState,
                          context: context,
                          validator: AppValidations.stateBankValidation,
                          prefixIcon: ImageView(Assets.svg.routing),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.countryController,
                          hintLabel: AppStrings.T.chooseCountry,
                          context: context,
                          // validator: AppValidations.countryValidation,
                          prefixIcon: ImageView(
                            Assets.svg.global,
                            color: context.theme.colorScheme.secondaryContainer,
                          ),
                          suffixIcon: ImageView(
                            Assets.svg.arrowDown,
                            color: context.theme.colorScheme.secondaryContainer,
                          ),
                          readOnly: true,
                          onTap: () => CountryPickerUtil().countryPick(
                            context: context,
                            selectedItem: (p0) {
                              controller.countryController.text = p0.name;
                            },
                          ),
                        ),
                     /*   const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.externalAccountController,
                          hintLabel: AppStrings.T.selectExternalAccount,
                          context: context,
                          // validator: AppValidations.externalAccountValidation,
                          prefixIcon: ImageView(
                            Assets.svg.global,
                            color: context.theme.colorScheme.secondaryContainer,
                          ),
                          suffixIcon: ImageView(
                            Assets.svg.arrowDown,
                            color: context.theme.colorScheme.secondaryContainer,
                          ),
                          readOnly: true,
                          onTap: () => CountryPickerUtil().countryPick(
                            context: context,
                            selectedItem: (p0) {
                              controller.externalAccountController.text = p0.name;
                            },
                          ),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.currencyController,
                          // validator: AppValidations.currencyAccountValidation,
                          hintLabel: AppStrings.T.enterExternalAccountCurrency,
                          context: context,
                          prefixIcon: ImageView(Assets.svg.coin),
                        ),*/
                        const Gap(16),
                        TextInputField(
                          type: InputType.digits,
                          controller: controller.bankAccountNumberController,
                          hintLabel: AppStrings.T.enterBankAccountNumber,
                          context: context,
                          validator: AppValidations.bankAccountNumberValidation,
                          prefixIcon: ImageView(Assets.svg.bank),
                        ),
                        const Gap(16),
                        TextInputField(
                          type: InputType.digits,
                          controller: controller.routingController,
                          hintLabel: AppStrings.T.enterRoutingNumber,
                          context: context,
                          validator: AppValidations.routingValidation,
                          prefixIcon: ImageView(
                            Assets.svg.hashtag,
                            color: context.theme.colorScheme.secondaryContainer,
                          ),
                        ),
                        const Gap(16),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              profilePictureBottomSheet(
                                  title: AppStrings.T.uploadBankFront,
                                  subTitle: AppStrings.T.chooseBankFront,
                                  selectedPath: (String path) {
                                    controller.frontImage.value = path;
                                  });
                            },
                            child: Container(
                              width: Get.width,
                              height: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                              child: controller.frontImage.value.isNotEmpty
                                  ? ImageView(
                                      controller.frontImage.value,
                                      inner: ImageSize(height: 130, width: Get.width),
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ImageView(
                                          Assets.svg.export,
                                          color: context.theme.colorScheme.secondaryContainer,
                                          inner: ImageSize(width: 25, height: 25),
                                        ),
                                        const Gap(15),
                                        CenterText(
                                          AppStrings.T.uploadFrontImage,
                                          style: context.textTheme.bodyMedium?.copyWith(
                                            color: context.theme.colorScheme.secondaryContainer,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              profilePictureBottomSheet(
                                  title: AppStrings.T.uploadBankBack,
                                  subTitle: AppStrings.T.chooseBankBack,
                                  selectedPath: (String path) {
                                    controller.backImage.value = path;
                                  });
                            },
                            child: Container(
                              width: Get.width,
                              height: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                              child: controller.backImage.value.isNotEmpty
                                  ? ImageView(
                                      controller.backImage.value,
                                      inner: ImageSize(height: 130, width: Get.width),
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ImageView(
                                          Assets.svg.export,
                                          color: context.theme.colorScheme.secondaryContainer,
                                          inner: ImageSize(width: 25, height: 25),
                                        ),
                                        const Gap(15),
                                        CenterText(
                                          AppStrings.T.uploadBackImage,
                                          style: context.textTheme.bodyMedium?.copyWith(
                                            color: context.theme.colorScheme.secondaryContainer,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(10),
                  AppButton(
                      label: AppStrings.T.add,
                      onPressed: () {
                        controller.addBankDetails();
                      }),
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
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.onInitUpdate();

  }

  @override
  void onDispose() {
    controller.disposeAll();

  }


}
