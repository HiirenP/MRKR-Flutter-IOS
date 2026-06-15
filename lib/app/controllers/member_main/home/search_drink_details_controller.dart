import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/search_drinks_model/search_drinks_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class SearchDrinkDetailsController extends GetxController with GetTickerProviderStateMixin {
  SearchDrinkDetailsController() {
    onInit();
  }

  bool isSelectedTab = false;
  late TabController tabController;
  RxInt selectedTab = 0.obs;
  String drinksId = '';
  String? barName;
  RxBool isFetch = false.obs;
  String? image;
  SearchDrinksList drinkData = SearchDrinksList();

  final drinksDetailsState = ApiState.initial().obs;
  Rx<DrinkDetailsData> drinkDetails = DrinkDetailsData().obs;
  RxBool hasMyDrinkReview = false.obs;

  void tabBarViewInit() {
    tabController = TabController(vsync: this, length: 2);
  }

  Future<void> getDrinkDetails() async {
    final requestData = <String, dynamic>{};
    await getIt<BarOwnerService>().getDrinksDetails(drinksId, requestData).handler(
      drinksDetailsState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          drinkDetails.value = value.data ?? DrinkDetailsData();
          final myReview = value.data?.myReview;
          hasMyDrinkReview.value = myReview?.sId != null && myReview!.sId!.isNotEmpty;
          isFetch.value = true;
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void disposeAll() {
    isFetch.value = false;
    hasMyDrinkReview.value = false;
    tabController.dispose();
    drinksId = '';
    barName = '';
    image = '';
  }
}
