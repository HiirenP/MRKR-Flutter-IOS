import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class UpcomingMarkerController extends GetxController {

  UpcomingMarkerController() {
    onInit();
  }


  final upcomingState = ApiState.initial().obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isOnceS = false;

  RxList<RedeemedUpcomingListData> upComingList = <RedeemedUpcomingListData>[].obs;

  Future<void> fetchUpcomingMarkerListData() async {
    if (page == 1) {
      hasMoreData.value = false;
      upcomingState.value = LoadingState();
    } else {
      hasMoreData.value = true;
    }

    final requestData = <String, dynamic>{
      'page': page,
      'limit': 10,
    };

    await getIt<MemberService>().upcomingMarkerList(requestData).handler(
      upcomingState,
      isLoading: page == 1,
      onSuccess: (value) {
        isOnceS = false;
        if (value.statusCode == 200 && value.data != null) {
          final newItems = value.data?.data ?? [];
          if (newItems.isEmpty && page == 1) {
            isDataEmpty.value = true;
          }
          if (page != 1) {
            hasMoreData.value = false;
          }
          final totalRecord = value.data?.totalRecord ?? 0;
          upComingList.addAll(newItems);

          page++;
          if (totalRecord == upComingList.length) {
            isEndPage.value = true;
          }
        }
      },
      onFailed: (value) {
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  void updateInitEntry() {
    isEndPage.value = false;
    upComingList.value = [];
    page = 1;
    fetchUpcomingMarkerListData();
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        fetchUpcomingMarkerListData();
      }
    });
  }


  void disposeAll() {
    page = 1;
    hasMoreData = false.obs;
    isDataEmpty = false.obs;
    isEndPage = false.obs;
    upComingList.value = [];

  }
}
