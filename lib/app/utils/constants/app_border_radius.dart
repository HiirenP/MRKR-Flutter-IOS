import 'package:flutter/painting.dart';

class AppBorderRadius extends BorderRadius {
  const AppBorderRadius.all(super.radius) : super.all();

  const AppBorderRadius.all8() : super.all(const Radius.circular(8));
  const AppBorderRadius.all10() : super.all(const Radius.circular(10));
  const AppBorderRadius.all12() : super.all(const Radius.circular(12));
  const AppBorderRadius.all14() : super.all(const Radius.circular(14));
  const AppBorderRadius.all16() : super.all(const Radius.circular(16));
  const AppBorderRadius.all18() : super.all(const Radius.circular(18));
  const AppBorderRadius.all20() : super.all(const Radius.circular(20));

  const AppBorderRadius.top8() : super.vertical(top: const Radius.circular(8));
  const AppBorderRadius.top10() : super.vertical(top: const Radius.circular(10));
  const AppBorderRadius.top12() : super.vertical(top: const Radius.circular(12));
  const AppBorderRadius.top14() : super.vertical(top: const Radius.circular(14));
  const AppBorderRadius.top16() : super.vertical(top: const Radius.circular(16));
  const AppBorderRadius.top18() : super.vertical(top: const Radius.circular(18));
  const AppBorderRadius.top20() : super.vertical(top: const Radius.circular(20));

  const AppBorderRadius.bottom8() : super.vertical(bottom: const Radius.circular(8));
  const AppBorderRadius.bottom10() : super.vertical(bottom: const Radius.circular(10));
  const AppBorderRadius.bottom12() : super.vertical(bottom: const Radius.circular(12));
  const AppBorderRadius.bottom14() : super.vertical(bottom: const Radius.circular(14));
  const AppBorderRadius.bottom16() : super.vertical(bottom: const Radius.circular(16));
  const AppBorderRadius.bottom18() : super.vertical(bottom: const Radius.circular(18));
  const AppBorderRadius.bottom20() : super.vertical(bottom: const Radius.circular(20));
}
