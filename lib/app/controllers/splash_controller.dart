import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/ui/pages/authentication/login_page.dart';
import 'package:marker/app/ui/pages/member_main/main_page/main_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_main_page/owner_main_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/service/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class SplashController extends GetxController {
  SplashController() {
    onInit();
  }

  LocationService locationService = LocationService();
  int selectedIndex = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> navigateNextScreen() async {
    final userData = getIt<SharedPreferences>().getUserData;

    await Future.delayed(const Duration(seconds: 3));

    final token = getIt<SharedPreferences>().getToken;
    if (userData == null || token == null || token.isEmpty) {
      if (userData != null || (token != null && token.isNotEmpty)) {
        await getIt<SharedPreferences>().clearData();
      }
      await LoginPage.offAllRouteLogin();
    } else {
      AppConstant.userType = UserTypeExtension.fromString(userData.userType);
      if (AppConstant.userType == UserType.member) {
        getIt<SharedPreferences>().removeTerminal();
        final started = await locationService.startListening();
        if (!started) {
          debugPrint('Location service could not start.');
          await MainPage.route(from: 'Splash');
        } else {
          await MainPage.route(from: 'Splash');
        }
      } else {
        if ((userData.isBarCreated == null || userData.isBarCreated!.isEmpty) && AppConstant.userType == UserType.owner) {
          await getIt<SharedPreferences>().clearData();
          await LoginPage.offAllRouteLogin();
          // await OwnerRegisterManage.route(isAllClear: true);
        } /*else if ((userData.isBankAdded == null || userData.isBankAdded!.isEmpty) && AppConstant.userType == UserType.owner) {
          await getIt<SharedPreferences>().clearData();
          await LoginPage.offAllRouteLogin();
          // await AddBankPage.route();
        } */else {
          await OwnerMainPage.route();
        }
      }
    }
  }

  Future<void> onItemTapped(int index) async {
    selectedIndex = index;
  }
}
