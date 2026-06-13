import 'package:flutter/material.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

class AppCircularContainer extends StatelessWidget {

  const AppCircularContainer({
    super.key,
    required this.iconName,  this.height,  this.width,
  });
  final Widget iconName;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      width: width ?? 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colorScheme.secondary,
            context.colorScheme.secondary.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: iconName,
    );
  }
}
