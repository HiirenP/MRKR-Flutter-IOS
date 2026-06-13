import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_text.dart' show AppText;
import 'package:marker/app/utils/constants/app_edge_insets.dart' show AppEdgeInsets;
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    this.onChanged,
    this.hintText,
    this.list,
    this.idDecoration = false,
    required this.selectedValue,
  });

  final List<String>? list;
  final ValueChanged<String?>? onChanged; // Change to String? instead of String
  final RxString? selectedValue;
  final bool idDecoration;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const AppEdgeInsets.hv105(),
      margin: const EdgeInsets.only(left: 30),
      decoration: idDecoration
          ? const BoxDecoration()
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.colorScheme.secondary,
              border: Border.all(
                color: context.colorScheme.secondaryFixedDim.withAlpha(35),
              ),
            ),
      child: DropdownButton<String?>(
        items: list!
            .map(
              (list) => DropdownMenuItem<String?>(
                value: list,
                child: AppText(
                  list,
                  style: idDecoration
                      ? context.textTheme.labelMedium?.copyWith(
                          color: context.colorScheme.secondaryFixedDim,
                        )
                      : context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.secondaryFixedDim,
                        ),
                ),
              ),
            )
            .toList(),
        isDense: true,
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        underline: const SizedBox.shrink(),
        hint: AppText(
          selectedValue?.value ?? '',
          style: idDecoration
              ? context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.secondaryFixedDim,
                )
              : context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.secondaryFixedDim,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        dropdownColor: context.colorScheme.onPrimary,
        onChanged: onChanged,
        // Now accepts String? instead of String
        style: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: context.colorScheme.secondaryFixedDim,
        ),
      ),
    );
  }
}
