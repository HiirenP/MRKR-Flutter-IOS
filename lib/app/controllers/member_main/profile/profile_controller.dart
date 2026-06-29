import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/controllers/member_main/message/chat_controller.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/pages/authentication/login_page.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/image_compress_util.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

@i.lazySingleton
@i.injectable
class ProfileController extends GetxController {
  ProfileController() {
    onInit();
  }

  final GlobalKey<FormState> formKeyContact = GlobalKey<FormState>();
  final GlobalKey<FormState> formChangePwdKey = GlobalKey<FormState>();

  List<CommonModel> profileList = <CommonModel>[].obs;
  RxList<CommonModel> myProfileList = <CommonModel>[].obs;
  List<String> genderList = <String>[].obs;
  List<String> deleteAccountList = <String>[].obs;
  RxString selectedGender = AppStrings.T.male.obs;
  RxString profileImage = Assets.svg.user.obs;
  RxString title = ''.obs;
  RxString url = ''.obs;
  RxInt selectedReason = 0.obs;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController deleteWriteMessageController = TextEditingController();
  final changeState = ApiState.initial().obs;
  final profileState = ApiState.initial().obs;
  final errorMessage = ''.obs;
  final blockedState = ApiState.initial().obs;
  final unBlockState = ApiState.initial().obs;
  RxList<BlockedUsersInfo> listBlockedUsers = <BlockedUsersInfo>[].obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  WebViewController? webViewController;
  AuthData? authData;
  RxBool isGenderSelected = true.obs;
  RxString dialCode = '+91'.obs;
  String flag = '';
  RxString imagePath = ''.obs;
  RxBool isFullScreenWebView = false.obs;

  @override
  void onInit() {
    super.onInit();
    genderList = [AppStrings.T.chooseGender, AppStrings.T.male, AppStrings.T.female, AppStrings.T.other];
  }

  void addProfileList() {
    profileList = [];
    profileList.addAll([
      CommonModel(name: AppStrings.T.myProfile, icon: Assets.svg.profileCircle),
      CommonModel(name: AppStrings.T.changePassword, icon: Assets.svg.lock),
      CommonModel(name: AppStrings.T.transactionHistory, icon: Assets.svg.trasaction),
      CommonModel(name: AppStrings.T.chatTextSize, icon: Assets.svg.documentText),
      CommonModel(name: AppStrings.T.blockUsers, icon: Assets.svg.icBlock),
      CommonModel(name: AppStrings.T.contactUs, icon: Assets.svg.contactUs),
      if (Platform.isIOS) CommonModel(name: AppStrings.T.tapToPayiPhone, icon: Assets.svg.contactless),
      if (Platform.isIOS) CommonModel(name: AppStrings.T.tapToPayGuide, icon: Assets.svg.documentText),
      CommonModel(name: AppStrings.T.aboutUs, icon: Assets.svg.aboutUs),
      CommonModel(name: AppStrings.T.termsConditions, icon: Assets.svg.tremCon),
      CommonModel(name: AppStrings.T.privacyPolicy, icon: Assets.svg.privacy),
      CommonModel(name: AppStrings.T.deleteAccount, icon: Assets.svg.trash),
      CommonModel(name: AppStrings.T.logOut, icon: Assets.svg.logout),
    ]);
  }

  Future<void> showChatFontSizeSheet() async {
    final prefs = getIt<SharedPreferences>();
    final currentSize = prefs.getChatFontSize;
    final context = Get.context!;

    await Get.bottomSheet<void>(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                AppStrings.T.chatTextSize,
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _chatFontSizeTile(
                context: context,
                label: AppStrings.T.chatTextSizeSmall,
                size: SharedPreferencesX.chatFontSizeSmall,
                selected: currentSize == SharedPreferencesX.chatFontSizeSmall,
              ),
              _chatFontSizeTile(
                context: context,
                label: AppStrings.T.chatTextSizeMedium,
                size: SharedPreferencesX.chatFontSizeMedium,
                selected: currentSize == SharedPreferencesX.chatFontSizeMedium,
              ),
              _chatFontSizeTile(
                context: context,
                label: AppStrings.T.chatTextSizeLarge,
                size: SharedPreferencesX.chatFontSizeLarge,
                selected: currentSize == SharedPreferencesX.chatFontSizeLarge,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: context.colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _chatFontSizeTile({
    required BuildContext context,
    required String label,
    required double size,
    required bool selected,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: AppText(label, style: TextStyle(fontSize: size)),
      trailing: selected ? Icon(Icons.check_circle, color: context.colorScheme.primary) : null,
      onTap: () {
        ChatController.applyChatFontSize(size);
        Get.back();
        showSuccess('${AppStrings.T.chatTextSize}: $label');
      },
    );
  }

  Future<void> addMyprofileList() async {
    try {
      myProfileList.value = [];
      final userData = getIt<SharedPreferences>().getUserData;
      authData = userData;
      profileImage.value = (authData?.profile != null && authData!.profile!.isNotEmpty)
          ? authData!.profile!
          : '';
      myProfileList.addAll([
        CommonModel(title: AppStrings.T.fullName, subTitle: userData?.name, icon: Assets.svg.profileCircle),
        CommonModel(
          title: AppStrings.T.mobileNumber,
          subTitle: _formatMobileDisplay(userData?.iso, userData?.mobile),
          icon: Assets.svg.callCalling,
        ),
        CommonModel(title: AppStrings.T.email, subTitle: userData?.email, icon: Assets.svg.email),
        CommonModel(title: AppStrings.T.gender, subTitle: userData?.gender, icon: Assets.svg.gender),
        CommonModel(title: AppStrings.T.address, subTitle: userData?.address, icon: Assets.svg.location),
        CommonModel(title: AppStrings.T.country, subTitle: userData?.country, icon: Assets.svg.global),
      ]);
      debugPrint('myProfileListmyProfileList ${myProfileList.length}');
    } catch (e) {
      debugPrint('error errror $e');
    }
  }

  String _formatMobileDisplay(String? iso, String? mobile) {
    if (mobile == null || mobile.isEmpty) return '';
    return '${iso ?? ''}$mobile'.trim();
  }

  void addDeleteReasonList() {
    deleteAccountList = [];
    deleteAccountList.addAll([
      AppStrings.T.itSpam,
      AppStrings.T.falseInformation,
      AppStrings.T.privacyConcerns,
      AppStrings.T.violenceThreats,
      AppStrings.T.other,
    ]);
  }

  // Helper methods for each case
  Future<void> updateProfileAPI() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if profile image is still the default image
    if (imagePath.value.trim().isEmpty && (this.profileImage.value.isEmpty || this.profileImage.value == Assets.svg.user)) {
      showError(AppStrings.T.pleaseSelectProfileImage);
      return;
    }

    changeState.value = LoadingState();

    File? profileFile;
    final mobileNumber = mobileNumberController.text.trim();
    if (imagePath.value.trim().isNotEmpty) {
      final compressed = await ImageCompressUtil.compressProfile(imagePath.value);
      profileFile = File(compressed);
    }

    await getIt<AuthService>()
        .updateMemberUserProfile(
      name: fullNameController.text,
      gender: selectedGender.value,
      address: addressController.text,
      country: countryController.text,
      mobile: mobileNumber,
      profile: profileFile,
      countryFlag: flag,
      iso: dialCode.value,
    )
        .handler(
      changeState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          getIt<SharedPreferences>().setUserData = value.data;
          authData = value.data;
          profileImage.value = value.data?.profile ?? '';
          Get.back(result: true);
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  // Helper methods for each case
  Future<void> fetchProfileAPI() async {
    profileState.value = LoadingState();

    await getIt<AuthService>().profileAPI().handler(
      profileState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          getIt<SharedPreferences>().setUserData = value.data;
          getIt<SharedPreferences>().setTapToPayEnabled = value.data?.tapToPayEnabled ?? getIt<SharedPreferences>().getTapToPayEnabled;
          authData = value.data;
          profileImage.value = value.data?.profile ?? '';
          addMyprofileList();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void addWebView({String? link, bool isPayment = false}) {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(isPayment ? Colors.white : Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            final uri = Uri.parse(url);
            if (uri.queryParameters['redirect_status'] == 'succeeded') {
              debugPrint('Payment succeeded!');
              Get.back(result: true);
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('NavigationRequest-----------------${request.url}');
            debugPrint('NavigationRequest---link--------------$link');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(link!));
  }

  Future<void> changePassword(BuildContext context) async {
    if (!formChangePwdKey.currentState!.validate()) {
      return;
    }
    changeState.value = LoadingState();
    await getIt<AuthService>()
        .changePassword(oldPassword: passController.text.trim().convertMd5, newPassword: newPassController.text.trim().convertMd5)
        .handler(
      changeState,
      onSuccess: (value) {
        if (value.isSuccess && value.statusCode == 200 && value.data != null) {
          Get.back();
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> getUserData() async {
    genderList = [AppStrings.T.chooseGender, AppStrings.T.male, AppStrings.T.female, AppStrings.T.other];
    authData = getIt<SharedPreferences>().getUserData;
    if (authData != null) {
      dialCode.value = authData!.iso ?? '';
      flag = authData!.countryFlag ?? '';
      debugPrint('dialCode.value--->${dialCode.value}');
      if (authData?.gender == null || (authData != null && authData!.gender != null && authData!.gender!.isEmpty)) {
        selectedGender.value = genderList.first;
      } else {
        selectedGender.value = authData?.gender ?? '';
      }
      fullNameController = TextEditingController(text: authData?.name);
      mobileNumberController = TextEditingController(text: authData?.mobile);
      emailController = TextEditingController(text: authData?.email);
      countryController = TextEditingController(text: authData?.country);
      addressController = TextEditingController(text: authData?.address);
    }
  }

  void onBack() {
    authData = getIt<SharedPreferences>().getUserData;
    profileImage.value = (authData?.profile != null && authData!.profile!.isNotEmpty)
        ? authData!.profile!
        : '';
    addMyprofileList();
  }

  Future<void> deleteUserAccount() async {
    AppConstant.instance.socket?.emit(AppConstant.instance.emitSocketLeave, {'userId': getIt<SharedPreferences>().getUserId});
    try {
      AppConstant.instance.socket?.off('connect');
      AppConstant.instance.socket?.disconnect();
      AppConstant.instance.socket?.close();
      AppConstant.instance.socket = null;
    } catch (e) {
      debugPrint('Delete Account Error Socket Disconnect--->$e');
    }
    changeState.value = LoadingState();
    await getIt<AuthService>()
        .deleteAccount(
            deleteReason:
                deleteWriteMessageController.text.trim().isEmpty ? deleteAccountList[selectedReason.value] : deleteWriteMessageController.text.trim())
        .handler(
      changeState,
      onSuccess: (value) {
        showSuccess(value.message);
        AppConstant.instance.socket = null;
        getIt<SharedPreferences>().clearData();
        LoginPage.offAllRouteLogin();
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> apiBlockedUsers() async {
    final data = <String, dynamic>{'page': 1, 'limit': 50};
    blockedState.value = LoadingState();
    await getIt<MemberService>().blockedUsers(data).handler(
      blockedState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          listBlockedUsers.value = value.data?.data ?? [];
          if (listBlockedUsers.isEmpty) {
            errorMessage.value = 'No any blocked users found';
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> apiUnBlockUser({required String blockedId, required int index}) async {
    final data = <String, dynamic>{'blockedId': blockedId};
    unBlockState.value = LoadingState();
    await getIt<MemberService>().unBlockUser(data).handler(
      unBlockState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          showSuccess(value.message ?? '');
          if (listBlockedUsers.isNotEmpty) {
            listBlockedUsers.removeAt(index);
            if (listBlockedUsers.isEmpty) {
              errorMessage.value = 'No any blocked users found';
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

Future<void> logoutUser(Rx<ApiState> changeState) async {
  AppConstant.instance.socket?.emit(AppConstant.instance.emitSocketLeave, {'userId': getIt<SharedPreferences>().getUserId});
  try {
    AppConstant.instance.socket?.off('connect');
    AppConstant.instance.socket?.disconnect();
    AppConstant.instance.socket?.close();
    AppConstant.instance.socket = null;
  } catch (e) {
    debugPrint('Logout Error Socket Disconnect--->$e');
  }
  changeState.value = LoadingState();
  await getIt<AuthService>().logOut().handler(
    changeState,
    onSuccess: (value) {
      showSuccess(value.message);
      getIt<SharedPreferences>().clearData();
      LoginPage.offAllRouteLogin();
    },
    onFailed: (value) {
      showError(value.error.description);
    },
  );
}
