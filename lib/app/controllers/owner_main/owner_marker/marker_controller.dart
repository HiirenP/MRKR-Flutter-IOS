import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class MarkerController extends GetxController {
  MarkerController() {
    onInit();
  }

  final upcomingState = ApiState.initial().obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  bool isOnces = false;
  bool _scrollListenerAttached = false;
  RxBool isSelected = true.obs;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  RxList<RedeemedUpcomingListData> redeemedUpcomingData = <RedeemedUpcomingListData>[].obs;

  Future<void> fetchRedeemedUpcomingData() async {
    final barId = getIt<SharedPreferences>().getBarId;
    if (barId == null || barId.isEmpty) {
      isDataEmpty.value = true;
      showError('Unable to load markers. Bar information is missing.');
      return;
    }

    isDataEmpty.value = false;
    if (page == 1) {
      hasMoreData.value = false;
      upcomingState.value = LoadingState();
    } else {
      hasMoreData.value = true;
    }

    final requestData = <String, dynamic>{
      'barId': barId,
      'page': page,
      'limit': 10,
      'status': isSelected.value ? 'active' : 'redeemed',
    };

    await getIt<BarOwnerService>().upcomingRedeemed(requestData).handler(
      upcomingState,
      isLoading: page == 1,
      onSuccess: (value) {
        isOnces = false;
        final statusOk = (value.statusCode == 200 || value.statusCode == 200.0) && value.isSuccess;
        if (statusOk && value.data != null) {
          final newItems = value.data?.data ?? [];
          debugPrint('MarkerController loaded ${newItems.length} markers (page=$page, total=${value.data?.totalRecord})');
          if (page == 1) {
            redeemedUpcomingData.assignAll(newItems);
          } else {
            redeemedUpcomingData.addAll(newItems);
          }
          redeemedUpcomingData.refresh();
          isDataEmpty.value = redeemedUpcomingData.isEmpty;
          if (page != 1) {
            hasMoreData.value = false;
          }
          final totalRecord = value.data?.totalRecord ?? 0;
          page++;
          if (totalRecord > 0 && totalRecord == redeemedUpcomingData.length) {
            isEndPage.value = true;
          }
        } else if (page == 1) {
          redeemedUpcomingData.clear();
          isDataEmpty.value = true;
        }
      },
      onFailed: (value) {
        isOnces = false;
        if (page == 1 && redeemedUpcomingData.isEmpty) {
          isDataEmpty.value = true;
        }
        showError(value.error.description);
      },
    );
  }

  void updateInitEntry() {
    isSelected.value = true;
    isEndPage.value = false;
    isDataEmpty.value = false;
    isOnces = false;
    redeemedUpcomingData.clear();
    page = 1;
    fetchRedeemedUpcomingData();

    if (!_scrollListenerAttached) {
      _scrollListenerAttached = true;
      scrollController.addListener(() {
        if (!isOnces && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (isEndPage.value) {
            return;
          }
          isOnces = true;
          fetchRedeemedUpcomingData();
        }
      });
    }
  }
}
