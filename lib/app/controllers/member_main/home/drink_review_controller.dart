import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';

@i.lazySingleton
@i.injectable
class DrinkReviewController extends GetxController {
  DrinkReviewController() {
    onInit();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController writeReviewController = TextEditingController();

  final upcomingState = ApiState.initial().obs;

  int page = 1;
  String drinkId = '';
  String barId = '';
  String transactionId = '';
  RxString barName = ''.obs;
  RxString drinkName = ''.obs;
  RxDouble stars = 5.0.obs;
  RxBool isBarReview = false.obs;
  RxBool hasExistingReview = false.obs;
  RxBool isLoadingReview = false.obs;
  bool fromMarkerRedeemed = false;

  void applyExistingReview({String? reviewId, String? review, num? reviewStars}) {
    if (reviewId != null && reviewId.isNotEmpty) {
      hasExistingReview.value = true;
      writeReviewController.text = review ?? '';
      stars.value = (reviewStars ?? 5).toDouble();
    }
  }

  Future<void> loadMyBarReview({String? reviewId, String? review, num? reviewStars}) async {
    if (barId.isEmpty || !isBarReview.value) {
      return;
    }
    if (reviewId != null && reviewId.isNotEmpty) {
      applyExistingReview(reviewId: reviewId, review: review, reviewStars: reviewStars);
      return;
    }
    isLoadingReview.value = true;
    await getIt<MemberService>().getMyBarReview({'barId': barId}).handler(
      upcomingState,
      isLoading: false,
      onSuccess: (value) {
        final data = value.data;
        if (value.statusCode == 200 && data?.sId != null && data!.sId!.isNotEmpty) {
          applyExistingReview(reviewId: data.sId, review: data.review, reviewStars: data.stars);
        } else {
          hasExistingReview.value = false;
          writeReviewController.clear();
          stars.value = 5.0;
        }
      },
      onFailed: (_) {
        hasExistingReview.value = false;
      },
    );
    isLoadingReview.value = false;
  }

  Future<void> loadMyDrinkReview({String? reviewId, String? review, num? reviewStars}) async {
    if (drinkId.isEmpty || isBarReview.value) {
      return;
    }
    if (reviewId != null && reviewId.isNotEmpty) {
      applyExistingReview(reviewId: reviewId, review: review, reviewStars: reviewStars);
      return;
    }
    isLoadingReview.value = true;
    await getIt<MemberService>().getMyBarReview({'drinkId': drinkId}).handler(
      upcomingState,
      isLoading: false,
      onSuccess: (value) {
        final data = value.data;
        if (value.statusCode == 200 && data?.sId != null && data!.sId!.isNotEmpty) {
          applyExistingReview(reviewId: data.sId, review: data.review, reviewStars: data.stars);
        } else {
          hasExistingReview.value = false;
          writeReviewController.clear();
          stars.value = 5.0;
        }
      },
      onFailed: (_) {
        hasExistingReview.value = false;
      },
    );
    isLoadingReview.value = false;
  }

  Future<void> drinkReview() async {
    debugPrint('Review.stars--->${stars.value}');
    if (!formKey.currentState!.validate()) {
      return;
    }

    final requestData = <String, dynamic>{
      'review': writeReviewController.text.trim(),
      'stars': stars.value,
    };
    if (isBarReview.value) {
      requestData.putIfAbsent('barId', () => barId);
    } else {
      requestData.putIfAbsent('drinkId', () => drinkId);
    }

    upcomingState.value = LoadingState();

    await getIt<MemberService>().barReviewSubmit(requestData).handler(
      upcomingState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          if (isBarReview.value) {
            hasExistingReview.value = true;
            if (value.data?.sId != null && value.data!.sId!.isNotEmpty) {
              applyExistingReview(
                reviewId: value.data!.sId,
                review: writeReviewController.text.trim(),
                reviewStars: stars.value,
              );
            }
            shareBottomSheet();
          } else {
            hasExistingReview.value = true;
            if (value.data?.sId != null && value.data!.sId!.isNotEmpty) {
              applyExistingReview(
                reviewId: value.data!.sId,
                review: writeReviewController.text.trim(),
                reviewStars: stars.value,
              );
            }
            if (fromMarkerRedeemed) {
              isBarReview.value = true;
              hasExistingReview.value = false;
              writeReviewController.clear();
              stars.value = 5.0;
              loadMyBarReview();
            } else {
              drinkShareBottomSheet();
            }
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> shareBottomSheet() async {
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const EdgeInsets.all(8),
          child: ImageView(Assets.svg.allDone),
        ),
        title: AppStrings.T.allDone,
        subTitle: AppStrings.T.thankYouSubmitting,
        positiveButtonTitle: AppStrings.T.share,
        negativeButtonTitle: AppStrings.T.cancel,
        onNegativePressed: () {
          Get.back();
          Get.back(result: true);
        },
        onPositivePressed: () {
          final message = AppStrings.T.shareBarMessage(barName.value);
          shareMessage(message: message);
          Get.back(result: true);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<dynamic> drinkShareBottomSheet() async {
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const EdgeInsets.all(8),
          child: ImageView(Assets.svg.allDone),
        ),
        title: AppStrings.T.allDone,
        subTitle: AppStrings.T.thankYouSubmitting,
        positiveButtonTitle: AppStrings.T.share,
        negativeButtonTitle: AppStrings.T.cancel,
        onNegativePressed: () {
          Get.back();
          Get.back(result: true);
        },
        onPositivePressed: () {
          final message = AppStrings.T.shareDrinkBarMessage(drinkName.value, barName.value);
          shareMessage(message: message);
          Get.back(result: true);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void disposeAll() {
    page = 1;
    drinkId = '';
    barId = '';
    transactionId = '';
    barName.value = '';
    drinkName.value = '';
    writeReviewController.clear();
    isBarReview.value = false;
    hasExistingReview.value = false;
    isLoadingReview.value = false;
    fromMarkerRedeemed = false;
    stars.value = 5.0;
  }

  void clearFormOnly() {
    writeReviewController.clear();
    isLoadingReview.value = false;
    hasExistingReview.value = false;
    stars.value = 5.0;
  }
}
