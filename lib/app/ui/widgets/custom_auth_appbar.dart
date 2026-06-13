import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_circular_container.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class AppAuthAppbar extends StatelessWidget {
  const AppAuthAppbar({
    super.key,
    this.onTap,
    this.iconName,
    this.title,
    this.subTitle,
    this.isTopPadding = false,
    this.isBack = true,
  });

  final GestureTapCallback? onTap;
  final Widget? iconName;
  final String? title;
  final String? subTitle;
  final bool isTopPadding;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 45),
        if (isBack)
          GestureDetector(
            onTap: onTap ?? Get.back,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const AppEdgeInsets.all10(),
                  child: ImageView(Assets.svg.arrowBack),
                ),
              ),
            ),
          ),
        SizedBox(height: isTopPadding ? 10 : 40),
        if (iconName != null)
          AppCircularContainer(
            iconName: Padding(
              padding: const EdgeInsets.all(30),
              child: iconName,
            ),
          ),
        const Gap(16),
        Text(
          title!.capitalize ?? '',
          textAlign: TextAlign.center,
          style: context.textTheme.titleLarge,
        ),
        const Gap(5),
        Padding(
          padding: const AppEdgeInsets.h20(),
          child: CenterText(
            subTitle ?? '',
            style: context.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
