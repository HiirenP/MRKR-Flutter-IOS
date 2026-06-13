import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_bank_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_drink_widget.dart';
import 'package:marker/app/ui/pages/authentication/owner/register_add_drink_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/register_bar_profile_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/register_owner_profile_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/image_compress_util.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';
import 'package:marker/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class OwnerRegisterProfileController extends GetxController {
  OwnerRegisterProfileController() {
    onInit();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  TextEditingController barNameController = TextEditingController();
  TextEditingController barMobileNumberController = TextEditingController();
  TextEditingController barEmailController = TextEditingController();
  TextEditingController barTimeController = TextEditingController();
  TextEditingController barAddressController = TextEditingController();
  TextEditingController barCityController = TextEditingController();
  TextEditingController barStateController = TextEditingController();
  TextEditingController barCountryController = TextEditingController();
  TextEditingController drinkNameController = TextEditingController();
  TextEditingController drinkPriceController = TextEditingController();
  TextEditingController drinkDescriptionController = TextEditingController();

  List<String> genderList = <String>[].obs;
  RxString selectedGender = ''.obs;
  RxBool isChecked = false.obs;
  RxBool isGenderSelected = true.obs;
  ValueNotifier<int> currentSelectionStep = ValueNotifier(0);
  RxList<CommonModel> listDrinks = <CommonModel>[].obs;
  RxBool isFromTime = true.obs;
  RxString fromTime = ''.obs;
  RxString toTime = ''.obs;
  RxString dialCode = '+1'.obs;
  RxString countryFlag = 'US'.obs;

  // RxInt hourTime = 1.obs;
  // RxInt minuteTime = 0.obs;
  // RxInt amPm = 0.obs;
  final loginState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formBarKey = GlobalKey<FormState>();
  GlobalKey<FormState> formBarAddKey = GlobalKey<FormState>();
  RxString imagePath = ''.obs;
  RxString imageDrinkPath = ''.obs;
  RxString barLogoPath = ''.obs;
  RxString barImagesPath = ''.obs;
  RxList<String> barPhotosPathList = <String>[].obs;
  Rx<LatLng?> currentPosition = Rx<LatLng?>(const LatLng(0, 0));

  Future<void> initialize() async {
    authModel = Rxn<AuthModel>();
    fullNameController = TextEditingController();
    mobileNumberController = TextEditingController();
    emailController = TextEditingController();
    genderController = TextEditingController();
    addressController = TextEditingController();
    countryController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    currentSelectionStep = ValueNotifier(0);
    listDrinks.value = [];
    isFromTime = true.obs;
  }

  String titleText() {
    var title = '';
    switch (currentSelectionStep.value) {
      case 2:
        title = AppStrings.T.addDrinks;
      case 1:
        title = AppStrings.T.barProfile;
      default:
        title = AppStrings.T.ownerProfile;
    }
    return title;
  }

  String subTitleText() {
    var title = '';
    switch (currentSelectionStep.value) {
      case 2:
        title = AppStrings.T.provideDrinkDetails;
      case 1:
        title = AppStrings.T.provideBarDetails;
      default:
        title = AppStrings.T.provideYourPersonal;
    }
    return title;
  }

  Widget managerPage() {
    Widget title;
    switch (currentSelectionStep.value) {
      case 2:
        title = const RegisterAddDrinkPage();
      case 1:
        title = const RegisterBarProfilePage();
      default:
        title = const RegisterOwnerProfilePage();
    }
    return title;
  }

  String checkAmPm(int value) {
    return value == 0 ? 'AM' : 'PM';
  }

  Future<void> ownerProfileRegisters(BuildContext context) async {
    final data = getIt<SharedPreferences>().getDeviceToken;
    if (data == null || data.isEmpty) {
      await PushNotifications.getDeviceToken();
    }
    if (!formKey.currentState!.validate()) {
      if (selectedGender.value.isEmpty) {
        isGenderSelected.value = false;
      } else {
        isGenderSelected.value = true;
      }
      return;
    }
    final profile = imagePath.value.trim().isNotEmpty ? File(imagePath.value) : null;
    String? voipToken;
    if (Platform.isIOS) {
      voipToken = await getSavedToken();
    }
    loginState.value = LoadingState();
    final gender = selectedGender.value.isNotEmpty ? selectedGender.value : null;
    await getIt<AuthService>()
        .memberRegister(
      name: fullNameController.text,
      iso: dialCode.value,
      countryFlag: countryFlag.value,
      mobile: mobileNumberController.text,
      email: emailController.text,
      gender: gender,
      address: addressController.text,
      country: countryController.text,
      pass: passController.text.trim().convertMd5,
      userType: 'barOwner',
      deviceType: Platform.operatingSystem == 'android' ? 'android' : 'iOS',
      deviceToken: getIt<SharedPreferences>().getDeviceToken ?? '',
      profile: profile,
      voipToken: getIt<SharedPreferences>().getVOIPToken ?? voipToken,
    )
        .handler(
      loginState,
      isLoading: true,
      onSuccess: (value) {
        final authData = value;
        if (authData.isSuccess && authData.statusCode == 200) {
          getIt<SharedPreferences>().setToken = value.data?.token;
          getIt<SharedPreferences>().setUserData = value.data;
          getIt<SharedPreferences>().setUserId = value.data?.id ?? '';
          currentSelectionStep.value = 1;
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> barProfileCreate(BuildContext context) async {
    if (barLogoPath.value.isEmpty) {
      showError(AppStrings.T.pleaseSelectBarLogo);
      return;
    }
    if (!formBarKey.currentState!.validate()) {
      return;
    }
    if (barPhotosPathList.isEmpty) {
      showError(AppStrings.T.pleaseSelectBarImage);
      return;
    }
    final tempFrom = localToUtcAvailableTime(fromTime.value);
    final tempTo = localToUtcAvailableTime(toTime.value);
    final barLogo = barLogoPath.value.trim().isNotEmpty
        ? File(await ImageCompressUtil.compressForUpload(barLogoPath.value))
        : null;

    final barPhotos = <MultipartFile>[];
    if (barPhotosPathList.isNotEmpty) {
      for (final imagePath in barPhotosPathList) {
        if (imagePath.trim().isNotEmpty) {
          final file = await ImageCompressUtil.multipartFromCompressed(
            imagePath.trim(),
            filename: imagePath.trim().split('/').last,
          );
          barPhotos.add(file);
        }
      }
    }
    loginState.value = LoadingState();
    await getIt<BarOwnerService>()
        .barProfileCreate(
      name: barNameController.text,
      countryFlag: countryFlag.value,
      mobile: barMobileNumberController.text,
      iso: dialCode.value,
      email: barEmailController.text,
      address: barAddressController.text,
      latitude: currentPosition.value!.latitude.toString(),
      longitude: currentPosition.value!.longitude.toString(),
      city: barCityController.text,
      state: barStateController.text,
      country: barCountryController.text,
      opensFrom: tempFrom,
      openTill: tempTo,
      logo: barLogo,
      images: barPhotos.isNotEmpty ? barPhotos : null,
    )
        .handler(
      loginState,
      onSuccess: (value) {
        final barProfileData = value;
        if (barProfileData.isSuccess && barProfileData.statusCode == 200) {
          final barID = barProfileData.data?.barId ?? '';
          getIt<SharedPreferences>().setBarId = barID;
          final userData = getIt<SharedPreferences>().getUserData;
          if (userData != null) {
            userData.isBarCreated = barID;
            getIt<SharedPreferences>().setUserData = userData;
          }
          final barId = getIt<SharedPreferences>().getBarId;
          debugPrint('barId----------$barId');
          currentSelectionStep.value = 2;
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> addBarDrink() async {
    debugPrint('addBarDrink--------->${listDrinks.length}');
    if (listDrinks.isEmpty) {
      if (!formBarAddKey.currentState!.validate()) {
        return;
      } else if (imageDrinkPath.value.isEmpty) {
        showError(AppValidations.imageValidation(imageDrinkPath.value));
        return;
      }
      listDrinks.add(CommonModel(
          name: drinkNameController.text.trim(),
          des: drinkDescriptionController.text.trim(),
          price: drinkPriceController.text.trim(),
          profileImage: imageDrinkPath.value));
    }
    debugPrint('addBarDrink------added--->${listDrinks.length}');
    final barId = getIt<SharedPreferences>().getBarId;

    loginState.value = LoadingState();

    final fi = <String, dynamic>{};
    for (var i = 0; i < listDrinks.length; i++) {
      fi.addAll({'name[$i]': listDrinks[i].name ?? ''});
      fi.addAll({'price[$i]': listDrinks[i].price ?? ''});
      fi.addAll({'description[$i]': listDrinks[i].des ?? ''});
    }
    fi.addAll({'barId': barId});

    final drinksImages = await Future.wait(
      listDrinks.map((element) async {
        return ImageCompressUtil.multipartFromCompressed(element.profileImage!);
      }),
    );

    final a = FormData.fromMap(fi);
    a.files.addAll(drinksImages.map((i) => MapEntry('drinksImage', i)));
    await getIt<BarOwnerService>()
        .addDrinks(
      drinkList: a,
    )
        .handler(
      loginState,
      onSuccess: (value) {
        successProfileBottomSheet();
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void nextPage() {
    debugPrint('currentSelectionStep.value-->${currentSelectionStep.value}');
    if (currentSelectionStep.value == 0) {
      ownerProfileRegisters(Get.context!);
    } else if (currentSelectionStep.value == 1) {
      barProfileCreate(Get.context!);
    } else {
      addBarDrink();
    }
  }

  Future<dynamic> successProfileBottomSheet() async {
    return Get.bottomSheet(
      isDismissible: false,
      enableDrag: false,
      AppBottomSheet(
        title: AppStrings.T.allDone,
        canPOP: false,
        subTitle: AppStrings.T.yourProfileCreated,
        iconName: Padding(
          padding: const AppEdgeInsets.all8(),
          child: ImageView(Assets.svg.allDone),
        ),
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: () {
          Get.back();
          AddBankPage.route()?.then(
            (value) {
              if (value != null) {
                if (value is bool) {
                  Get.back(result: value);
                }
              }
            },
          );
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void removeImage(int index) {
    barPhotosPathList.removeAt(index);
  }

  void addDrink() {
    if (listDrinks.isEmpty) {
      if (!formBarAddKey.currentState!.validate()) {
        return;
      } else if (imageDrinkPath.value.isEmpty) {
        showError(AppValidations.imageValidation(imageDrinkPath.value));
        return;
      }
      listDrinks.add(CommonModel(
          name: drinkNameController.text.trim(),
          des: drinkDescriptionController.text.trim(),
          price: drinkPriceController.text.trim(),
          profileImage: imageDrinkPath.value));
    }
    addDrinkBottomSheet(-1);
  }

  Future<dynamic> addDrinkBottomSheet(int index) {
    if (index == -1) {
      drinkPriceController.clear();
      drinkNameController.clear();
      drinkDescriptionController.clear();
      imageDrinkPath.value = '';
    } else {
      drinkPriceController.text = listDrinks[index].price!;
      drinkNameController.text = listDrinks[index].name!;
      drinkDescriptionController.text = listDrinks[index].des!;
      imageDrinkPath.value = listDrinks[index].profileImage!;
    }

    formBarAddKey = GlobalKey<FormState>();
    return Get.bottomSheet(
      isScrollControlled: true,
      AppBottomSheet(
        title: index == -1 ? AppStrings.T.addDrink : AppStrings.T.editDrink,
        isDivider: true,
        negativeButtonTitle: AppStrings.T.cancel,
        positiveButtonTitle: index == -1 ? AppStrings.T.add : AppStrings.T.save,
        onNegativePressed: Get.back,
        onPositivePressed: () {
          if (!formBarAddKey.currentState!.validate()) {
            return;
          } else if (imageDrinkPath.value.isEmpty) {
            showError(AppValidations.imageValidation(imageDrinkPath.value));
            return;
          }
          if (index == -1) {
            listDrinks.add(CommonModel(
                name: drinkNameController.text.trim(),
                des: drinkDescriptionController.text.trim(),
                price: drinkPriceController.text.trim(),
                profileImage: imageDrinkPath.value));
          } else {
            listDrinks[index] = CommonModel(
              name: drinkNameController.text.trim(),
              des: drinkDescriptionController.text.trim(),
              price: drinkPriceController.text.trim(),
              profileImage: imageDrinkPath.value,
            );
          }

          Get.back();
        },
        content: const AddDrinkWidget(),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<void> removeAt(int index) async {
    listDrinks.removeAt(index);
    Get.back();
  }
}
