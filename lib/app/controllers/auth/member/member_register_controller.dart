import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/ui/pages/authentication/verify_code_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class MemberRegisterController extends GetxController {
  MemberRegisterController() {
    onInit();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  List<String> genderList = <String>[].obs;
  RxString selectedGender = ''.obs;
  RxBool isChecked = false.obs;

  RxBool isGenderSelected = true.obs;
  RxString dialCode = '+376'.obs;
  RxString countryFlag = 'AD'.obs;
  RxString imagePath = ''.obs;

  final loginState = ApiState.initial().obs;
  final otpSendState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();

  @override
  void onInit() {
    super.onInit();
    authModel = Rxn<AuthModel>();
  }

  bool isGenderHint(String gender) {
    return gender == AppStrings.T.chooseGender;
  }

  Future<void> memberRegisters(BuildContext context) async {
    /*if (imagePath.value.isEmpty) {
      showError(AppStrings.T.pleaseSelectProfileImage);
      return;
    }*/
    if (!formKey.currentState!.validate()) {
      if (selectedGender.value.isEmpty) {
        isGenderSelected.value = false;
      } else {
        isGenderSelected.value = true;
      }
      return;
    } else if (!isChecked.value) {
      showError(AppStrings.T.youMustAccept);
      return;
    }
    final profile = imagePath.value.trim().isNotEmpty ? imagePath.value : null;

    final map = {
      'name': fullNameController.text.trim(),
      'iso': dialCode.value,
      'flag': countryFlag.value,
      'mobile': mobileNumberController.text.trim(),
      'email': emailController.text.trim(),
      'gender': selectedGender.value.isEmpty ? null : selectedGender.value,
      'address': addressController.text.trim(),
      'country': countryController.text,
      'pass': passController.text.trim().convertMd5,
      'userType': 'member',
      'profile': profile,
      'deviceType': Platform.operatingSystem == 'android' ? 'android' : 'iOS',
      'channel': ChannelType.email.backendValue,
    };
    await sendOTPForRegister(map);
  }

  Future<void> sendOTPForRegister(Map<String, dynamic> firstArg) async {
    otpSendState.value = LoadingState();
    await getIt<AuthService>()
        .sendOTP(
      email: (firstArg['email'] ?? '').toString(),
      name: (firstArg['name'] ?? '').toString(),
      countryFlag: (firstArg['flag'] ?? '').toString(),
      iso: (firstArg['iso'] ?? '').toString(),
      mobile: (firstArg['mobile'] ?? '').toString(),
      channel: (firstArg['channel'] ?? '').toString(),
    )
        .handler(
      otpSendState,
      onSuccess: (value) async {
        if (value.isSuccess && value.statusCode == 200) {
          final message = value.message;
          if (message.isNotEmpty) {
            showSuccess(message);
          }
          if (value.data != null) {
            await VerifyCodePage.route(argument: firstArg);
          }
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
