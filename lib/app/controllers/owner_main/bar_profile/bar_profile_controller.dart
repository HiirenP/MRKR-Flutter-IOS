import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class BarProfileController extends GetxController with GetTickerProviderStateMixin {
  BarProfileController() {
    onInit();
  }

  TabController? tabController;
  RxInt selectedTab = 0.obs;

  final batDetailsState = ApiState.initial().obs;
  Rx<LatLng> currentPosition = Rx<LatLng>(const LatLng(0, 0));
  RxList<CommonModel> aboutList = <CommonModel>[].obs;
  PageController pageController = PageController();
  bool isOnce = false;
  bool isDrinkOnce = false;
  bool isUpdateDrink = false;
  RxBool isFetch = false.obs;
  RxList<BarDrinkData> drinksListData = <BarDrinkData>[].obs;
  RxList<DrinkCategoryData> drinkCategories = <DrinkCategoryData>[].obs;
  RxString selectedCategoryId = ''.obs;
  Rx<BarGetUpdateData>? getBarDetailsData = BarGetUpdateData().obs;
  int totalRecord = 0;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isOnceS = false;
  String barName = '';

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void tabBarViewInit() {
    tabController = TabController(vsync: this, length: 2);
  }

  void addAboutListData() {
    aboutList.value = [];
    final data = getBarDetailsData?.value;

    if (data != null) {
      barName = data.name ?? '';

      final openingHours =
          '${utcToLocalAvailableTime(data.openingHours?.open ?? '')} - ${utcToLocalAvailableTime(data.openingHours?.close ?? '')}';
      aboutList.addAll([
        CommonModel(icon: Assets.svg.callCalling, title: AppStrings.T.mobileNumber, subTitle: data.mobile),
        CommonModel(icon: Assets.svg.email, title: AppStrings.T.email, subTitle: data.email),
        CommonModel(icon: Assets.svg.clock, title: AppStrings.T.openingHours, subTitle: openingHours),
        CommonModel(icon: Assets.svg.location, title: AppStrings.T.address, subTitle: data.address),
        CommonModel(icon: Assets.svg.buliding, title: AppStrings.T.city, subTitle: data.city),
        CommonModel(icon: Assets.svg.routing, title: AppStrings.T.state, subTitle: data.state),
        CommonModel(icon: Assets.svg.global, title: AppStrings.T.country, subTitle: data.country),
      ]);
    }
  }

  Future<void> fetchBarOwnerData() async {
    batDetailsState.value = LoadingState();
    await getIt<BarOwnerService>().ownerBarDetails(getIt<SharedPreferences>().getBarId ?? '').handler(
      batDetailsState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          isFetch.value = true;
          getBarDetailsData?.value = value.data ?? BarGetUpdateData();
          addAboutListData();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> loadDrinkCategories() async {
    try {
      final response = await getIt<BarOwnerService>().drinkCategoriesList();
      final data = response['data'] as List<dynamic>? ?? [];
      drinkCategories.value = data
          .map((e) => DrinkCategoryData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('loadDrinkCategories error: $e');
    }
  }

  void onDrinkCategoryFilterChanged(String categoryId) {
    selectedCategoryId.value = categoryId;
    drinksListData.value = [];
    page = 1;
    isEndPage.value = false;
    isDataEmpty.value = false;
    isOnceS = false;
    getDrinksListData();
  }

  Future<void> getDrinksListData() async {
    if (page == 1) {
      hasMoreData.value = false;
      batDetailsState.value = LoadingState();
    } else {
      hasMoreData.value = true;
    }

    final requestData = <String, dynamic>{
      'barId': getIt<SharedPreferences>().getBarId,
      'page': page,
      'limit': 15,
    };
    if (selectedCategoryId.value.isNotEmpty) {
      requestData['categoryId'] = selectedCategoryId.value;
    }

    await getIt<BarOwnerService>().listByBarDrinks(data: requestData).handler(
      batDetailsState,
      isLoading: page == 1,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          final newItems = value.data?.data ?? [];
          if (page == 1 && newItems.isEmpty) {
            isDataEmpty.value = true;
          }
          if (newItems.isNotEmpty) {
            if (page > 1) {
              hasMoreData.value = false;
              isDataEmpty.value = false;
            } else {
              drinksListData.value = [];
            }
            final totalRecord = value.data?.totalRecord ?? 0;
            drinksListData.addAll(newItems);
            debugPrint('isDataEmpty--${newItems.length}-->${isDataEmpty.value}');
            page++;
            if (totalRecord == drinksListData.length) {
              isEndPage.value = true;
            }
          }
        }
        isOnceS = false;
      },
      onFailed: (value) {
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  Future<void> tabSelection(int tab) async {
    if (tab == 0) {
      return;
    }
    drinksListData.value = [];
    page = 1;
    hasMoreData = true.obs;
    await getDrinksListData();
  }

  void updateInitEntry() {
    isEndPage.value = false;
    drinksListData.value = [];
    page = 1;
    selectedCategoryId.value = '';
    loadDrinkCategories();
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        getDrinksListData();
      }
    });
  }

  void resetValue() {
    isFetch.value = false;
    totalRecord = 0;
    hasMoreData = false.obs;
    drinksListData.value = [];
    getBarDetailsData = BarGetUpdateData().obs;
    page = 1;
  }
}
