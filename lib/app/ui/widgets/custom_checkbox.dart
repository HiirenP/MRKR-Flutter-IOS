import 'package:flutter/material.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({super.key, this.value = false, this.onTap,this.color});

  final bool value;
  final GestureTapCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: value ? context.colorScheme.primary : color??context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(6),
        child: value
            ? ImageView(
                Assets.svg.checked,
                color: value ? context.colorScheme.onSecondary : context.colorScheme.secondaryContainer,
              )
            : const SizedBox(),
      ),
    );
  }
}
