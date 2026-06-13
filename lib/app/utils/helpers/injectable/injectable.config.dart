// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i497;

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:marker/app/controllers/auth/current_location_map_controller.dart'
    as _i359;
import 'package:marker/app/controllers/auth/forgot_controller.dart' as _i388;
import 'package:marker/app/controllers/auth/login_controller.dart' as _i1027;
import 'package:marker/app/controllers/auth/member/member_register_controller.dart'
    as _i946;
import 'package:marker/app/controllers/auth/owner/add_bank_controller.dart'
    as _i513;
import 'package:marker/app/controllers/auth/owner/owner_register_controller.dart'
    as _i949;
import 'package:marker/app/controllers/auth/owner/owner_register_profile_controller.dart'
    as _i975;
import 'package:marker/app/controllers/auth/reset_pwd_controller.dart' as _i517;
import 'package:marker/app/controllers/auth/verification_controller.dart'
    as _i678;
import 'package:marker/app/controllers/basehome_controller.dart' as _i597;
import 'package:marker/app/controllers/member_main/friend/friend_controller.dart'
    as _i586;
import 'package:marker/app/controllers/member_main/friend/friend_list_controller.dart'
    as _i387;
import 'package:marker/app/controllers/member_main/home/drink_details_controller.dart'
    as _i666;
import 'package:marker/app/controllers/member_main/home/drink_review_controller.dart'
    as _i222;
import 'package:marker/app/controllers/member_main/home/home_controller.dart'
    as _i869;
import 'package:marker/app/controllers/member_main/home/location_marker_controller.dart'
    as _i147;
import 'package:marker/app/controllers/member_main/home/map_near_by_bar_controller.dart'
    as _i501;
import 'package:marker/app/controllers/member_main/home/near_by_controller.dart'
    as _i267;
import 'package:marker/app/controllers/member_main/home/near_by_details_controller.dart'
    as _i894;
import 'package:marker/app/controllers/member_main/home/near_by_drink_details_controller.dart'
    as _i918;
import 'package:marker/app/controllers/member_main/home/payments_controller.dart'
    as _i329;
import 'package:marker/app/controllers/member_main/home/review_controller.dart'
    as _i174;
import 'package:marker/app/controllers/member_main/home/search_drink_controller.dart'
    as _i1;
import 'package:marker/app/controllers/member_main/home/search_drink_details_controller.dart'
    as _i875;
import 'package:marker/app/controllers/member_main/home/send_to_controller.dart'
    as _i647;
import 'package:marker/app/controllers/member_main/home/upcoming_marker_controller.dart'
    as _i458;
import 'package:marker/app/controllers/member_main/home/upcoming_marker_details_controller.dart'
    as _i563;
import 'package:marker/app/controllers/member_main/message/chat_controller.dart'
    as _i715;
import 'package:marker/app/controllers/member_main/message/messages_controller.dart'
    as _i69;
import 'package:marker/app/controllers/member_main/message/video_call_controller.dart'
    as _i146;
import 'package:marker/app/controllers/member_main/notifications/notifications_controller.dart'
    as _i655;
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart'
    as _i556;
import 'package:marker/app/controllers/owner_main/bar_profile/add_availability_controller.dart'
    as _i405;
import 'package:marker/app/controllers/owner_main/bar_profile/add_drink_controller.dart'
    as _i69;
import 'package:marker/app/controllers/owner_main/bar_profile/bar_profile_controller.dart'
    as _i820;
import 'package:marker/app/controllers/owner_main/bar_profile/edit_bar_profile_controller.dart'
    as _i848;
import 'package:marker/app/controllers/owner_main/owner_home/owner_home_controller.dart'
    as _i1015;
import 'package:marker/app/controllers/owner_main/owner_marker/marker_controller.dart'
    as _i15;
import 'package:marker/app/controllers/owner_main/owner_profile/bank_details_controller.dart'
    as _i43;
import 'package:marker/app/controllers/owner_main/owner_profile/contact_us_controller.dart'
    as _i506;
import 'package:marker/app/controllers/owner_main/owner_profile/my_wallet_controller.dart'
    as _i1049;
import 'package:marker/app/controllers/owner_main/owner_profile/owner_profile_controller.dart'
    as _i845;
import 'package:marker/app/controllers/owner_main/scan_redeem/owner_drink_list_controller.dart'
    as _i143;
import 'package:marker/app/controllers/owner_main/scan_redeem/scan_redeem_controller.dart'
    as _i706;
import 'package:marker/app/controllers/splash_controller.dart' as _i134;
import 'package:marker/app/data/services/auth_service/auth_service.dart'
    as _i981;
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart'
    as _i513;
import 'package:marker/app/data/services/member_service/member_service.dart'
    as _i513;
import 'package:marker/app/data/services/payment_service/payment_service.dart'
    as _i470;
import 'package:marker/app/data/services/refresh_token_service/refresh_token_service.dart'
    as _i779;
import 'package:marker/app/utils/helpers/injectable%20properties/injectable_properties.dart'
    as _i398;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.pref(),
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i359.LocationMapController>(
        () => _i359.LocationMapController());
    gh.lazySingleton<_i388.ForgotController>(() => _i388.ForgotController());
    gh.lazySingleton<_i1027.LoginController>(() => _i1027.LoginController());
    gh.lazySingleton<_i946.MemberRegisterController>(
        () => _i946.MemberRegisterController());
    gh.lazySingleton<_i513.AddBankController>(() => _i513.AddBankController());
    gh.lazySingleton<_i949.OwnerRegisterController>(
        () => _i949.OwnerRegisterController());
    gh.lazySingleton<_i975.OwnerRegisterProfileController>(
        () => _i975.OwnerRegisterProfileController());
    gh.lazySingleton<_i517.ResetPwdController>(
        () => _i517.ResetPwdController());
    gh.lazySingleton<_i678.VerificationController>(
        () => _i678.VerificationController());
    gh.lazySingleton<_i597.BaseHomeController>(
        () => _i597.BaseHomeController());
    gh.lazySingleton<_i586.FriendController>(() => _i586.FriendController());
    gh.lazySingleton<_i387.FriendListController>(
        () => _i387.FriendListController());
    gh.lazySingleton<_i666.DrinkDetailsController>(
        () => _i666.DrinkDetailsController());
    gh.lazySingleton<_i222.DrinkReviewController>(
        () => _i222.DrinkReviewController());
    gh.lazySingleton<_i869.HomeController>(() => _i869.HomeController());
    gh.lazySingleton<_i147.LocationMarkerController>(
        () => _i147.LocationMarkerController());
    gh.lazySingleton<_i501.MapNearByBarController>(
        () => _i501.MapNearByBarController());
    gh.lazySingleton<_i267.NearByController>(() => _i267.NearByController());
    gh.lazySingleton<_i894.NearByDetailsController>(
        () => _i894.NearByDetailsController());
    gh.lazySingleton<_i918.NearByDrinkDetailsController>(
        () => _i918.NearByDrinkDetailsController());
    gh.lazySingleton<_i329.PaymentsController>(
        () => _i329.PaymentsController());
    gh.lazySingleton<_i174.ReviewController>(() => _i174.ReviewController());
    gh.lazySingleton<_i1.SearchDrinkController>(
        () => _i1.SearchDrinkController());
    gh.lazySingleton<_i875.SearchDrinkDetailsController>(
        () => _i875.SearchDrinkDetailsController());
    gh.lazySingleton<_i647.SendToController>(() => _i647.SendToController());
    gh.lazySingleton<_i458.UpcomingMarkerController>(
        () => _i458.UpcomingMarkerController());
    gh.lazySingleton<_i563.UpcomingMarkerDetailsController>(
        () => _i563.UpcomingMarkerDetailsController());
    gh.lazySingleton<_i715.ChatController>(() => _i715.ChatController());
    gh.lazySingleton<_i69.MessagesController>(() => _i69.MessagesController());
    gh.lazySingleton<_i146.VideoCallController>(
        () => _i146.VideoCallController());
    gh.lazySingleton<_i655.NotificationsController>(
        () => _i655.NotificationsController());
    gh.lazySingleton<_i556.ProfileController>(() => _i556.ProfileController());
    gh.lazySingleton<_i405.AddAvailabilityController>(
        () => _i405.AddAvailabilityController());
    gh.lazySingleton<_i69.AddDrinkController>(() => _i69.AddDrinkController());
    gh.lazySingleton<_i820.BarProfileController>(
        () => _i820.BarProfileController());
    gh.lazySingleton<_i848.EditBarProfileController>(
        () => _i848.EditBarProfileController());
    gh.lazySingleton<_i1015.OHomeController>(() => _i1015.OHomeController());
    gh.lazySingleton<_i15.MarkerController>(() => _i15.MarkerController());
    gh.lazySingleton<_i43.BankDetailsController>(
        () => _i43.BankDetailsController());
    gh.lazySingleton<_i506.ContactUsController>(
        () => _i506.ContactUsController());
    gh.lazySingleton<_i1049.MyWalletController>(
        () => _i1049.MyWalletController());
    gh.lazySingleton<_i845.OwnerProfileController>(
        () => _i845.OwnerProfileController());
    gh.lazySingleton<_i143.OwnerDrinkListController>(
        () => _i143.OwnerDrinkListController());
    gh.lazySingleton<_i706.ScanRedeemController>(
        () => _i706.ScanRedeemController());
    gh.lazySingleton<_i134.SplashController>(() => _i134.SplashController());
    gh.lazySingleton<_i981.AuthService>(
        () => _i981.AuthService(gh<_i361.Dio>()));
    gh.lazySingleton<_i513.BarOwnerService>(
        () => _i513.BarOwnerService(gh<_i361.Dio>()));
    gh.lazySingleton<_i513.MemberService>(
        () => _i513.MemberService(gh<_i361.Dio>()));
    gh.lazySingleton<_i470.PaymentService>(
        () => _i470.PaymentService(gh<_i361.Dio>()));
    gh.lazySingleton<_i779.RefreshTokenService>(
        () => _i779.RefreshTokenService(gh<_i361.Dio>()));
    await gh.factoryAsync<_i497.Directory>(
      () => registerModule.temporaryDirectory(),
      instanceName: 'temporary',
      preResolve: true,
    );
    await gh.factoryAsync<_i497.Directory>(
      () => registerModule.documentDirectory(),
      instanceName: 'document',
      preResolve: true,
    );
    gh.lazySingleton<_i398.AppDirectory>(() => _i398.AppDirectory(
          temporaryDirectory: gh<_i497.Directory>(instanceName: 'temporary'),
          documentDirectory: gh<_i497.Directory>(instanceName: 'document'),
        ));
    return this;
  }
}

class _$RegisterModule extends _i398.RegisterModule {}
