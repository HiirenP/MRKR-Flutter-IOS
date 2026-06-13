import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/debouncer.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/helpers/loading.dart';

@i.lazySingleton
@i.injectable
class FriendController extends GetxController {
  FriendController() {
    onInit();
  }

  final searchState = ApiState.initial().obs;
  final addFriendState = ApiState.initial().obs;
  Rxn<MemberUserModel> authModel = Rxn<MemberUserModel>();
  RxList<SearchUserFriendData> searchFriendData = <SearchUserFriendData>[].obs;
  final ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  final RxSet<String> selectedFriendIds = <String>{}.obs;
  RxBool hasMoreData = false.obs;
  RxBool isFetch = false.obs;
  int page = 1;
  int totalRecord = 0;
  Debouncer debouncer = Debouncer(milliseconds: 700);
  bool isOnceS = false;

  Future<void> getSearchUserData() async {
    final requestData = <String, dynamic>{
      'searchText': searchController.text.trim(),
      'limit': 10,
      'page': page,
    };
    if (page == 1) {
      hasMoreData.value = false;
      isFetch.value = false;
    }

    searchState.value = LoadingState();
    await getIt<MemberService>().searchMemberUserFriend(requestData).handler(
      searchState,
      isLoading: page == 1,
      onSuccess: (value) {
        isOnceS = false;
        final users = value.data?.users;
        hasMoreData.value = false;
        if (value.statusCode == 200 && (value.isSuccess ?? false) && users != null) {
          totalRecord = users.totalRecord ?? 0;
          final data = users.data ?? [];
          if (page == 1) {
            searchFriendData.value = data;
            isFetch.value = true;
          } else {
            searchFriendData.addAll(data);
          }
        }
      },
      onFailed: (value) {
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  bool isFriendSelected(String? friendId) {
    if (friendId == null || friendId.isEmpty) return false;
    return selectedFriendIds.contains(friendId);
  }

  void toggleFriendSelection(String? friendId) {
    if (friendId == null || friendId.isEmpty) return;
    if (selectedFriendIds.contains(friendId)) {
      selectedFriendIds.remove(friendId);
    } else {
      selectedFriendIds.add(friendId);
    }
    selectedFriendIds.refresh();
  }

  Future<void> sendFriendRequests() async {
    if (selectedFriendIds.isEmpty) return;

    final idsToSend = selectedFriendIds.toList();
    addFriendState.value = LoadingState();
    Loading.show();

    var successCount = 0;
    String? lastMessage;

    try {
      for (final receiverId in idsToSend) {
        final requestData = <String, dynamic>{'receiverId': receiverId};
        try {
          final value = await getIt<MemberService>().sendRequest(requestData);
          if (value.statusCode == 200 && (value.isSuccess ?? false)) {
            successCount++;
            lastMessage = value.message;
            searchFriendData.removeWhere((user) => user.sId == receiverId);
            selectedFriendIds.remove(receiverId);
          } else if ((value.message ?? '').isNotEmpty) {
            showError(value.message!);
          }
        } catch (e) {
          showError(e.toString());
        }
      }
    } finally {
      Loading.dismiss();
      addFriendState.value = ApiState.initial();
      selectedFriendIds.refresh();
    }

    if (successCount > 0) {
      showSuccess(
        lastMessage?.isNotEmpty == true
            ? lastMessage!
            : '$successCount friend request(s) sent',
      );
    }
  }

  Future<void> setSearchValue(String value) async {
    page = 1;
    debouncer.run(getSearchUserData);
  }

  void initialLoad() {
    searchController = TextEditingController();
    selectedFriendIds.clear();
    searchFriendData.value = [];
    debouncer = Debouncer(milliseconds: 700);
    hasMoreData.value = false;
    page = 1;
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (totalRecord == searchFriendData.length) {
          return;
        }
        isOnceS = true;
        page++;
        getSearchUserData();
      }
    });
    getSearchUserData();
  }

  void disposeComponent() {
    isOnceS = false;
    hasMoreData.value = false;
    selectedFriendIds.clear();
    searchFriendData.value = [];
    searchController.dispose();
  }
}
