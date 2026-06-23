import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:gap/gap.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/controllers/member_main/friend/friend_list_controller.dart';
import 'package:marker/app/controllers/member_main/home/strip_terminal_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/payment_service/payment_service.dart';
import 'package:marker/app/ui/widgets/platform_fee_breakdown.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/pages/member_main/home/send_to_page.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart';
import 'package:marker/app/ui/pages/member_main/message/chat_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/json_num_util.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@i.lazySingleton
@i.injectable
class PaymentsController extends GetxController {
  PaymentsController() {
    onInit();
  }

  final appConstant = AppConstant.instance;
  IO.Socket? socket;
  final payState = ApiState.initial().obs;

  TextEditingController holderNameEditingController = TextEditingController();
  TextEditingController cardNumberEditingController = TextEditingController();
  TextEditingController cvvEditingController = TextEditingController();
  TextEditingController mmEditingController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  String tip = '';
  String barId = '';
  String drinkId = '';
  String userId = '';
  String transactionId = '';
  num price = 0;
  num platformFeesTotal = 0;
  List<PlatformFeeBreakdownItem> platformFeeBreakdown = [];
  bool isFriend = false;
  Future<void>? _platformFeesRefreshFuture;

  Future<void> refreshPlatformFees() async {
    if (price <= 0) return;
    _platformFeesRefreshFuture ??= _fetchPlatformFees();
    try {
      await _platformFeesRefreshFuture;
    } finally {
      _platformFeesRefreshFuture = null;
    }
  }

  Future<void> _fetchPlatformFees() async {
    try {
      final response = await getIt<PaymentService>().memberPlatformFeePreview(price.toString());
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return;
      platformFeesTotal = readJsonNumOrZero(data['platformFeesTotal']);
      platformFeeBreakdown = (data['breakdown'] as List<dynamic>? ?? [])
          .map((e) => PlatformFeeBreakdownItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('refreshPlatformFees error: $e');
    }
  }

  Future<dynamic> payBottomSheet() async {
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all10(),
          child: ImageView(Assets.svg.cardTick),
        ),
        title: AppStrings.T.paymentDone,
        subTitle: AppStrings.T.yourPayment,
        positiveButtonTitle: AppStrings.T.sendMarker,
        onPositivePressed: () {
          Get.back(result: 'send');
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<void> paymentInit() async {
    isFriend = false;
    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
        final dats = Get.arguments as Map<String, dynamic>;
        barId = dats['barId'] as String;
        drinkId = dats['drinkId'] as String;
        price = dats['price'] as num;
        tip = dats['tip'] as String;
        platformFeesTotal = readJsonNumOrZero(dats['platformFeesTotal']);
        if (dats['platformFeeBreakdown'] is List) {
          platformFeeBreakdown = (dats['platformFeeBreakdown'] as List)
              .map((e) => e is PlatformFeeBreakdownItem
                  ? e
                  : PlatformFeeBreakdownItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (dats.containsKey('isFriend')) {
          isFriend = dats['isFriend'] as bool;
        }
      }
    }
    await refreshPlatformFees();

    StripTerminalController.tip = tip;
    StripTerminalController.barId = barId;
    StripTerminalController.drinkId = drinkId;
    StripTerminalController.price = price;

    userId = getIt<SharedPreferences>().getUserId ?? '';
    socket = appConstant.socket;
    final isConnected = socket?.connected;
    debugPrint('payment-screen-isConnected-->$isConnected');
    if (socket != null && isConnected != null && isConnected) {
      socketOnEvent();
    } else {
      getIt<BaseHomeController>().socketConnectSetup();
      Future.delayed(const Duration(seconds: 5)).then(
        (value) {
          socket = appConstant.socket;
          final isConnected = socket?.connected;
          debugPrint('payment-screen-isConnected-again-$isConnected');
          if (isConnected ?? false) {
            socketOnEvent();
          }
        },
      );
    }
  }

  Future<void> paymentData() async {
    await getIt<MemberService>()
        .createPaymentLink(
      barId: barId,
      drinkId: drinkId,
      basePrice: price.toString(),
      tip: tip,
      hasTip: (tip.isEmpty || tip.trim() == '0') ? 'false' : 'true',
    )
        .handler(
      payState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          PrivacyPolicyPage.route(
            AppStrings.T.payment,
            url: value.data?.callback,
            fullScreenWebView: true,
          );
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void socketOnEvent() {
    socket!.on(appConstant.onPaymentDone, _handlerPayment);
  }

  Future<void> _handlerPayment(userData) async {
    log('handlerPayment-->$userData');
    Loading.show();
    await Future.delayed(const Duration(seconds: 2));
    Loading.dismiss();
    if (userData is Map<String, dynamic>) {
      final resData = userData['resData'] as Map<String, dynamic>;
      if (resData.isNotEmpty && (resData['success'] == 'true' || resData['status'] == 'success')) {
        final marker = resData['marker'];
        if (marker != null) {
          final model = RedeemedUpcomingListData.fromJson(marker as Map<String, dynamic>);
          final value = await payBottomSheet();
          debugPrint('value-dialog-back->$value');
          if (value != null) {
            if (value is String) {
              if (value == 'send') {
                debugPrint('value-dialog-back->$isFriend');
                if (isFriend) {
                  final controller = getIt<FriendListController>();
                  final list = controller.listFriends;
                  debugPrint('selectedIndex-back->${controller.selectedIndex.value}');
                  debugPrint('selectedIndex-back->${list.length}');

                  if (list.isNotEmpty && controller.selectedIndex.value != -1) {
                    final modelFriend = list[controller.selectedIndex.value];
                    final modelChat = ChatDataModel.fromJson({
                      'user_detail': jsonDecode(jsonEncode(modelFriend)),
                      'lastMessage': {'markerId': jsonDecode(jsonEncode(model))},
                      'sendMarker': true
                    });
                    await ChatPage.route(modelChat);
                  }
                } else {
                  await SendToPage.route(model: model);
                }
              }
            }
          } else {
            Get.back(result: true);
          }
        }
      }
    }
  }

  void paymentDismiss() {
    tip = '';
    barId = '';
    drinkId = '';
    userId = '';
    transactionId = '';
    price = 0;
    platformFeesTotal = 0;
    platformFeeBreakdown = [];
    _platformFeesRefreshFuture = null;
    socket?.off(appConstant.onPaymentDone);
  }

  Future<dynamic> infoSheet({required BuildContext context, bool nfcPayment = false}) async {
    var tempTip = tip;
    if (tempTip.isEmpty) {
      tempTip = '0';
    }

    Loading.show();
    try {
      await refreshPlatformFees();
    } finally {
      Loading.dismiss();
    }

    return Get.bottomSheet(
      AppBottomSheet(
        title: AppStrings.T.paymentSummary,
        positiveButtonTitle: AppStrings.T.ok,
        negativeButtonTitle: AppStrings.T.no,
        content: PlatformFeeBreakdownView(
          basePrice: price,
          tip: num.tryParse(tempTip) ?? 0,
          breakdown: platformFeeBreakdown,
          platformFeesTotal: platformFeesTotal,
        ),
        onPositivePressed: () async {
          Get.back();
          if (nfcPayment) {
            final prefs = getIt<SharedPreferences>();
            var isTapToPayEnabled = prefs.getTapToPayEnabled;
            if (!isTapToPayEnabled && Platform.isIOS) {
              final enabledResult = await TapToPayEnablePage.route<bool>();
              await prefs.reload();
              isTapToPayEnabled = prefs.getTapToPayEnabled;

              if (enabledResult != true && !isTapToPayEnabled) {
                return;
              }
            }

            Loading.show();
            await StripTerminalController.initTerminal();
          } else {
            await paymentData();
          }
        },
        onNegativePressed: () async {
          Get.back();
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
