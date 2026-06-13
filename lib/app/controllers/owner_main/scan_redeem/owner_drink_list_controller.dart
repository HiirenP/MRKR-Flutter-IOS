import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class OwnerDrinkListController extends GetxController {
  OwnerDrinkListController() {
    onInit();
  }

  final batDetailsState = ApiState.initial().obs;
  final updateDrinkState = ApiState.initial().obs;
  RxList<BarDrinkData> drinksListData = <BarDrinkData>[].obs;
  List<BarDrinkData> tempDrinksListData = [];
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  int page = 1;
  RxInt selectedIndex = (-1).obs;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isOnceS = false;
  bool onceGoBack = false;
  String? markerId = '';

  void initData() {
    onceGoBack = false;
    tempDrinksListData = [];
    searchController = TextEditingController();
    scrollController = ScrollController();
    if (Get.arguments != null) {
      markerId = Get.arguments as String?;
    }
    page = 1;
    selectedIndex.value = -1;
    drinksListData.value = <BarDrinkData>[];
    hasMoreData.value = false;
    isDataEmpty.value = false;
    hasMoreData.value = false;
    isEndPage.value = false;
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        getDrinksListData();
      }
    });
    getDrinksListData();
  }

  void onDisposeData() {
    tempDrinksListData = [];
    page = 1;
    selectedIndex.value = -1;
    drinksListData.value = <BarDrinkData>[];
    hasMoreData.value = false;
    isDataEmpty.value = false;
    hasMoreData.value = false;
    isEndPage.value = false;
    searchController.text = '';
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
      'limit': 40,
    };

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
            if (tempDrinksListData.isEmpty) {
              tempDrinksListData = newItems;
            } else {
              tempDrinksListData.addAll(newItems);
            }
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

  Future<void> updateDrink() async {
    updateDrinkState.value = LoadingState();

    final requestData = <String, dynamic>{
      'markerId': markerId ?? '',
      'drinkId': drinksListData[selectedIndex.value].sId,
    };

    await getIt<BarOwnerService>().markerUpdateDrink(data: requestData).handler(
      updateDrinkState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          onGoBack();
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void setSearchValue(String value) {
    selectedIndex.value = -1;
    drinksListData.value = [];
    if (value.isEmpty) {
      isDataEmpty.value = false;
      drinksListData.addAll(tempDrinksListData);
      return;
    }

    for (var i = 0; i < tempDrinksListData.length; i++) {
      final model = tempDrinksListData[i];
      if (model.name.toString().toLowerCase().contains(value.toLowerCase())) {
        drinksListData.add(model);
      }
    }
    if (drinksListData.isEmpty) {
      isDataEmpty.value = true;
    } else {
      isDataEmpty.value = false;
    }
  }

  Future<void> onGoBack() async {
    Get.back();
    // await OwnerMainPage.route(value: 2);
  }
}
// 730FD2A4
// 0178D3A2
// 0826AF73
//