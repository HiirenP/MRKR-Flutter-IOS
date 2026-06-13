import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/transaction_history_model/transaction_history_model.dart';
import 'package:marker/app/data/services/payment_service/payment_service.dart';
import 'package:marker/app/ui/pages/authentication/owner/add_bank_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/bank_details_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/edit_bank_details_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class MyWalletController extends GetxController {
  MyWalletController() {
    onInit();
  }

  final withdrawState = ApiState.initial().obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  RxBool hasMoreData = true.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  RxList<TransactionWithdrawalHistoryListData> withdrawalHistoryData = <TransactionWithdrawalHistoryListData>[].obs;
  int totalRecord = 0;
  Rx<num> walletAmount = 0.0.obs;
  bool isOnceS = false;
  bool isWithdraw = false;
  bool isMemberTransaction = false;
  bool _scrollListenerAttached = false;
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> withdrawalMoney() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    withdrawState.value = LoadingState();

    final requestData = <String, dynamic>{'amount': num.parse(amountController.text.trim())};
    await getIt<PaymentService>().withdrawalMoney(requestData).handler(
      withdrawState,
      onSuccess: (value) {
        amountController.text = '';
        if (value.statusCode == 200 && value.data != null) {
          Get.back();
          showSuccess(value.message);
          walletAmount.value = value.data?.remaingAmount ?? 0.0;
          updateInitEntry();
        } else {
          showError(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
        if (page == 1) {
          isDataEmpty.value = true;
        }
      },
    );
  }

  void updateInitEntry() {
    isEndPage.value = false;
    withdrawalHistoryData.value = [];
    page = 1;
    isOnceS = false;
    isWithdraw
        ? getWithdrawHistoryData()
        : isMemberTransaction
            ? getMemberTransactionDataHistoryData()
            : getTransactionDataHistoryData();
    if (!_scrollListenerAttached) {
      _scrollListenerAttached = true;
      scrollController.addListener(() {
        if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (isEndPage.value) {
            return;
          }
          isOnceS = true;
          isWithdraw
              ? getWithdrawHistoryData()
              : isMemberTransaction
                  ? getMemberTransactionDataHistoryData()
                  : getTransactionDataHistoryData();
        }
      });
    }
  }

  Future<void> getWithdrawHistoryData() async {
    hasMoreData.value = false;
    withdrawState.value = LoadingState();
    final requestData = <String, dynamic>{
      'page': page,
      'limit': 10,
    };
    if (page != 1) {
      hasMoreData.value = true;
    }

    await getIt<PaymentService>().withdrawalHistory(requestData).handler(
      withdrawState,
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
          withdrawalHistoryData.addAll(newItems);
          page++;
          if (totalRecord == withdrawalHistoryData.length) {
            isEndPage.value = true;
          }
        }
      },
      onFailed: (value) {
        isDataEmpty.value = false;
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  Future<void> getTransactionDataHistoryData() async {
    if (page == 1) {
      hasMoreData.value = false;
      withdrawState.value = LoadingState();
    }
    final requestData = <String, dynamic>{
      'page': page,
      'limit': 10,
    };

    await getIt<PaymentService>().wallet(requestData).handler(
      withdrawState,
      isLoading: page == 1,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          walletAmount.value = (value.data?.wallet ?? 0).toDouble();

          final newItems = value.data?.data ?? [];
          if (newItems.isEmpty && page == 1) {
            isDataEmpty.value = true;
          }
          if (page != 1) {
            hasMoreData.value = false;
          }
          final totalRecord = value.data?.totalRecord ?? 0;
          withdrawalHistoryData.addAll(newItems);
          page++;
          if (totalRecord == withdrawalHistoryData.length) {
            isEndPage.value = true;
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
        if (page == 1) {
          isDataEmpty.value = true;
        }
      },
    );
  }

  Future<void> getMemberTransactionDataHistoryData() async {
    if (page == 1) {
      hasMoreData.value = false;
      withdrawState.value = LoadingState();
      withdrawalHistoryData.clear();
      isDataEmpty.value = false;
      isEndPage.value = false;
    } else {
      hasMoreData.value = true;
    }
    final requestData = <String, dynamic>{
      'page': page,
      'limit': 10,
    };

    await getIt<PaymentService>().transactionHistory(requestData).handler(
      withdrawState,
      isLoading: page == 1,
      onSuccess: (value) {
        isOnceS = false;
        if (value.statusCode == 200 && value.data != null) {
          walletAmount.value = (value.data?.wallet ?? 0).toDouble();
          final newItems = value.data?.data ?? [];
          if (newItems.isEmpty && page == 1) {
            isDataEmpty.value = true;
          } else {
            isDataEmpty.value = false;
          }
          if (page != 1) {
            hasMoreData.value = false;
          }
          final totalRecord = value.data?.totalRecord ?? 0;
          withdrawalHistoryData.addAll(newItems);
          if (withdrawalHistoryData.length < totalRecord) {
            page++;
          } else {
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

  Future<dynamic> withdrawBottomSheet() async {
    if((getIt<SharedPreferences>().getUserData?.isBankAdded == null || getIt<SharedPreferences>().getUserData!.isBankAdded!.isEmpty) && AppConstant.userType == UserType.owner){

      AddBankPage.goRoute(true)!.then((val){
        if(val!=null){
          withdrawBottomSheet();
          return;
        }
      });


      return;

    }
    else if (walletAmount.value <= 0) {
      showError(AppStrings.T.inefficientBalance);
      return;
    }
    amountController.text = '';
    final context = Get.context!;
    return Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      AnimatedPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AppBottomSheet(
        title: AppStrings.T.withdraw,
        content: Form(
          key: formKey,
          child: Column(
            children: [
              Divider(
                color: context.colorScheme.secondary,
              ),
              Padding(
                padding: const AppEdgeInsets.v16(),
                child: TextInputField(
                  controller: amountController,
                  hintLabel: AppStrings.T.enterAmount,
                  context: context,
                  validator: AppValidations.amountValidation,
                  type: InputType.decimalDigits,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: ImageView(Assets.svg.moneys),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
        positiveButtonTitle: AppStrings.T.sendRequest,
        onPositivePressed: withdrawalMoney,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
