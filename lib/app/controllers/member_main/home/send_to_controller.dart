import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/debouncer.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class SendToController extends GetxController {
  SendToController() {
    onInit();
  }

  TextEditingController searchController = TextEditingController();

  RxInt selectedIndex = (-1).obs;
  final ScrollController scrollController = ScrollController();
  final friendListState = ApiState.initial().obs;
  RxList<SearchUserFriendData> listFriends = <SearchUserFriendData>[].obs;
  RxInt totalFriends = 0.obs;
  int page = 1;
  RxBool hasMoreData = false.obs;
  Debouncer debouncer = Debouncer(milliseconds: 700);
  bool isOnceS = false;
  RedeemedUpcomingListData? modelMarker;
  RxBool isSuccess = false.obs;

  void onInitialize() {
    selectedIndex.value = -1;
    totalFriends.value = 0;
    isOnceS = false;
    isSuccess.value = false;
    if (Get.arguments != null && Get.arguments is RedeemedUpcomingListData) {
      modelMarker = Get.arguments as RedeemedUpcomingListData;
    }
    debouncer = Debouncer(milliseconds: 700);
    hasMoreData.value = false;
    page = 1;
    getFriendListData();
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (totalFriends.value == listFriends.length) {
          return;
        }
        isOnceS = true;
        page++;
        getFriendListData();
      }
    });
  }

  Future<void> getFriendListData() async {
    final requestData = <String, dynamic>{
      'limit': 10,
      'page': page,
      'searchText': searchController.text.trim(),
    };
    if (page == 1) {
      hasMoreData.value = false;
    }
    friendListState.value = LoadingState();
    await getIt<MemberService>().friendsList(requestData).handler(
      friendListState,
      isLoading: true,
      onSuccess: (value) {
        isOnceS = false;
        if (value.statusCode == 200 && (value.isSuccess ?? false) && value.data != null) {
          isSuccess.value = true;
          final temp = value.data;
          final listTemp = temp?.data ?? [];
          totalFriends.value = temp?.totalRecord ?? 0;
          if (listTemp.isNotEmpty) {
            if (page == 1) {
              listFriends.value = listTemp;
            } else {
              listFriends.addAll(listTemp);
            }
          }
        } else {
          isSuccess.value = false;
        }
      },
      onFailed: (value) {
        isSuccess.value = false;
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  void onSearchFriend(String value) {
    page = 1;
    hasMoreData.value = false;
    debouncer.run(getFriendListData);
  }

  void onDismiss() {
    isSuccess.value = false;
    searchController.clear();
    selectedIndex.value = -1;
  }
}
