import 'package:dotted_line/dotted_line.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/data/models/transaction_history_model/transaction_history_model.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown_section.dart';
import 'package:marker/app/ui/widgets/platform_fee_breakdown.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

class WalletServiceChargeBreakdownView extends StatelessWidget {
  const WalletServiceChargeBreakdownView({
    super.key,
    required this.transaction,
    this.compact = false,
  });

  final TransactionWithdrawalHistoryListData transaction;
  final bool compact;

  List<TransactionPlatformFeeItem> get _chargeItems =>
      transaction.serviceChargeBreakdown ?? const [];

  @override
  Widget build(BuildContext context) {
    final net = transaction.amount ?? 0;
    final basePrice = transaction.basePrice ?? 0;
    final tip = transaction.tip ?? 0;
    final showDrinkTip = basePrice > 0;
    final chargeItems = _chargeItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDrinkTip) ...[
          MarkerPriceRow(
            label: 'Drink',
            value: AppValidations.getFormattedPrice(basePrice),
            compact: compact,
          ),
          if (tip > 0)
            MarkerPriceRow(
              label: 'Tip',
              value: AppValidations.getFormattedPrice(tip),
              compact: compact,
            ),
        ],
        ...chargeItems.map(
          (fee) => MarkerPriceRow(
            label: formatTransactionFeeLabel(
              name: fee.name,
              percentage: fee.percentage,
              chargeType: fee.chargeType,
            ),
            value: '-${AppValidations.getFormattedPrice(fee.amount ?? 0)}',
            muted: true,
            compact: compact,
          ),
        ),
        Gap(compact ? 4 : 6),
        DottedLine(dashColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.35)),
        Gap(compact ? 4 : 6),
        MarkerPriceRow(
          label: 'Credited to wallet',
          value: AppValidations.getFormattedPrice(net),
          emphasis: true,
          compact: compact,
        ),
      ],
    );
  }
}
