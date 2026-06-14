import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  AppConfig._();
  // static const String socketUrl = 'https://3dtvfp1f-3002.uks1.devtunnels.ms';
  /// Physical phone on same WiFi: your PC LAN IP (check `ipconfig`).
  /// Android emulator: run with `--dart-define=LOCAL_API_HOST=10.0.2.2`
  static const String localApiHost = String.fromEnvironment(
    'LOCAL_API_HOST',
    defaultValue: '192.168.1.5',
  );

  /// Override with `--dart-define=API_ENV=dev|staging|prod`.
  /// When omitted: **debug** (simulator / `flutter run`) → dev API; **release** → prod.
  static const String apiEnv = String.fromEnvironment('API_ENV', defaultValue: '');

  static String get resolvedApiEnv {
    if (apiEnv.isNotEmpty) return apiEnv;
    if (kDebugMode) return 'dev';
    return 'prod';
  }

  /// Retrofit `@RestApi` requires a compile-time constant; runtime URL is [baseUrl].
  static const String restApiBaseUrl = '';

  static const String _prodApiOrigin = 'https://api.yourmarkerapp.com:3001';
  static const String _devApiOrigin = 'https://dev.api.yourmarkerapp.com:3002';
  static const String _localApiOrigin = 'http://$localApiHost:3001';

  static String get _releaseApiOrigin => resolvedApiEnv == 'dev' || resolvedApiEnv == 'staging'
      ? _devApiOrigin
      : _prodApiOrigin;

  /// Debug + API_ENV=prod (or unset prod in release) → local PC when not on dev/staging.
  static String get socketUrl => resolvedApiEnv == 'dev' || resolvedApiEnv == 'staging'
      ? _devApiOrigin
      : (kDebugMode ? _localApiOrigin : _releaseApiOrigin);

  static String get termsConditions => resolvedApiEnv == 'dev' || resolvedApiEnv == 'staging'
      ? '$_devApiOrigin/public/T&C.html'
      : (kDebugMode ? '$_localApiOrigin/public/T&C.html' : '$_prodApiOrigin/public/T&C.html');
  static const String tapToPayTerms =
      'https://www.apple.com/legal/internet-services/business-services/tap-to-pay-on-iphone/terms-en.html';
  static String get aboutUs => resolvedApiEnv == 'dev' || resolvedApiEnv == 'staging'
      ? '$_devApiOrigin/public/aboutUs.html'
      : (kDebugMode ? '$_localApiOrigin/public/aboutUs.html' : '$_prodApiOrigin/public/aboutUs.html');

  static String get privacyPolicy => resolvedApiEnv == 'dev' || resolvedApiEnv == 'staging'
      ? '$_devApiOrigin/public/privacyPolicy.html'
      : (kDebugMode ? '$_localApiOrigin/public/privacyPolicy.html' : '$_prodApiOrigin/public/privacyPolicy.html');
  static String get baseUrl => '$socketUrl/api/';
  static const int timeoutDuration = 30000;
  static const bool enableLogging = true; // Optional: Flag to enable/disable logging for debugging

  static const int forceUpdateCode = 426;

  static String currentBuildVersion = '';
  static String deviceName = '';
  static String deviceType = switch (Platform.operatingSystem) {
    'android' => 'android',
    'ios' => 'iOS',
    _ => 'Other',
  };

  static Future<void> getCurrentVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      currentBuildVersion = packageInfo.buildNumber;
    } else {
      currentBuildVersion = packageInfo.version;
    }
  }

  static Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceName = iosInfo.utsname.machine;
      } else {
        deviceName = 'Unknown Device';
      }
    }
  }

}

//adb shell am start -a android.intent.action.VIEW -d "https://dev.api.yourmarkerapp.com:3002/public/share_app.html?drinkId=684930a39391a7a9b0a35d22"
class EndPoints {
  EndPoints._();

  static const refreshToken = '/auth/refreshToken';
  static const userLogin = '/auth/login';
  static const userSignUp = '/auth/signUp';
  static const userForgotPassword = '/auth/forgotPassword';
  static const userVerifyOTP = '/auth/verifyOTP';
  static const userUpdatePassword = '/auth/updatePassword';
  static const userSendOTP = '/auth/sendOtp';
  static const verifyForgotPassOTP = '/auth/verifyForgotPassOTP';
  static const updatePassword = '/auth/updatePassword';
  static const changePassword = '/user/changePassword';
  static const logOut = '/user/logOut';
  static const deleteAccount = '/user/deleteAccount';
  static const contactUs = '/user/contactUs';
  static const userReports = '/user-reports/create';
  static const blockUser = '/blocked-users/block';
  static const unBlockUser = '/blocked-users/unblock';
  static const blockedUsers = '/blocked-users/blocked-users';

  static const friendsList = '/friends/list';
  static const sendRequest = '/friends/sendRequest';
  static const respondRequest = '/friends/respondRequest';
  static const generateToken = '/friends/generata_token';
  static const searchUsers = '/friends/searchUsers';
  static const updateProfile = '/user/updateProfile';
  static const barProfileCreate = '/bar/create';
  static const addDrinks = '/bar/drinks/add';
  static const addBankDetail = '/payment/addBankDetail';
  static const getBankDetail = '/payment/getBankDetail';
  static const updateBankDetail = '/payment/updateBankDetail';
  static const transactionHistory = '/user/transactionHistory';
  static const memberPlatformFeePreview = '/payment/member-platform-fees/preview';
  static const wallet = '/payment/wallet';
  static const withdrawalMoney = '/payment/withdrawalMoney';
  static const withdrawalHistory = '/payment/withdrawalHistory';
  static const notifications = '/user/notifications';
  static const deleteNotification = '/user/notifications/delete';
  static const profile = '/user/profile';
  static const markerBarList = '/marker/bar/list';
  static const nearByList = '/bar/list';
  static const markerList = '/marker/list';
  static const searchDrinks = '/bar/drinks/search';
  static const owner = '/bar/owner';
  static const barHome = '/user/home';
  static const redeem = '/marker/redeem';
  static const verify = '/marker/verify';
  static const markerApprovalRequest = '/marker/approval/request';
  static const markerApprovalRespond = '/marker/approval/respond';
  static const markerUpdateDrink = '/marker/updateDrink';
  static const barReviewSubmit = '/bar/review/submit';
  static const barReviewMy = '/bar/review/my';
  static const reviewList = '/bar/review/list';
  static const listByBar = '/bar/drinks/list-by-bar';
  static const drinkCategoriesList = '/bar/drink-categories/list';
  static const createPaymentLink = '/payment/createPaymentLink';
  static const terminalToken = '/payment/terminalToken';
  static const barAvailability = '/bar/barAvailability/create';

  static details(String barId) => '/bar/$barId/details';
}
