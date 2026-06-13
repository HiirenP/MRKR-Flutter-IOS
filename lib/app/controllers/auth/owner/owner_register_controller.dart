import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/ui/pages/authentication/owner/owner_register_manage.dart';
import 'package:marker/app/ui/pages/authentication/verify_code_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class OwnerRegisterController extends GetxController {
  OwnerRegisterController() {
    onInit();
  }

  final signupState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxString dialCode = '+91'.obs;
  RxString countryFlag = 'IN'.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    authModel = Rxn<AuthModel>();
  }

  Future<void> barOwnerRegisters() async {
    if (!formKey.currentState!.validate()) {
      return;
    } else if (!isChecked.value) {
      showError(AppStrings.T.youMustAccept);
      return;
    } else {
      signupState.value = LoadingState();
      final email = emailController.text.trim();
      await getIt<AuthService>()
          .sendOTP(
              email: email,
              name: email.split('@')[0],
              countryFlag: countryFlag.value,
              iso: dialCode.value,
              mobile: mobileNumberController.text.trim(),
              channel: ChannelType.email.backendValue)
          .handler(
        signupState,
        onSuccess: (value) async {
          if (value.isSuccess && value.statusCode == 200 && value.data != null) {
            final authData = value.data!;
            authData.email = email;
            authData.mobile = mobileNumberController.text.trim();
            authData.countryFlag = countryFlag.value;
            authData.iso = dialCode.value;
            authData.channel = ChannelType.email.backendValue;
            showSuccess(value.message);
            await VerifyCodePage.route(argument: authData)?.then(
              (value) {
                if (value != null && value is bool) {
                  final map = {
                    'email': email.trim(),
                    'iso': (authData.iso ?? '').trim(),
                    'countryFlag': countryFlag.value.trim(),
                    'mobile': mobileNumberController.text.trim(),
                  };
                  OwnerRegisterManage.route(map: map)?.then(
                    (value) {
                      if (value != null) {
                        if (value is bool) {
                          Get.back(result: value);
                        }
                      }
                    },
                  );
                }
              },
            );
          }
        },
        onFailed: (value) {
          showError(value.error.description);
        },
      );
    }
  }
}
