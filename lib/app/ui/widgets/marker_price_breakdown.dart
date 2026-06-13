import 'package:dotted_line/dotted_line.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown_section.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

/// Drink + tip rows for bar-owner marker views.
class BarMarkerPriceBreakdownView extends StatelessWidget {
  const BarMarkerPriceBreakdownView({
    super.key,
    required this.basePrice,
    required this.tip,
    this.compact = false,
  });

  final num basePrice;
  final num tip;
  final bool compact;

  num get markerTotal => basePrice + tip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: compact ? CrossAxisAlignment.end : CrossAxisAlignment.stretch,
      children: [
        MarkerPriceRow(
          label: 'Drink',
          value: AppValidations.getFormattedPrice(basePrice),
          inline: compact,
          compact: compact,
        ),
        MarkerPriceRow(
          label: 'Tip',
          value: AppValidations.getFormattedPrice(tip),
          inline: compact,
          compact: compact,
        ),
        if (!compact) ...[
          Gap(6),
          DottedLine(dashColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.35)),
          Gap(6),
          MarkerPriceRow(
            label: 'Marker total',
            value: AppValidations.getFormattedPrice(markerTotal),
            emphasis: true,
            compact: compact,
          ),
        ],
      ],
    );
  }
}

extension MarkerPriceDisplay on RedeemedUpcomingListData {
  num get resolvedBasePrice {
    if (basePrice != null && basePrice! > 0) return basePrice!;
    final total = totalAmount ?? 0;
    final t = tip ?? 0;
    if (total > t) return total - t;
    return total;
  }

  num get resolvedTip => tip ?? 0;

  num get barMarkerTotal => totalAmount ?? (resolvedBasePrice + resolvedTip);

  num get memberSpendTotal {
    if (amountPaid != null && amountPaid! > 0) return amountPaid!;
    final fees = platformFeesTotal ?? 0;
    return resolvedBasePrice + fees + resolvedTip;
  }
}
