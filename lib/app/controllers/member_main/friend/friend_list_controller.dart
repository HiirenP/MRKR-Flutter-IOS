import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/debouncer.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';

@i.lazySingleton
@i.injectable
class FriendListController extends GetxController {
  FriendListController() {
    onInit();
  }

  /*
  * ----- Start Use for send marker to friend -----
  * */
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxInt selectedIndex = (-1).obs;
  RedeemedUpcomingListData? modelMarker;

  /*
  * ----- Stop Use for send marker to friend -----
  * */

  final ScrollController scrollController = ScrollController();
  final friendListState = ApiState.initial().obs;
  RxList<SearchUserFriendData> listFriends = <SearchUserFriendData>[].obs;
  RxInt totalFriends = 0.obs;
  int page = 1;
  RxBool hasMoreData = false.obs;
  RxBool isFetch = false.obs;
  Debouncer debouncer = Debouncer(milliseconds: 700);
  bool isOnceS = false;

  Future<void> getFriendListData() async {
    final requestData = <String, dynamic>{
      'limit': 10,
      'page': page,
      'searchText': searchController.text.trim(),
    };
    if (page == 1) {
      hasMoreData.value = false;
      isFetch.value = false;
    }
    friendListState.value = LoadingState();
    await getIt<MemberService>().friendsList(requestData).handler(
      friendListState,
      isLoading: true,
      onSuccess: (value) {
        isOnceS = false;
        if (value.statusCode == 200 && (value.isSuccess ?? false) && value.data != null) {
          final temp = value.data;
          final listTemp = temp?.data ?? [];
          totalFriends.value = temp?.totalRecord ?? 0;
          isFetch.value = true;
          if (listTemp.isNotEmpty) {
            if (page == 1) {
              listFriends.value = listTemp;
            } else {
              listFriends.addAll(listTemp);
            }
            listFriends.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
          }
        }
      },
      onFailed: (value) {
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> deleteFriendBottomSheet() async {
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(Assets.svg.trash),
        ),
        title: AppStrings.T.deleteFriend,
        subTitle: AppStrings.T.areYouSureFriend,
        positiveButtonTitle: AppStrings.T.yes,
        negativeButtonTitle: AppStrings.T.cancel,
        onNegativePressed: Get.back,
        onPositivePressed: () {
          Get.back(result: true);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<void> deleteFriendAPI(int index) async {
    final friendId = listFriends[index].friendId ?? '';

    friendListState.value = LoadingState();
    await getIt<MemberService>().deleteFriend(friendId).handler(
      friendListState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && (value.isSuccess ?? false)) {
          listFriends.removeAt(index);
          final message = value.message ?? '';
          if (message.isNotEmpty) {
            showSuccess(message);
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void onSearchFriend(String value) {
    page = 1;
    isOnceS = false;
    hasMoreData.value = false;
    debouncer.run(getFriendListData);
  }

  void onInitialize() {
    if (Get.arguments != null && Get.arguments is RedeemedUpcomingListData) {
      modelMarker = Get.arguments as RedeemedUpcomingListData;
    }
    debouncer = Debouncer(milliseconds: 700);
    hasMoreData.value = false;
    page = 1;
    searchController.clear();
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

  void onDismiss() {
    searchController.clear();
    searchFocusNode.unfocus();
    selectedIndex.value = -1;
  }
}
