import 'package:dotted_line/dotted_line.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown_section.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

String formatTransactionFeeLabel({
  String? name,
  num? percentage,
  String? chargeType,
}) {
  final feeName = (name ?? '').trim().isEmpty ? 'Fee' : name!.trim();
  if (chargeType == 'fixed') return feeName;
  if (chargeType == 'variable' && percentage != null) return '$feeName ($percentage%)';
  if (percentage != null && percentage > 0) return '$feeName ($percentage%)';
  return feeName;
}

String _feeLabel(PlatformFeeBreakdownItem fee) {
  return formatTransactionFeeLabel(
    name: fee.name,
    percentage: fee.percentage,
    chargeType: fee.chargeType,
  );
}

class PlatformFeeBreakdownView extends StatelessWidget {
  const PlatformFeeBreakdownView({
    super.key,
    required this.basePrice,
    required this.tip,
    required this.breakdown,
    required this.platformFeesTotal,
    this.amountPaid,
    this.compact = false,
  });

  final num basePrice;
  final num tip;
  final List<PlatformFeeBreakdownItem> breakdown;
  final num platformFeesTotal;
  final num? amountPaid;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final total = (amountPaid != null && amountPaid! > 0)
        ? amountPaid!
        : basePrice + platformFeesTotal + tip;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarkerPriceRow(
          label: 'Drink',
          value: AppValidations.getFormattedPrice(basePrice),
          compact: compact,
        ),
        ...breakdown.map(
          (fee) => MarkerPriceRow(
            label: _feeLabel(fee),
            value: AppValidations.getFormattedPrice(fee.amount ?? 0),
            muted: true,
            compact: compact,
          ),
        ),
        if (breakdown.isEmpty && platformFeesTotal > 0)
          MarkerPriceRow(
            label: 'Platform fees',
            value: AppValidations.getFormattedPrice(platformFeesTotal),
            muted: true,
            compact: compact,
          ),
        if (tip > 0)
          MarkerPriceRow(
            label: 'Tip',
            value: AppValidations.getFormattedPrice(tip),
            compact: compact,
          ),
        Gap(compact ? 4 : 6),
        DottedLine(dashColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.35)),
        Gap(compact ? 4 : 6),
        MarkerPriceRow(
          label: 'Total paid',
          value: AppValidations.getFormattedPrice(total),
          emphasis: true,
          compact: compact,
        ),
      ],
    );
  }
}
