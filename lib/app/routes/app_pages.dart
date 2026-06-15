import 'package:get/get.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/authentication/current_location_map_screen.dart';
import 'package:marker/app/ui/pages/authentication/forgot_pwd_page.dart';
import 'package:marker/app/ui/pages/authentication/login_page.dart';
import 'package:marker/app/ui/pages/authentication/member/member_register_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_bank_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/owner_register_manage.dart';
import 'package:marker/app/ui/pages/authentication/owner/owner_register_page.dart';
import 'package:marker/app/ui/pages/authentication/reset_pwd_page.dart';
import 'package:marker/app/ui/pages/authentication/selection_page.dart';
import 'package:marker/app/ui/pages/authentication/verify_code_page.dart';
import 'package:marker/app/ui/pages/member_main/friend/add_friends_page.dart';
import 'package:marker/app/ui/pages/member_main/friend/friends_page.dart';
import 'package:marker/app/ui/pages/member_main/home/drinks_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/bar_review_submit_page.dart';
import 'package:marker/app/ui/pages/member_main/home/drink_review_submit_page.dart';
import 'package:marker/app/ui/pages/member_main/home/home_page.dart';
import 'package:marker/app/ui/pages/member_main/home/map_location_page.dart';
import 'package:marker/app/ui/pages/member_main/home/map_near_by_bar_page.dart';
import 'package:marker/app/ui/pages/member_main/home/marker_redeemed_page.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_page.dart';
import 'package:marker/app/ui/pages/member_main/home/payment_page.dart';
import 'package:marker/app/ui/pages/member_main/home/review_page.dart';
import 'package:marker/app/ui/pages/member_main/home/search_drink_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/search_page.dart';
import 'package:marker/app/ui/pages/member_main/home/send_to_page.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart';
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_details_page.dart';
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_page.dart';
import 'package:marker/app/ui/pages/member_main/main_page/main_page.dart';
import 'package:marker/app/ui/pages/member_main/message/chat_page.dart';
import 'package:marker/app/ui/pages/member_main/message/messages_page.dart';
import 'package:marker/app/ui/pages/member_main/message/video_call_page.dart';
import 'package:marker/app/ui/pages/member_main/notifications/notifications_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/block_users_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/change_pwd_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/contact_us_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/delete_account_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/edit_my_profile_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/my_profile_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/profile_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/transaction_history_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_availability_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_drink_details_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_drink_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/availability_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/bar_profile_about_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/bar_profile_drink_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/bar_profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/edit_bar_profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/edit_drink_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_home/owner_home_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_home/owner_notification_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_main_page/owner_main_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_marker/marker_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/bank_details_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/edit_bank_details_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/history_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/my_wallet_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/owner_profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/withdraw_history_page.dart';
import 'package:marker/app/ui/pages/owner_main/scan_redeem/owner_drink_list_page.dart';
import 'package:marker/app/ui/pages/owner_main/scan_redeem/scan_redeem_page.dart';
import 'package:marker/app/ui/pages/splash_screen.dart';
import 'package:marker/app/ui/widgets/location_permmission.dart';

class AppPages {
  static final routes = [
    // Splash Page
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    //Login Page
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.locationPermission,
      page: () => const LocationPermissionScreen(),
    ),
    // current location open map and give location
    GetPage(
      name: AppRoutes.locationMapPage,
      page: () => const CurrentLocationMapScreen(),
    ),

    // forgot password
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),

    //  owner and member login and register selection
    GetPage(
      name: AppRoutes.selection,
      page: () => const SelectionScreen(),
    ),

    //otp verification
    GetPage(
      name: AppRoutes.verifyCode,
      page: () => const VerifyCodePage(),
    ),

    // reset password
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPwdPage(),
    ),

    // main screen of the member
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
    ),

    // sub screen of member home screen show upcoming data
    GetPage(
      name: AppRoutes.upcomingMarkerPage,
      page: () => const UpcomingMarkerPage(),
    ),

    // sub screen of member home screen show upcoming data show full data of upcoming screen
    GetPage(
      name: AppRoutes.upcomingMarkerDetailsPage,
      page: () => const UpcomingMarkerDetailsPage(),
    ),

    // sub screen of member home screen show upcoming data rate screen
    GetPage(
      name: AppRoutes.markerRedeemedPage,
      page: () => const MarkerRedeemedPage(),
    ),
    GetPage(
      name: AppRoutes.barReviewSubmitPage,
      page: () => const BarReviewSubmitPage(),
    ),
    GetPage(
      name: AppRoutes.drinkReviewSubmitPage,
      page: () => const DrinkReviewSubmitPage(),
    ),

    // sub screen of member home screen show near by bar location and show map and address
    GetPage(
      name: AppRoutes.mapLocationPage,
      page: () => const MapLocationPage(),
    ),

    // sub screen of member shows near by marker on map
    GetPage(
      name: AppRoutes.mapMarkerPage,
      page: () => const MapNearByBarPage(),
    ),

    // sub screen of member home screen show near by bar
    GetPage(
      name: AppRoutes.nearByPage,
      page: () => const NearByPage(),
    ),

    // sub screen of member home screen show near by bar and show full details of beer
    GetPage(
      name: AppRoutes.nearByDetailsPage,
      page: () => const NearByDetailsPage(),
    ),
    GetPage(
      name: AppRoutes.paymentPage,
      page: () => const PaymentPage(),
    ),
    GetPage(
      name: AppRoutes.tapToPayEnablePage,
      page: () => const TapToPayEnablePage(),
    ),
    GetPage(
      name: AppRoutes.tapToPayGuidePage,
      page: () => const TapToPayGuidePage(),
    ),
    GetPage(
      name: AppRoutes.sendToPage,
      page: () => const SendToPage(),
    ),
    GetPage(
      name: AppRoutes.chatPage,
      page: () => const ChatPage(),
    ),
    GetPage(
      name: AppRoutes.searchPage,
      page: () => const SearchPage(),
    ),
    GetPage(
      name: AppRoutes.searchDrinkDetailsPage,
      page: () => const SearchDrinkDetailsPage(),
    ),

    GetPage(
      name: AppRoutes.messagesPage,
      page: () => const MessagesPage(),
    ),
    GetPage(
      name: AppRoutes.videoCallPage,
      page: () => const VideoCallPage(),
    ),
    GetPage(
      name: AppRoutes.friendPage,
      page: () => const FriendsPage(),
    ),
    GetPage(
      name: AppRoutes.addFriendsPage,
      page: () => const AddFriendsPage(),
    ),

    GetPage(
      name: AppRoutes.blockUsersPage,
      page: () => const BlockUsersPage(),
    ),

    GetPage(
      name: AppRoutes.notificationsPage,
      page: () => const NotificationsPage(),
    ),
    GetPage(
      name: AppRoutes.mainPage,
      page: () => const MainPage(),
    ),
    //Member Register Page

    GetPage(
      name: AppRoutes.registerMember,
      page: () => const MemberRegisterPage(),
    ),
    //Owner Register Page
    GetPage(
      name: AppRoutes.registerOwner,
      page: () => const OwnerRegisterPage(),
    ),
    //Owner Register Page
    GetPage(
      name: AppRoutes.ownerRegisterManage,
      page: () => const OwnerRegisterManage(),
    ),
    //Add Bank Page
    GetPage(
      name: AppRoutes.addBank,
      page: () => const AddBankPage(),
    ),

    GetPage(
      name: AppRoutes.profilePage,
      page: () => const ProfilePage(),
    ),

    GetPage(
      name: AppRoutes.changePwdPage,
      page: () => const ChangePwdPage(),
    ),
    GetPage(
      name: AppRoutes.contactUsPage,
      page: () => const ContactUsPage(),
    ),
    GetPage(
      name: AppRoutes.deleteAccountPage,
      page: () => const DeleteAccountPage(),
    ),
    GetPage(
      name: AppRoutes.editMyProfilePage,
      page: () => const EditMyProfilePage(),
    ),
    GetPage(
      name: AppRoutes.myProfilePage,
      page: () => const MyProfilePage(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicyPage,
      page: () => const PrivacyPolicyPage(),
    ),

    GetPage(
      name: AppRoutes.transactionHistory,
      page: () => const TransactionHistoryPage(),
    ),
    GetPage(
      name: AppRoutes.profilePage,
      page: () => const ProfilePage(),
    ),

    GetPage(
      name: AppRoutes.ownerMainPage,
      page: () => const OwnerMainPage(),
    ),
    GetPage(
      name: AppRoutes.drinkDetails,
      page: () => const DrinkDetailsView(),
    ),
    GetPage(
      name: AppRoutes.ownerDrinkPage,
      page: () => const OwnerDrinkListPage(),
    ),
    GetPage(
      name: AppRoutes.ownerHomePage,
      page: () => const OwnerHomePage(),
    ),

    GetPage(
      name: AppRoutes.markerPage,
      page: () => const MarkerPage(),
    ),
    GetPage(
      name: AppRoutes.ownerProfilePage,
      page: () => const OwnerProfilePage(),
    ),
    GetPage(
      name: AppRoutes.bankDetailsPage,
      page: () => const BankDetailsPage(),
    ),
    GetPage(
      name: AppRoutes.editBankDetailsPage,
      page: () => const EditBankDetailsPage(),
    ),
    GetPage(
      name: AppRoutes.myWalletPage,
      page: () => const MyWalletPage(),
    ),
    GetPage(
      name: AppRoutes.withdrawHistoryPage,
      page: () => const WithdrawHistoryPage(),
    ),
    GetPage(
      name: AppRoutes.historyPage,
      page: () => const HistoryPage(),
    ),
    GetPage(
      name: AppRoutes.scanRedeemPage,
      page: () => const ScanRedeemPage(),
    ),

    GetPage(
      name: AppRoutes.ownerNotificationsPage,
      page: () => const OwnerNotificationPage(),
    ),

    GetPage(
      name: AppRoutes.barProfilePage,
      page: () => const BarProfilePage(),
    ),

    GetPage(
      name: AppRoutes.addAvailabilityPage,
      page: () => const AddAvailabilityPage(),
    ),
    GetPage(
      name: AppRoutes.addDrinkPage,
      page: () => const AddDrinkPage(),
    ),
    GetPage(
      name: AppRoutes.availabilityPage,
      page: () => const AvailabilityPage(),
    ),
    GetPage(
      name: AppRoutes.reviewPage,
      page: () => const ReviewPage(),
    ),
    GetPage(
      name: AppRoutes.barProfileAboutPage,
      page: () => const BarProfileAboutPage(),
    ),
    GetPage(
      name: AppRoutes.barProfileDrinkPage,
      page: () => const BarProfileDrinkPage(),
    ),
    GetPage(
      name: AppRoutes.editBarProfilePage,
      page: () => const EditBarProfilePage(),
    ),
    GetPage(
      name: AppRoutes.editDrinkPage,
      page: () => const EditDrinkPage(),
    ),
    GetPage(
      name: AppRoutes.addDrinkDetailsPage,
      page: () => const AddDrinkDetailsPage(),
    ),
  ];
}
