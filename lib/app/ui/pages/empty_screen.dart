import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    super.key,
    this.title,
    this.subTitle,
    this.imagePath,
  });

  final String? title;
  final String? subTitle;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const AppEdgeInsets.all20(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Column(
                children: [
                  Image.asset(
                    imagePath!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const Gap(14),
                ],
              ),
            CenterText(
              title ?? '',
              style: context.textTheme.titleMedium,
            ),
            const Gap(14),
            CenterText(
              subTitle ?? '',
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.greyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
