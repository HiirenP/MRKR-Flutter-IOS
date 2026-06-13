import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';

@i.lazySingleton
@i.injectable
class OwnerProfileController extends GetxController {
  OwnerProfileController() {
    onInit();
  }
  final changeState = ApiState.initial().obs;
  List<CommonModel> profileList = <CommonModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    addProfileList();
  }

  void addProfileList() {
    profileList = [];
    profileList.addAll([
      CommonModel(name: AppStrings.T.myProfile, icon: Assets.svg.profileCircle),
      CommonModel(name: AppStrings.T.changePassword, icon: Assets.svg.lock),
      if (AppConstant.userType == UserType.owner) CommonModel(name: AppStrings.T.myWallet, icon: Assets.svg.wallet),
      if (AppConstant.userType == UserType.owner) CommonModel(name: AppStrings.T.bankDetails, icon: Assets.svg.bank),
      if (AppConstant.userType == UserType.owner) CommonModel(name: AppStrings.T.withdrawHistory, icon: Assets.svg.receipt),
      CommonModel(name: AppStrings.T.contactUs, icon: Assets.svg.contactUs),
      CommonModel(name: AppStrings.T.aboutUs, icon: Assets.svg.aboutUs),
      CommonModel(name: AppStrings.T.termsConditions, icon: Assets.svg.tremCon),
      CommonModel(name: AppStrings.T.privacyPolicy, icon: Assets.svg.privacy),
      CommonModel(name: AppStrings.T.deleteAccount, icon: Assets.svg.trash),
      CommonModel(name: AppStrings.T.logOut, icon: Assets.svg.logout),
    ]);
  }
}
