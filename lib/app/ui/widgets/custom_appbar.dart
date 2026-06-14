import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class AppCustomAppbar extends StatefulWidget {
  const AppCustomAppbar({
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
    this.keyboardFocusNode,
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
  /// When set (e.g. search field on Friends/Messages), back arrow shows on Android + iOS.
  final FocusNode? keyboardFocusNode;
  final Color? color;
  final Widget? secondaryIconName;
  final Widget? action;
  final Widget? widget;

  @override
  State<AppCustomAppbar> createState() => _AppCustomAppbarState();
}

class _AppCustomAppbarState extends State<AppCustomAppbar> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    if (widget.enableKeyboardDismissButton) {
      WidgetsBinding.instance.addObserver(this);
      widget.keyboardFocusNode?.addListener(_scheduleRebuild);
    }
  }

  @override
  void didUpdateWidget(covariant AppCustomAppbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyboardFocusNode != widget.keyboardFocusNode) {
      oldWidget.keyboardFocusNode?.removeListener(_scheduleRebuild);
      widget.keyboardFocusNode?.addListener(_scheduleRebuild);
    }
    if (!oldWidget.enableKeyboardDismissButton && widget.enableKeyboardDismissButton) {
      WidgetsBinding.instance.addObserver(this);
    } else if (oldWidget.enableKeyboardDismissButton && !widget.enableKeyboardDismissButton) {
      WidgetsBinding.instance.removeObserver(this);
    }
  }

  @override
  void dispose() {
    if (widget.enableKeyboardDismissButton) {
      WidgetsBinding.instance.removeObserver(this);
      widget.keyboardFocusNode?.removeListener(_scheduleRebuild);
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (widget.enableKeyboardDismissButton && mounted) {
      setState(() {});
    }
  }

  void _scheduleRebuild() {
    if (mounted) setState(() {});
  }

  bool _showKeyboardDismiss(BuildContext context) {
    if (!widget.enableKeyboardDismissButton) return false;
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    final focusActive = widget.keyboardFocusNode?.hasFocus ?? false;
    return inset > 0 || focusActive;
  }

  void _dismissKeyboard() {
    widget.keyboardFocusNode?.unfocus();
    keyboardHide();
  }

  @override
  Widget build(BuildContext context) {
    final showKeyboardDismiss = _showKeyboardDismiss(context);

    return Padding(
      padding: widget.isPadding
          ? const EdgeInsets.only(top: 35)
          : const AppEdgeInsets.all16(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeading(context, showKeyboardDismiss),
          if (widget.appTitle != null)
            Expanded(
              child: Text(
                widget.appTitle!.capitalize ?? '',
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(color: widget.color),
              ),
            ),
          if (widget.isSecondaryIcon)
            GestureDetector(
              onTap: widget.onSecondaryTap,
              child: widget.action ??
                  Container(
                    height: 40,
                    width: 40,
                    padding: const AppEdgeInsets.all10(),
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: widget.secondaryIconName,
                  ),
            )
          else if (widget.enableKeyboardDismissButton)
            const SizedBox(width: 40, height: 40)
          else
            widget.isHideBackButton ? const Gap(0) : const Gap(40),
          if (widget.widget != null) widget.widget ?? const SizedBox()
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context, bool showKeyboardDismiss) {
    if (showKeyboardDismiss) {
      return GestureDetector(
        onTap: _dismissKeyboard,
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

    if (!widget.isHideBackButton) {
      return GestureDetector(
        onTap: widget.onTap ?? Get.back,
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

    if (widget.isSecondaryIcon && widget.isHideBackButton) {
      return const SizedBox(width: 40, height: 40);
    }

    if (widget.enableKeyboardDismissButton) {
      return const SizedBox(width: 40, height: 40);
    }

    return const SizedBox.shrink();
  }
}
