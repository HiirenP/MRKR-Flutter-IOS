import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/ui/pages/authentication/current_location_map_screen.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_bank_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/owner_register_manage.dart';
import 'package:marker/app/ui/pages/owner_main/owner_main_page/owner_main_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class LoginController extends GetxController {
  LoginController() {
    onInit();
  }

  final loginState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  TextEditingController emailController = TextEditingController(text: kDebugMode ? 'johndoe@gmail.com' : '');
  TextEditingController passController = TextEditingController(text: kDebugMode ? 'Test@123' : '');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<UserType> userType = UserType.member.obs;

  @override
  void onInit() {
    super.onInit();
    authModel = Rxn<AuthModel>();
  }

  Future<void> login(BuildContext context) async {
    debugPrint('getDeviceToken------------------>${getIt<SharedPreferences>().getDeviceToken}');
    final data = getIt<SharedPreferences>().getDeviceToken;
    if (data == null || data.isEmpty) {
      await PushNotifications.getDeviceToken();
    }
    if (!formKey.currentState!.validate()) {
      return;
    }
    loginState.value = LoadingState();
    String? voipToken;
    if (Platform.isIOS) {
      voipToken = await getSavedToken();
    }
    await getIt<AuthService>()
        .login(
      emailController.text,
      passController.text.trim().convertMd5,
      deviceType: Platform.operatingSystem == 'android' ? 'android' : 'iOS',
      deviceToken: getIt<SharedPreferences>().getDeviceToken ?? 'no_token_found',
      voipToken: getIt<SharedPreferences>().getVOIPToken ?? voipToken,
    )
        .handler(
      loginState,
      onSuccess: (value) async {
        if (value.isSuccess && value.statusCode == 200 && value.data != null) {
          getIt<SharedPreferences>().setToken = value.data?.token ?? '';
          getIt<SharedPreferences>().setUserId = value.data?.id ?? '';
          getIt<SharedPreferences>().setBarId = value.data?.isBarCreated ?? '';
          getIt<SharedPreferences>().setUserData = value.data;
          getIt<SharedPreferences>().setTapToPayEnabled = value.data?.tapToPayEnabled ?? false;
          AppConstant.userType = UserTypeExtension.fromString(value.data?.userType ?? 'member');

          if (AppConstant.userType == UserType.member) {
            await CurrentLocationMapScreen.route();
          } else {
            if ((value.data?.isBarCreated == null || value.data!.isBarCreated!.isEmpty) && AppConstant.userType == UserType.owner) {
              await OwnerRegisterManage.route(map: 1);
            } /*else if ((value.data?.isBankAdded == null || value.data!.isBankAdded!.isEmpty) && AppConstant.userType == UserType.owner) {
              await AddBankPage.route();
            } */else {
              await OwnerMainPage.route();
            }
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
