import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class AppCustomAppbar extends StatelessWidget {
  const   AppCustomAppbar({
    super.key,
    this.onTap,
    this.onSecondaryTap,
    this.secondaryIconName,
    this.appTitle,
    this.isEmptyTitle = false,
    this.isSecondaryIcon = false,
    this.isHideBackButton = false,
    this.isPadding = false,
    this.enableKeyboardDismissButton = false,
    this.color,
    this.action,
    this.widget,
  });

  final GestureTapCallback? onTap;
  final GestureTapCallback? onSecondaryTap;
  final String? appTitle;
  final bool isEmptyTitle;
  final bool isHideBackButton;
  final bool isSecondaryIcon;
  final bool isPadding;
  final bool enableKeyboardDismissButton;
  final Color? color;
  final Widget? secondaryIconName;
  final Widget? action;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final showKeyboardDismiss = enableKeyboardDismissButton && keyboardVisible;

    return Padding(
      padding: isPadding
          ? const EdgeInsets.only(top: 35)
          : const AppEdgeInsets.all16(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeading(context, showKeyboardDismiss),
          if (appTitle != null)
            Expanded(
              child: Text(
                appTitle!.capitalize ?? '',
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(color: color),
              ),
            ),
          if (isSecondaryIcon)
            GestureDetector(
              onTap: onSecondaryTap,
              child: action ??
                  Container(
                    height: 40,
                    width: 40,
                    padding: const AppEdgeInsets.all10(),
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: secondaryIconName,
                  ),
            )
          else if (enableKeyboardDismissButton)
            const SizedBox(width: 40, height: 40)
          else
            isHideBackButton ? const Gap(0) : const Gap(40),
          if (widget != null) widget ?? const SizedBox()
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context, bool showKeyboardDismiss) {
    if (showKeyboardDismiss) {
      return GestureDetector(
        onTap: keyboardHide,
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
      );
    }

    if (!isHideBackButton) {
      return GestureDetector(
        onTap: onTap ?? Get.back,
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
      );
    }

    if (isSecondaryIcon && isHideBackButton) {
      return const SizedBox(width: 40, height: 40);
    }

    if (enableKeyboardDismissButton) {
      return const SizedBox(width: 40, height: 40);
    }

    return const SizedBox.shrink();
  }
}
