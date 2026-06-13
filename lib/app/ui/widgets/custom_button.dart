import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

class AppButton extends StatelessWidget {

  // Constructor for the AppButton widget
  const AppButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor, // Default color for the button
    this.textStyle, // Default color for the button
    this.textColor = Colors.black, // Default text color
    this.borderRadius = 30.0, // Default border radius
    this.fontSize = 16.0, // Default font size
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onSecondary,
          // button text color applied
          elevation: 0,
          textStyle:textStyle?? context.textTheme.bodyLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ), // Rounded corners
          ),
          //padding: const AppEdgeInsets.all14(),
          minimumSize: const Size(double.infinity, 55),
          maximumSize: const Size(double.infinity, 55) // Padding inside the button
          ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {

  // Constructor for the AppButton widget
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor, // Default color for the button
    this.textStyle, // Default color for the button
    this.textColor = Colors.black, // Default text color
    this.borderRadius = 30.0, // Default border radius
    this.fontSize, // Default font size
    super.key, this.height,
  });
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double? fontSize;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor:backgroundColor ?? context.colorScheme.secondary,
          foregroundColor: context.colorScheme.secondaryFixedDim,
          elevation: 0,
          textStyle:textStyle?? context.textTheme.bodyLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ), // Rounded corners
          ),
          //padding: const AppEdgeInsets.all14(),
          minimumSize:  Size(double.infinity, height ??55),
          maximumSize:  Size(double.infinity,height?? 55) // Padding inside the button
          ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class EllipsisContainer extends StatelessWidget {

  const EllipsisContainer({super.key, required this.label, this.color, this.bgColor});
  final String label;
  final Color? color;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const AppEdgeInsets.hv105(),
      decoration: BoxDecoration(
          color: bgColor ?? context.colorScheme.onPrimaryContainer, borderRadius: BorderRadius.circular(30)),
      child: AppText(
        label,
        style: context.textTheme.bodySmall?.copyWith(color: color ?? context.colorScheme.onPrimary),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {

  const CircularContainer(
      {super.key, required this.imagePath, this.bgColor, this.isColor = false, this.color, this.radius});
  final String imagePath;
  final Color? bgColor;
  final Color? color;
  final double? radius;
  final bool isColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 23,
      backgroundColor: bgColor ?? context.colorScheme.secondary,
      child: ImageView(
        imagePath,
        inner: ImageSize(height: 21, width: 21),
        color: isColor ? null : color ?? context.colorScheme.primary,
      ),
    );
  }
}
