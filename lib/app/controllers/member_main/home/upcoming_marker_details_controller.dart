import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/pages/owner_main/scan_redeem/owner_drink_list_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@i.lazySingleton
@i.injectable
class UpcomingMarkerDetailsController extends GetxController {
  UpcomingMarkerDetailsController() {
    onInit();
  }

  String? drinkId;
  String? code;
  String type = '';

  final drinksDetailsState = ApiState.initial().obs;
  final qrDetailsState = ApiState.initial().obs;
  final sendRequestState = ApiState.initial().obs;
  final redeemState = ApiState.initial().obs;
  final RxBool isSuccess = false.obs;
  bool onceOpen = false;

  Rx<RedeemedUpcomingListData> drinkData = RedeemedUpcomingListData().obs;

  RxInt secondsRemaining = 120.obs;
  RxString formattedTime = '2:00'.obs;
  Timer? timer;
  RxBool isHideCode = true.obs;
  RxBool isOwnerUpcoming = false.obs;
  RxBool isRedeemed = false.obs;
  final appConstant = AppConstant.instance;
  IO.Socket? socket;
  bool? isConnected;
  String markerId = '';

  void startTimer() {
    AppConstant.instance.isAlreadyIn = false;
    timer?.cancel();
    secondsRemaining.value = 120;
    formattedTime.value = formatTime(secondsRemaining.value);
    AppConstant.instance.isRejected = false;
    AppConstant.instance.isAccepted = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        formattedTime.value = formatTime(secondsRemaining.value);
        if (AppConstant.instance.isRejected) {
          debugPrint('AppConstant.instance.isRejected---->${AppConstant.instance.isRejected}');
          AppConstant.instance.isRejected = false;
          await Future.delayed(const Duration(seconds: 5));
          timer.cancel();
          Get.back();
          Get.back();
        } else if (AppConstant.instance.isAccepted) {
          debugPrint('AppConstant.instance.isAccepted---->${AppConstant.instance.isAccepted}');
          AppConstant.instance.isAccepted = false;
          await Future.delayed(const Duration(seconds: 15));
          timer.cancel();
          Get.back();
          if (markerId.isNotEmpty && !AppConstant.instance.isAlreadyIn) {
            await OwnerDrinkListPage.route(markerId: markerId);
          } else {
            Get.back();
          }
        }
      } else {
        timer.cancel();
        Get.back();
        Get.back();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  void dataGet() {
    socket = appConstant.socket;
    isConnected = socket?.connected;

    if (socket != null && isConnected != null && (isConnected ?? false)) {
      debugPrint('socket--isConnected--$isConnected');
      socketEventOn();
    } else {
      getIt<BaseHomeController>().socketConnectSetup();
      Future.delayed(const Duration(seconds: 5)).then(
        (value) {
          socket = appConstant.socket;
          isConnected = socket?.connected;
          debugPrint('socket--isConnected-again-$isConnected');
          if (isConnected ?? false) {
            socketEventOn();
          }
        },
      );
    }
    if (Get.arguments != null) {
      if (Get.arguments[0] is String) {
        drinkId = Get.arguments[0] as String;
        if (drinkId != null || drinkId!.isNotEmpty) {
          getDrinkDetailsData();
        }
      }
      if (Get.arguments[1] is RedeemedUpcomingListData) {
        drinkData.value = Get.arguments[1] as RedeemedUpcomingListData;
        markerId = drinkData.value.sId ?? '';
        isSuccess.value = true;
      }
      if (Get.arguments[3] is String) {
        type = Get.arguments[3] as String;
      }
      if (Get.arguments[2] is String) {
        code = Get.arguments[2] as String;
        getQrCodeScanData();
      }
      if (Get.arguments[4] is bool) {
        isHideCode.value = Get.arguments[4] as bool;
        debugPrint('isHideCode.value-->${isHideCode.value}');
      }
      if (Get.arguments[5] is bool) {
        isOwnerUpcoming.value = Get.arguments[5] as bool;
        debugPrint('isOwnerUpcoming.value-->${isOwnerUpcoming.value}');
      }
    }
  }

  void socketEventOn() {
    socket!.on(appConstant.onMarkerRedeemed, _handlerMarker);
    socket!.on(appConstant.onMarkerApproved, _handlerMarkerApprove);
    socket!.on(appConstant.onMarkerRejected, _handlerMarkerReject);
  }

  Future<void> _handlerMarker(userData) async {
    debugPrint('handlerMarker-->${jsonEncode(userData)}');
    if (userData is Map<String, dynamic>) {
      final resData = userData['resData'] as Map<String, dynamic>;
      if (resData['status'].toString() == 'true' ||
          resData['status'].toString() == 'success' ||
          resData['status'] == true) {
        // must be check status of marker
        isRedeemed.value = true;
        timer?.cancel();
        Get.back();

        await OwnerDrinkListPage.route(markerId: markerId);
      }
    }
  }

  Future<void> _handlerMarkerApprove(userData) async {
    debugPrint('handlerMarkerApprove-->${jsonEncode(userData)}');
    isRedeemed.value = true;
    timer?.cancel();
    Get.back();
    await Future.delayed(Duration.zero);
    debugPrint('-----IN-New Screen----');
    await OwnerDrinkListPage.route(markerId: markerId);
  }

  Future<void> _handlerMarkerReject(userData) async {
    debugPrint('handlerMarkerReject-->${jsonEncode(userData)}');
    timer?.cancel();
    Get.back();
    Get.back();
  }

  Future<void> getQrCodeScanData() async {
    qrDetailsState.value = ApiState.initial();
    onceOpen = false;
    drinkData.value = RedeemedUpcomingListData();
    final requestData = <String, dynamic>{
      'code': code,
      'type': type,
    };
    await getIt<BarOwnerService>().verifyQRCode(requestData).handler(
      qrDetailsState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data?.marker != null) {
          drinkData.value = value.data!.marker!;
          markerId = drinkData.value.sId ?? '';
          isSuccess.value = true;
        } else {
          Get.back();
          showError(value.message);
        }
      },
      onFailed: (value) {
        if (value.statusCode == 400) {
          final message = value.error.description;
          if (message.contains('redeemed')) {
            getAllReadyRedeemedBottomSheet(value.error.description).then(
              (value) {
                if (value != null && value is bool) {
                  if (value) {
                    Get.back();
                  }
                }
              },
            );
          } else {
            Get.back();
            showError(value.error.description);
          }
        } else if (value.statusCode == 404) {
          Get.back();
          showError(value.error.description);
        } else {
          Get.back();
          showError(value.error.description);
        }
      },
    );
  }

  Future<void> sendRequestData({required String markerID}) async {
    sendRequestState.value = ApiState.initial();
    markerId = markerID;
    final requestData = <String, dynamic>{
      'markerId': markerID,
      'scannedBarId': getIt<SharedPreferences>().getBarId,
      'managerID':getIt<SharedPreferences>().getUserData?.id,
    };
    await getIt<BarOwnerService>().markerRequest(requestData).handler(
      sendRequestState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          // countDownBottomSheet();
          Get.back();
          Get.back();
          showSuccess(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> getRedeemedData() async {
    redeemState.value = ApiState.initial();
    final requestData = <String, dynamic>{
      'markerId': drinkData.value.sId,
    };
    await getIt<BarOwnerService>().redeem(requestData).handler(
      redeemState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          Get.back(result: true);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> getDrinkDetailsData() async {
    drinksDetailsState.value = ApiState.initial();
    drinkData.value = RedeemedUpcomingListData();
    await getIt<MemberService>().getMarkerDetails(drinkId ?? '').handler(
      drinksDetailsState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          isSuccess.value = true;
          drinkData.value = value.data ?? RedeemedUpcomingListData();
          if (drinkData.value.status == 'redeemed') {
            isRedeemed.value = true;
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> getAllReadyRedeemedBottomSheet(String msg) {
    return Get.bottomSheet(
      enableDrag: false,
      AppBottomSheet(
        canPOP: false,
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(
            Assets.svg.drinkGlass,
            color: Get.context!.colorScheme.primary,
          ),
        ),
        title: AppStrings.T.markerRedeemed,
        subTitle: msg,
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: () {
          Get.back(result: true);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void disposeAll() {
    socket?.off(appConstant.onMarkerRedeemed);
    socket?.off(appConstant.onMarkerApproved);
    socket?.off(appConstant.onMarkerRejected);
    drinkData.value = RedeemedUpcomingListData();
    drinkId = '';
    code = '';
    timer?.cancel();
    isSuccess.value = false;
    isRedeemed.value = false;
    isHideCode.value = true;
  }

  Future<dynamic> markerNullBottomSheet(String oBarName, String barName, String drink, String markerID) {
    final oBarName1 = oBarName.capitalize;
    final barName1 = barName.capitalize;

    return Get.bottomSheet(
        AppBottomSheet(
          canPOP: false,
          iconName: Padding(
            padding: const AppEdgeInsets.all12(),
            child: ImageView(
              Assets.svg.drinkGlass,
              color: Get.context!.colorScheme.primary,
            ),
          ),
          title: drink.capitalize,
          subTitle: AppStrings.T.markerBelong(oBarName1!, barName1!),
          positiveButtonTitle: AppStrings.T.yes,
          negativeButtonTitle: AppStrings.T.cancel,
          onPositivePressed: () async {
            Get.back();
            await sendRequestData(markerID: markerID);
          },
          onNegativePressed: () {
            Get.back();
            Get.back();
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
        ),
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false);
  }

  Future<dynamic> countDownBottomSheet() {
    startTimer();
    return Get.bottomSheet(
        AppBottomSheet(
          canPOP: false,
          title: '',
          subTitleObx: formattedTime,
          subTitle: AppStrings.T.pleaseWaitDo,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
        ),
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false);
  }
}
