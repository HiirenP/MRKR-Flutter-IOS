import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_details_model/bar_details_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/service/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class NearByController extends GetxController {
  NearByController() {
    onInit();
  }

  LocationService locationService = LocationService();
  final upcomingState = ApiState.initial().obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isOnceS = false;
  bool isNoLocation = false;
  RxList<BarDetailsData> nearByList = <BarDetailsData>[].obs;

  Future<void> fetchNearByListData() async {
    if (page == 1) {
      hasMoreData.value = false;
      upcomingState.value = LoadingState();
    } else {
      hasMoreData.value = true;
    }
    final coords = await resolveMemberMapCoordinates();
    final lat = coords.lat;
    final lng = coords.lng;
    isNoLocation = !coords.hasFix;
    final requestData = <String, dynamic>{
      'latitude': lat,
      'longitude': lng,
      'page': page,
      'limit': 10,
    };

    await getIt<MemberService>().nearByList(requestData).handler(
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
          nearByList.addAll(newItems);

          page++;
          if (totalRecord == nearByList.length) {
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
    nearByList.value = [];
    page = 1;
    fetchNearByListData();
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        fetchNearByListData();
      }
    });
  }
}
