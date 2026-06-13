import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' show ExtensionBottomSheet, Get, GetNavigation, GetxController, Rx, RxT, Rxn;
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/ui/pages/authentication/current_location_map_screen.dart';
import 'package:marker/app/ui/pages/authentication/reset_pwd_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class VerificationController extends GetxController {
  VerificationController() {
    onInit();
  }

  String? strEmail;

  bool isResister = false;
  bool isMemberResister = false;
  Rx<ChannelType> channelType = ChannelType.email.obs;

  final loginState = ApiState.initial().obs;
  final otpSendState = ApiState.initial().obs;
  final memberRegisterState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  TextEditingController verificationCode = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, dynamic> firstArg = {};
  String otpCode = '';

  Future<void> verifyForgotPassOTP() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    loginState.value = LoadingState();
    await getIt<AuthService>().verifyForgotPassOTP(strEmail ?? '', verificationCode.text, channelType.value.backendValue).handler(
      loginState,
      onSuccess: (value) {
        if (value.isSuccess && value.statusCode == 200) {
          showSuccess(value.message);
          ResetPwdPage.route(argument: value.data?.userId)?.then(
            (value) {
              if (value != null) {
                if (value is bool) {
                  if (value) Get.back(result: value);
                }
              }
            },
          );
        } else {
          showError(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> verifyRegisterOTP(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    loginState.value = LoadingState();

    await getIt<AuthService>()
        .verifyCode(strEmail ?? '', verificationCode.text.trim(), channelType.value.backendValue, (firstArg['mobile'] ?? '').toString(),(firstArg['iso'] ?? '').toString())
        .handler(
      loginState,
      onSuccess: (value) {
        if (value.isSuccess && value.statusCode == 200) {
          Get.back(result: true);
        } else {
          showError(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> sendOTPForRegister() async {
    otpSendState.value = LoadingState();
    await getIt<AuthService>()
        .sendOTP(
      email: (firstArg['email'] ?? '').toString(),
      name: (firstArg['name'] ?? '').toString(),
      countryFlag: (firstArg['flag'] ?? '').toString(),
      iso: (firstArg['iso'] ?? '').toString(),
      mobile: (firstArg['mobile'] ?? '').toString(),
      channel: channelType.value.backendValue,
    )
        .handler(
      otpSendState,
      onSuccess: (value) async {
        if (value.isSuccess && value.statusCode == 200) {
          final message = value.message;
          if (message.isNotEmpty) {
            showSuccess(message);
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

  Future<void> memberRegister(Map<String, dynamic> firstArg) async {
    debugPrint('firstArg-->$firstArg');
    final data = getIt<SharedPreferences>().getDeviceToken;
    if (data == null || data.isEmpty) {
      await PushNotifications.getDeviceToken();
    }
    if (!formKey.currentState!.validate()) {
      return;
    }
    memberRegisterState.value = LoadingState();
    String? voipToken;
    if (Platform.isIOS) {
      voipToken = await getSavedToken();
    }
    final gender = firstArg['gender'] as String?;
    await getIt<AuthService>()
        .memberRegister(
            name: (firstArg['name'] ?? '').toString(),
            iso: (firstArg['iso'] ?? '').toString(),
            countryFlag: (firstArg['flag'] ?? '').toString(),
            mobile: (firstArg['mobile'] ?? '').toString(),
            email: (firstArg['email'] ?? '').toString(),
            gender: gender,
            address: (firstArg['address'] ?? '').toString(),
            country: (firstArg['country'] ?? '').toString(),
            pass: (firstArg['pass'] ?? '').toString(),
            userType: (firstArg['userType'] ?? '').toString(),
            deviceType: (firstArg['deviceType'] ?? '').toString(),
            deviceToken: getIt<SharedPreferences>().getDeviceToken ?? '',
            profile: (firstArg['profile'] ?? '').toString().isNotEmpty ? File((firstArg['profile'] ?? '').toString()) : null,
            otp: verificationCode.text.trim(),
            voipToken: getIt<SharedPreferences>().getVOIPToken ?? voipToken,
            channel: channelType.value.backendValue)
        .handler(
      memberRegisterState,
      isLoading: true,
      onSuccess: (value) {
        debugPrint('value-onSuccess-->${jsonEncode(value)}');
        if (value.statusCode == 200 && value.data != null && value.isSuccess) {
          authModel.value = value;
          getIt<SharedPreferences>().setToken = value.data?.token ?? '';
          getIt<SharedPreferences>().setUserData = value.data;
          getIt<SharedPreferences>().setUserId = value.data?.id ?? '';
          successBottomSheet();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> successBottomSheet() async {
    return Get.bottomSheet(
      isDismissible: false,
      enableDrag: false,
      AppBottomSheet(
        iconName: ImageView(Assets.svg.allDone),
        title: AppStrings.T.allDone,
        subTitle: AppStrings.T.yourProfileCreated,
        canPOP: false,
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: () {
          Get.back();
          CurrentLocationMapScreen.route(isAllClear: true);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void onDisposeController() {
    isMemberResister = false;
    firstArg = {};
    loginState.value = ApiState.initial();
    memberRegisterState.value = ApiState.initial();
    otpSendState.value = ApiState.initial();
    try {
      verificationCode.text = '';
    } catch (e) {
      debugPrint('Error Verify Controller-->$e');
    }
  }

  void resendOtp() {
    debugPrint('isMemberResister-$isMemberResister');
    debugPrint('isResister-$isResister');
    if (isMemberResister || isResister) {
      sendOTPForRegister();
    } else {
      forgotPassword();
    }
  }

  Future<void> forgotPassword() async {
    loginState.value = LoadingState();
    await getIt<AuthService>().forgotPassword((firstArg['email'] ?? '').toString(), channelType.value.backendValue).handler(
      loginState,
      onSuccess: (value) {
        if (value.isSuccess && value.statusCode == 200 && value.data != null) {
          showSuccess(value.message);
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
