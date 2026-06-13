import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/search_drinks_model/search_drinks_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/data/services/payment_service/payment_service.dart';
import 'package:marker/app/ui/pages/member_main/home/payment_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/gen/assets.gen.dart';

@i.lazySingleton
@i.injectable
class DrinkDetailsController extends GetxController {
  DrinkDetailsController() {
    onInit();
  }

  final drinksDetailsState = ApiState.initial().obs;
  Rx<DrinkDetailsData> drinkData = DrinkDetailsData().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DrinkDetailsData? get drink => drinkData.value;
  String drinkId = '';
  RxBool isShow = false.obs;
  RxBool isDataFound = false.obs;
  bool isFriend = false;
  RxString barName = ''.obs;
  RxString barImage = ''.obs;
  bool isGoBack = false;
  TextEditingController enterAmountController = TextEditingController();
  RxList<PlatformFeeBreakdownItem> platformFeeBreakdown = <PlatformFeeBreakdownItem>[].obs;
  Rx<num> platformFeesTotal = 0.obs;

  Future<void> getDrinkDetailsData() async {
    isDataFound.value = false;
    final requestData = <String, dynamic>{};
    await getIt<BarOwnerService>().getDrinksDetails(drinkId, requestData).handler(
      drinksDetailsState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          isDataFound.value = true;
          drinkData.value = value.data ?? DrinkDetailsData();
          loadPlatformFees();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
        isDataFound.value = false;
      },
    );
  }

  void onShareTap() {
    var message = AppStrings.T.shareBarMessage(barName.value);
    final link = drinkData.value.shareableLink;
    if (link != null) {
      message = '$message\n$link';
    }
    debugPrint('message--->$message');
    shareMessage(message: message);
  }

  Future<void> onButtonTap() async {
    await tipBottomSheet();
  }

  Future<void> loadPlatformFees() async {
    final drinkPrice = num.tryParse('${drinkData.value.price ?? 0}') ?? 0;
    try {
      final response = await getIt<PaymentService>().memberPlatformFeePreview(drinkPrice.toString());
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return;
      platformFeesTotal.value = (data['platformFeesTotal'] as num?) ?? 0;
      final breakdown = (data['breakdown'] as List<dynamic>? ?? [])
          .map((e) => PlatformFeeBreakdownItem.fromJson(e as Map<String, dynamic>))
          .toList();
      platformFeeBreakdown.value = breakdown;
    } catch (e) {
      debugPrint('loadPlatformFees error: $e');
      platformFeesTotal.value = 0;
      platformFeeBreakdown.clear();
    }
  }

  Future<void> onNext({String price = '0'}) async {
    final map = {
      'barId': drinkData.value.barId,
      'price': drinkData.value.price,
      'drinkId': drinkId,
      'tip': price,
      'isFriend': isFriend,
      'platformFeesTotal': platformFeesTotal.value,
      'platformFeeBreakdown': platformFeeBreakdown.toList(),
    };
    await PaymentPage.route(tip: map)?.then(
      (value) {
        isGoBack = true;
        if (value != null && value is bool && value) {
          Get.back(result: value);
        }
      },
    );
  }

  Future<dynamic> tipBottomSheet() async {
    enterAmountController.text = '';
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all10(),
          child: ImageView(Assets.svg.tip),
        ),
        title: AppStrings.T.tip,
        subTitle: AppStrings.T.wouldTip,
        positiveButtonTitle: AppStrings.T.yes,
        negativeButtonTitle: AppStrings.T.no,
        onPositivePressed: () async {
          Get.back();
          enterAmountController.text = '';
          await amountBottomSheet();
        },
        onNegativePressed: () async {
          Get.back();
          await onNext();
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<dynamic> amountBottomSheet() async {
    enterAmountController.text = '';
    final context = Get.context!;
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      AnimatedPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Form(
          key: formKey,
          child: AppBottomSheet(
            title: AppStrings.T.tipAmount('').split(':').firstOrNull,
            isDivider: true,
            content: TextInputField(
              type: InputType.decimalDigits,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              controller: enterAmountController,
              hintLabel: AppStrings.T.enterTipAmount,
              context: context,
              validator: AppValidations.amountValidation,
              prefixIcon: ImageView(Assets.svg.moneys),
            ),
            positiveButtonTitle: AppStrings.T.add,
            onPositivePressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }
              Get.back();
              await onNext(price: enterAmountController.text.trim());
            },
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void initData() {
    isFriend = false;
    isGoBack = false;
    if (Get.arguments != null) {
      if (Get.arguments[0] is String) {
        drinkId = Get.arguments[0] as String;
      }
      if (Get.arguments[1] is bool) {
        isShow.value = Get.arguments[1] as bool;
      }
      if (Get.arguments[2] is SearchDrinksList) {
        final drinkData = Get.arguments[2] as SearchDrinksList;
        drinkId = drinkData.sId ?? '';
        barName.value = drinkData.bar?.name ?? '';
        barImage.value = drinkData.bar?.logo ?? '';
      }
      if (Get.arguments[3] is bool) {
        isFriend = Get.arguments[3] as bool;
        debugPrint('controller.isFriend-drink-info->$isFriend');
      }
      getDrinkDetailsData();
    }
  }

  void disposeAll() {
    drinkId = '';
    isGoBack = false;
    isDataFound.value = false;
    drinkData.value = DrinkDetailsData();
    platformFeeBreakdown.clear();
    platformFeesTotal.value = 0;
  }
}
