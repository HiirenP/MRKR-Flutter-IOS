import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/owner_profile/my_wallet_controller.dart';
import 'package:marker/app/data/models/transaction_history_model/transaction_history_model.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/transaction_price_breakdown.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';

class HistoryPage extends GetItHook<MyWalletController> {
  const HistoryPage({super.key, this.isWithdraw = false, this.isMemberTransaction = false});

  final bool isWithdraw;
  final bool isMemberTransaction;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.withdrawState.value.isLoading && controller.withdrawalHistoryData.isEmpty;
      final isEmpty = !isLoading && controller.withdrawalHistoryData.isEmpty;

      if (isLoading) {
        return const Expanded(child: Center(child: CircularProgressIndicator()));
      }
      if (isEmpty) {
        return Expanded(
          child: EmptyScreen(
            title: isWithdraw ? AppStrings.T.withdrawTitle : AppStrings.T.transactionTitle,
            subTitle: isWithdraw ? AppStrings.T.withdrawSubtitle : AppStrings.T.transactionSubtitle,
          ),
        );
      }
      return Expanded(
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.zero,
          itemCount: controller.withdrawalHistoryData.length + (controller.hasMoreData.value ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index > controller.withdrawalHistoryData.length - 1 && controller.hasMoreData.value) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final list = controller.withdrawalHistoryData[index];
            final showPriceBreakdown = !isWithdraw && list.hasTransactionPriceBreakdown;

            return _WalletHistoryTile(
              transaction: list,
              isWithdraw: isWithdraw,
              isMemberTransaction: isMemberTransaction,
              showPriceBreakdown: showPriceBreakdown,
            );
          },
        ),
      );
    });
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.isDataEmpty.value = false;
    controller.isWithdraw = isWithdraw;
    controller.isMemberTransaction = isMemberTransaction;
    controller.updateInitEntry();
  }

  @override
  void onDispose() {
    controller.isDataEmpty.value = false;
    controller.totalRecord = 0;
    controller.hasMoreData.value = false;
    controller.withdrawalHistoryData.value = [];
    controller.page = 1;
  }
}

class _WalletHistoryTile extends StatefulWidget {
  const _WalletHistoryTile({
    required this.transaction,
    required this.isWithdraw,
    required this.isMemberTransaction,
    required this.showPriceBreakdown,
  });

  final TransactionWithdrawalHistoryListData transaction;
  final bool isWithdraw;
  final bool isMemberTransaction;
  final bool showPriceBreakdown;

  @override
  State<_WalletHistoryTile> createState() => _WalletHistoryTileState();
}

class _WalletHistoryTileState extends State<_WalletHistoryTile> {
  bool _expanded = false;

  String get _title {
    if (widget.isMemberTransaction) {
      return widget.transaction.drinkId?.name ?? '';
    }
    if (!widget.isWithdraw && (widget.transaction.drinkId?.name ?? '').isNotEmpty) {
      return widget.transaction.drinkId!.name!;
    }
    return widget.transaction.userId?.name ?? '';
  }

  String get _leadingImage {
    if (widget.isMemberTransaction) {
      return widget.transaction.drinkId?.image ?? '';
    }
    if (!widget.isWithdraw && (widget.transaction.drinkId?.image ?? '').isNotEmpty) {
      return widget.transaction.drinkId!.image!;
    }
    return widget.transaction.userId?.profile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.transaction;

    return Container(
      margin: const AppEdgeInsets.oB15(),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.colorScheme.secondary,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ImageView(
                  _leadingImage,
                  shape: BoxShape.circle,
                  inner: ImageSize(height: 45, width: 45),
                ),
                title: Padding(
                  padding: EdgeInsets.only(right: widget.showPriceBreakdown ? 28 : 0),
                  child: AppText(
                    _title,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                subtitle: list.createdAt != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isMemberTransaction && (list.barId?.name ?? '').isNotEmpty)
                            AppText(
                              list.barId?.name ?? '',
                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                            ),
                          if (!widget.isWithdraw &&
                              !widget.isMemberTransaction &&
                              (list.userId?.name ?? '').isNotEmpty)
                            AppText(
                              list.userId?.name ?? '',
                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                            ),
                          Row(
                            children: [
                              AppText(
                                '${DateUtil.instance.dateDFormat(list.createdAt ?? ' ')} |',
                                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                              ),
                              AppText(
                                DateUtil.instance.dateDFormat(list.createdAt ?? '', format: DateUtil.instance.hhMMA),
                                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                              ),
                            ],
                          ),
                        ],
                      )
                    : AppText(
                        list.barId?.name ?? '',
                        style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                      ),
                trailing: AppText(
                  AppValidations.getFormattedPrice(list.amount ?? 0),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: widget.isWithdraw || widget.isMemberTransaction
                        ? AppColors.red
                        : context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.showPriceBreakdown && _expanded) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
                  child: TransactionPriceBreakdownView(
                    transaction: list,
                    isMemberTransaction: widget.isMemberTransaction,
                  ),
                ),
              ],
            ],
          ),
          if (widget.showPriceBreakdown)
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _expanded = !_expanded),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 22,
                      color: context.colorScheme.secondaryFixedDim,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
