import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/review_model/review_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class ReviewController extends GetxController {
  ReviewController() {
    onInit();
  }

  final reviewState = ApiState.initial().obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isOnceS = false;
  String barId = '';

  RxList<ReviewListData> reviewList = <ReviewListData>[].obs;

  Future<void> fetchBarReviewList() async {
    if (page == 1) {
      hasMoreData.value = false;
      reviewState.value = LoadingState();
    } else {
      hasMoreData.value = true;
    }

    final requestData = <String, dynamic>{
      'barId': barId,
      'page': page,
      'limit': 10,
    };

    await getIt<MemberService>().reviewList(requestData).handler(
      reviewState,
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
          reviewList.addAll(newItems);

          page++;
          if (totalRecord == reviewList.length) {
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
    reviewList.value = [];
    page = 1;
    fetchBarReviewList();
    scrollController.addListener(() {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        fetchBarReviewList();
      }
    });
  }

  void disposeAll() {
    page = 1;
    hasMoreData = false.obs;
    isDataEmpty = false.obs;
    isEndPage = false.obs;
    reviewList.value = [];
  }
}
