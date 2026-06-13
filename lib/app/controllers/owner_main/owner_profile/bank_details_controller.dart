import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bank_details_model/bank_details_model.dart';
import 'package:marker/app/data/services/payment_service/payment_service.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';

@i.lazySingleton
@i.injectable
class BankDetailsController extends GetxController {
  BankDetailsController() {
    onInit();
  }

  RxList<CommonModel> banDetailsList = <CommonModel>[].obs;
  final loginState = ApiState.initial().obs;
  RxString dialCode = '+91'.obs;
  bool isBack = false;
  Rx<BankDetailsData> getBankData = BankDetailsData().obs;
  TextEditingController fNameNameController = TextEditingController();
  TextEditingController lNameNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController routingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addBankDetailsList() {
    final data = getBankData.value;
    final fName = '${data.fname} ${data.lname}';
    final birth = '${data.bmonth}-${data.bdate}-${data.byear}';
    banDetailsList.value = [];
    banDetailsList.addAll([
      CommonModel(
          icon: Assets.svg.profileCircle,
          title: AppStrings.T.fullName,
          subTitle: fName),
      CommonModel(
          icon: Assets.svg.callCalling,
          title: AppStrings.T.mobileNumber,
          subTitle: data.phone.toString()),
      CommonModel(
          icon: Assets.svg.email,
          title: AppStrings.T.email,
          subTitle: data.email),
      CommonModel(
          icon: Assets.svg.calendar,
          title: AppStrings.T.dateOfBirth,
          subTitle: birth),
      CommonModel(
          icon: Assets.svg.card,
          title: AppStrings.T.identityNumber,
          subTitle: data.identityNumber),
      CommonModel(
          icon: Assets.svg.location,
          title: AppStrings.T.address,
          subTitle: data.addressLine1),
      CommonModel(
          icon: Assets.svg.postalCode,
          title: AppStrings.T.postalCode,
          subTitle: data.pincode),
      CommonModel(
          icon: Assets.svg.buliding,
          title: AppStrings.T.city,
          subTitle: data.city),
      CommonModel(
          icon: Assets.svg.routing,
          title: AppStrings.T.state,
          subTitle: data.routingNumber),
      CommonModel(
          icon: Assets.svg.bank,
          title: AppStrings.T.bankAccountNumber,
          subTitle: data.accNumber),
      CommonModel(
          icon: Assets.svg.hashtag,
          title: AppStrings.T.routingNumber,
          subTitle: data.routingNumber),
    ]);
  }

  Future<void> getBankDetails() async {
    loginState.value = LoadingState();
    await getIt<PaymentService>().getBankDetail().handler(
      loginState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          getBankData.value = value.data!;
          addBankDetailsList();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  // Update Bank Detail API call
  Future<void> updateBankDetailAPI() async {
    loginState.value = LoadingState();
    if (!formKey.currentState!.validate()) {
      return;
    }
    await getIt<PaymentService>()
        .updateBankDetail(
      address: addressController.text.trim(),
      email: emailController.text.trim(),
      phone: mobileNumberController.text.trim(),
      countryFlag: addressController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      bankAccountNumber: bankAccountNumberController.text.trim(),
      pincode: postalCodeController.text.trim(),
      routing_number: routingController.text.trim(),
    )
        .handler(
      loginState,
      onSuccess: (value) async {
        if (value.statusCode == 200 && value.data != null) {
          getBankData.value = value.data!;
          Get.back(result: true);
          showSuccess(AppStrings.T.bankUpdatedSuccess);
          addBankDetailsList();
        } else {
          showError(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
