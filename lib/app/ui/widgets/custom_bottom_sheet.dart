import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_circular_container.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.iconName,
    this.title,
    this.subTitle,
    this.subThirdTitle,
    this.content,
    this.positiveButtonTitle,
    this.subTitleObx,
    this.negativeButtonTitle,
    this.onPositivePressed,
    this.onNegativePressed,
    this.isPadding = false,
    this.isDivider = false,
    this.isClose = false,
    this.canPOP = true,
  });

  final Widget? iconName;
  final String? title;
  final String? subTitle;
  final RxString? subTitleObx;
  final String? subThirdTitle;
  final String? positiveButtonTitle;
  final String? negativeButtonTitle;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  final Widget? content;
  final bool isPadding;
  final bool isDivider;
  final bool isClose;
  final bool canPOP;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPOP,

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Wrap(
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.only(top: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  if (iconName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      child: AppCircularContainer(
                        iconName: Padding(
                          padding: const AppEdgeInsets.all16(),
                          child: iconName,
                        ),
                        height: 100,
                        width: 100,
                      ),
                    ),
                  const Gap(15),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        child: AppText(
                          title ?? '',
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      // Icon aligned to the right if isClose is true
                      if (isClose)
                        GestureDetector(
                          onTap: Get.back,
                          child: Padding(
                            padding: const AppEdgeInsets.oR15(),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.close,
                                color: context.colorScheme.secondaryContainer,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(5),
                  if (isDivider) Divider(color: context.colorScheme.secondary),
                  if (subTitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                      child: CenterText(
                        subTitle!,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  if (subTitleObx != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                      child: Obx(
                        () => CenterText(
                          subTitleObx!.value,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  if (subThirdTitle != null)
                    Padding(
                      padding: const AppEdgeInsets.all16(),
                      child: CenterText(
                        subThirdTitle!,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                  if (content != null)
                    Padding(
                      padding: const AppEdgeInsets.all16(),
                      child: content,
                    ),
                  Padding(
                    padding: isPadding ? EdgeInsets.zero : const AppEdgeInsets.all16(),
                    child: Row(
                      children: [
                        if (onNegativePressed != null)
                          Expanded(
                            child: Padding(
                              padding: const AppEdgeInsets.oR15(),
                              child: AppSecondaryButton(label: negativeButtonTitle!, onPressed: onNegativePressed!),
                            ),
                          ),
                        if (onPositivePressed != null)
                          Expanded(
                            child: AppButton(label: positiveButtonTitle!, onPressed: onPositivePressed!),
                          ),
                      ],
                    ),
                  ),
                  const CustomSizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
