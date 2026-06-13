import 'package:flutter/material.dart';

const _kFontFamily = 'Hellix';

class AppTextStyle extends TextStyle {
  const AppTextStyle({
    super.fontSize,
    super.fontWeight,
    super.color,
    super.decoration,
    super.overflow,
  }) : super(fontFamily: _kFontFamily);
}

class AppStyles extends ThemeExtension<AppStyles> {
  AppStyles();

  static AppStyles of(BuildContext context) {
    return Theme.of(context).extension<AppStyles>()!;
  }

  @override
  ThemeExtension<AppStyles> copyWith() => this;

  @override
  ThemeExtension<AppStyles> lerp(covariant ThemeExtension<AppStyles>? other, double t) {
    if (other is! AppStyles) {
      return this;
    }

    return other;
  }
}
