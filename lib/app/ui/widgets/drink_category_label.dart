import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class DrinkCategoryLabel extends StatelessWidget {
  const DrinkCategoryLabel({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    if (categoryName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        ImageView(
          Assets.svg.drinkCategory,
          color: AppColors.greyIconColor,
          inner: ImageSize(width: 18, height: 18),
        ),
        const Gap(8),
        AppText(
          categoryName,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
