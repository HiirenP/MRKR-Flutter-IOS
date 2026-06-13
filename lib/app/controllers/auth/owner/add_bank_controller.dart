import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/services/payment_service/payment_service.dart';
import 'package:marker/app/ui/pages/owner_main/owner_main_page/owner_main_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class AddBankController extends GetxController {
  AddBankController() {
    onInit();
  }


  bool showSkipButton=true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString frontImage = ''.obs;
  RxString backImage = ''.obs;
  RxString bDay = ''.obs;
  RxString bMonth = ''.obs;
  RxString bYear = ''.obs;
  RxString countryFlag = 'US'.obs;
  RxString iso = '+1'.obs;
  final loginState = ApiState.initial().obs;
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController routingController = TextEditingController();


  skipOnTap(){
    final userData = getIt<SharedPreferences>().getUserData;
    if (userData != null) {
      getIt<SharedPreferences>().setUserData = userData;
      AppConstant.userType = UserTypeExtension.fromString(userData.userType);
    }
    OwnerMainPage.route();
  }

  Future<void> addBankDetails() async {
    if (!formKey.currentState!.validate()) {
      return;
    } else if (frontImage.value.isEmpty) {
      showError(AppStrings.T.pleaseSelectBankFront);
      return;
    } else if (backImage.value.isEmpty) {
      showError(AppStrings.T.pleaseSelectBankBack);
      return;
    }
    final frontImage1 = frontImage.value.trim().isNotEmpty ? File(frontImage.value) : null;
    final backImage1 = backImage.value.trim().isNotEmpty ? File(backImage.value) : null;

    await getIt<PaymentService>()
        .addBankDetail(
      email: emailController.text.trim(),
      iso: iso.value,
      countryFlag: countryFlag.value,
      phone: mobileNumberController.text.trim(),
      identityNumber: identityNumberController.text.trim(),
      city: cityController.text.trim(),
      address: addressController.text.trim(),
      state: stateController.text.trim(),
      bankAccountNumber: bankAccountNumberController.text.trim(),
      bdate: bDay.value,
      bmonth: bMonth.value,
      byear: bYear.value,
      pincode: postalCodeController.text.trim(),
      routing_number: routingController.text.trim(),
      fname: fNameController.text.trim(),
      lname: lNameController.text.trim(),
      frontImage: frontImage1,
      backImage: backImage1,
      country: countryController.text.trim(),
    )
        .handler(
      loginState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.isSuccess && value.data != null) {
          final userData = getIt<SharedPreferences>().getUserData;
          if (userData != null) {
            userData.isBankAdded = value.data?.sId ?? '';
            getIt<SharedPreferences>().setUserData = userData;
            AppConstant.userType = UserTypeExtension.fromString(userData.userType);
          }
          successBottomSheet();
        } else {
          showError(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> successBottomSheet() async {
    final context = Get.context!;
    return Get.bottomSheet(
      AppBottomSheet(
         canPOP: false,
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(
            Assets.svg.bank,
            color: context.theme.colorScheme.primary,
          ),
        ),
        title: AppStrings.T.successful,
        subTitle: AppStrings.T.yourPaymentBankAddedSuccess,
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: (){
          if(showSkipButton){
            OwnerMainPage.route();
          }else{
            Get.back();
            Get.back(result: true);
          }
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void onInitUpdate() {
    fNameController = TextEditingController();
    mobileNumberController = TextEditingController();
    emailController = TextEditingController();
    dobController = TextEditingController();
    identityNumberController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    routingController = TextEditingController();
    if(Get.arguments!=null){
      showSkipButton=false;
    }
  }

  void disposeAll() {
    fNameController.dispose();
    lNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    dobController.dispose();
    identityNumberController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    routingController.dispose();
  }
}
