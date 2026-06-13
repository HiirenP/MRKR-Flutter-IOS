import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/image_compress_util.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class AddDrinkController extends GetxController {
  AddDrinkController() {
    onInit();
  }

  TextEditingController drinkNameController = TextEditingController();
  TextEditingController drinkPriceController = TextEditingController();
  TextEditingController drinkDescriptionController = TextEditingController();
  final drinkUpdateState = ApiState.initial().obs;
  RxString imageDrinkPath = ''.obs;
  RxString imageDrink = ''.obs;
  RxString drinksId = ''.obs;
  String barName = '';
  Rx<DrinkDetailsData> getDrink = DrinkDetailsData().obs;
  RxBool isFetch = false.obs;
  Rx<LatLng> currentPosition = Rx<LatLng>(const LatLng(0, 0));
  GlobalKey<FormState> formBarAddKey = GlobalKey<FormState>();
  int page = 1;
  int limit = 10;
  final drinksDetailsState = ApiState.initial().obs;
  RxList<DrinkCategoryData> drinkCategories = <DrinkCategoryData>[].obs;
  RxString selectedCategoryId = ''.obs;

  Future<void> loadDrinkCategories() async {
    try {
      final response = await getIt<BarOwnerService>().drinkCategoriesList();
      final data = response['data'] as List<dynamic>? ?? [];
      drinkCategories.value = data
          .map((e) => DrinkCategoryData.fromJson(e as Map<String, dynamic>))
          .toList();
      if (selectedCategoryId.isEmpty && drinkCategories.isNotEmpty) {
        selectedCategoryId.value = drinkCategories.first.sId ?? '';
      }
    } catch (e) {
      debugPrint('loadDrinkCategories error: $e');
    }
  }

  void applyCategoryFromDrink(DrinkDetailsData data) {
    final id = data.categoryId ?? data.category?.sId;
    if (id != null && id.isNotEmpty) {
      selectedCategoryId.value = id;
    }
  }

  void applyCategoryFromBarDrink(BarDrinkData data) {
    final id = data.categoryId ?? data.category?.sId;
    if (id != null && id.isNotEmpty) {
      selectedCategoryId.value = id;
    }
  }

  Future<void> addBarDrink() async {
    if (!formBarAddKey.currentState!.validate()) {
      return;
    } else if (imageDrinkPath.value.isEmpty) {
      showError(AppValidations.imageValidation(imageDrinkPath.value));
      return;
    }

    final barId = getIt<SharedPreferences>().getBarId;
    drinkUpdateState.value = LoadingState();
    final fi = <String, dynamic>{};

    fi.addAll({'name[0]': drinkNameController.text});
    fi.addAll({'price[0]': drinkPriceController.text});
    fi.addAll({'description[0]': drinkDescriptionController.text});
    fi.addAll({'barId': barId});
    if (selectedCategoryId.value.isNotEmpty) {
      fi.addAll({'categoryId[0]': selectedCategoryId.value});
    }

    final drinksImages = await ImageCompressUtil.multipartFromCompressed(imageDrinkPath.value);
    final a = FormData.fromMap(fi);
    a.files.add(MapEntry('drinksImage', drinksImages));

    await getIt<BarOwnerService>().addDrinks(drinkList: a).handler(
      drinkUpdateState,
      onSuccess: (value) async {
        if (value.statusCode == 200 && value.data != null) {
          Get.back(result: value.data);
          await Future.delayed(const Duration(milliseconds: 100));
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> editDrink() async {
    if (!formBarAddKey.currentState!.validate()) {
      return;
    }

    bool isUrl(String path) {
      final uri = Uri.tryParse(path);
      return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
    }

    final drinksImage = (imageDrinkPath.isNotEmpty && !isUrl(imageDrinkPath.value)) ? File(imageDrinkPath.value) : null;

    await getIt<BarOwnerService>()
        .updateDrinks(drinksId.value,
            name: drinkNameController.text.trim(),
            price: drinkPriceController.text.trim(),
            description: drinkDescriptionController.text.trim(),
            categoryId: selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value,
            drinksImage: drinksImage)
        .handler(
      drinkUpdateState,
      onSuccess: (value) async {
        if (value.statusCode == 200 && value.data != null) {
          Get.back(result: value.data);
          await Future.delayed(const Duration(milliseconds: 100));
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> deleteDrink() async {
    await getIt<BarOwnerService>().deleteDrinks(drinksId.value).handler(
      drinkUpdateState,
      onSuccess: (value) async {
        if (value.statusCode == 200) {
          Get.back(result: true);
          await Future.delayed(const Duration(milliseconds: 100));
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> deleteAccountBottomSheet() async {
    final context = Get.context!;
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(
            Assets.svg.trash,
            color: context.colorScheme.primary,
          ),
        ),
        title: AppStrings.T.deleteDrink,
        subTitle: AppStrings.T.areYouSureDeleteDrink,
        positiveButtonTitle: AppStrings.T.yes,
        negativeButtonTitle: AppStrings.T.cancel,
        onNegativePressed: Get.back,
        onPositivePressed: deleteDrink,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void disposeAll() {
    drinkNameController.dispose();
    drinkPriceController.dispose();
    drinkDescriptionController.dispose();
    imageDrinkPath.value = '';
  }

  Future<void> getDrinkDetailsData() async {
    final requestData = <String, dynamic>{
      'longitude': currentPosition.value.longitude,
      'latitude': currentPosition.value.latitude,
      'page': page,
      'limit': limit,
    };

    await getIt<BarOwnerService>().getDrinksDetails(drinksId.value, requestData).handler(
      drinksDetailsState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          getDrink.value = value.data ?? DrinkDetailsData();
          applyCategoryFromDrink(getDrink.value);
          isFetch.value = true;
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
