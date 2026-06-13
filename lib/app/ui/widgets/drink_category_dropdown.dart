import 'package:flutter/material.dart';
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

/// Same visual language as [TextInputField] and add-drink category field.
class DrinkCategoryDropdown extends StatelessWidget {
  const DrinkCategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onChanged,
    this.hint = 'Select category',
    this.includeAllOption = false,
    this.allOptionLabel = 'All categories',
  });

  final List<DrinkCategoryData> categories;
  final String selectedId;
  final ValueChanged<String> onChanged;
  final String hint;
  final bool includeAllOption;
  final String allOptionLabel;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final fieldTextStyle = context.textTheme.labelMedium;
    final hintStyle = fieldTextStyle?.copyWith(color: AppColors.greyTextColor);
    final valueStyle = fieldTextStyle?.copyWith(color: context.colorScheme.onSecondary);

    final hasCategorySelection =
        selectedId.isNotEmpty && categories.any((c) => c.sId == selectedId);

    final String? dropdownValue;
    if (includeAllOption) {
      dropdownValue = selectedId.isEmpty ? '' : (hasCategorySelection ? selectedId : null);
    } else {
      dropdownValue = hasCategorySelection ? selectedId : null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.colorScheme.secondary,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: ImageView(
              Assets.svg.drinkCategory,
              color: AppColors.greyIconColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox.shrink(),
                style: valueStyle,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: AppText(
                    hint,
                    style: hintStyle ?? const TextStyle(),
                  ),
                ),
                value: dropdownValue,
                onChanged: (String? value) => onChanged(value ?? ''),
                items: [
                  if (includeAllOption)
                    DropdownMenuItem<String>(
                      value: '',
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: AppText(
                          allOptionLabel,
                          style: valueStyle ?? const TextStyle(),
                        ),
                      ),
                    ),
                  ...categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.sId,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: AppText(
                          category.name ?? '',
                          style: valueStyle ?? const TextStyle(),
                        ),
                      ),
                    );
                  }),
                ],
                icon: ImageView(
                  Assets.svg.arrowDown,
                  color: context.colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
