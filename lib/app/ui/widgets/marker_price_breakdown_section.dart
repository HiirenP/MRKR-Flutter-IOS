import 'package:gap/gap.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

/// Shared row styling for all marker payment breakdowns.
class MarkerPriceRow extends StatelessWidget {
  const MarkerPriceRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasis = false,
    this.muted = false,
    this.inline = false,
    this.compact = false,
  });

  final String label;
  final String value;
  final bool emphasis;
  final bool muted;
  /// When true, row shrink-wraps (for use inside horizontal lists / compact rows).
  final bool inline;
  /// Smaller text for inline lists such as wallet / transaction history cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final TextStyle? baseStyle;
    if (compact) {
      baseStyle = emphasis
          ? context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)
          : context.textTheme.bodySmall;
    } else {
      baseStyle = emphasis
          ? context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)
          : context.textTheme.bodyMedium;
    }
    final color = muted
        ? context.colorScheme.secondaryFixedDim
        : context.colorScheme.onSecondary;
    final style = baseStyle?.copyWith(color: color);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 2 : 5),
      child: inline
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(label, style: style),
                const Gap(8),
                AppText(value, style: style),
              ],
            )
          : Row(
              children: [
                Expanded(child: AppText(label, style: style)),
                AppText(value, style: style),
              ],
            ),
    );
  }
}

/// Card section matching marker ticket styling (`secondary` background).
class MarkerPriceBreakdownSection extends StatelessWidget {
  const MarkerPriceBreakdownSection({
    super.key,
    required this.child,
    this.title = 'Payment breakdown',
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const AppEdgeInsets.all16(),
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.onSecondary,
            ),
          ),
          const Gap(4),
          child,
        ],
      ),
    );
  }
}
