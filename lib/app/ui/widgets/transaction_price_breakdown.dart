import 'package:flutter/material.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/models/transaction_history_model/transaction_history_model.dart';
import 'package:marker/app/ui/widgets/platform_fee_breakdown.dart';
import 'package:marker/app/ui/widgets/wallet_service_charge_breakdown.dart';

class TransactionPriceBreakdownView extends StatelessWidget {
  const TransactionPriceBreakdownView({
    super.key,
    required this.transaction,
    required this.isMemberTransaction,
  });

  final TransactionWithdrawalHistoryListData transaction;
  final bool isMemberTransaction;

  @override
  Widget build(BuildContext context) {
    if (isMemberTransaction) {
      final breakdown = (transaction.platformFeeBreakdown ?? [])
          .map(
            (fee) => PlatformFeeBreakdownItem(
              name: fee.name,
              percentage: fee.percentage,
              amount: fee.amount,
              chargeType: fee.chargeType,
            ),
          )
          .toList();

      return PlatformFeeBreakdownView(
        basePrice: transaction.resolvedBasePrice,
        tip: transaction.resolvedTip,
        breakdown: breakdown,
        platformFeesTotal: transaction.platformFeesTotal ?? 0,
        amountPaid: transaction.resolvedAmountPaid,
        compact: true,
      );
    }

    return WalletServiceChargeBreakdownView(
      transaction: transaction,
      compact: true,
    );
  }
}
