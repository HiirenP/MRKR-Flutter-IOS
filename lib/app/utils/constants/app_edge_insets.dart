import 'package:flutter/material.dart';

class AppEdgeInsets extends EdgeInsets {
  const AppEdgeInsets.all8() : super.all(8);
  const AppEdgeInsets.all5() : super.all(5);
  const AppEdgeInsets.all10() : super.all(10);
  const AppEdgeInsets.all12() : super.all(12);
  const AppEdgeInsets.all14() : super.all(14);
  const AppEdgeInsets.  all16() : super.all(16);
  const AppEdgeInsets.all18() : super.all(18);
    const AppEdgeInsets.all20() : super.all(20);

  const AppEdgeInsets.h16() : super.symmetric(horizontal: 16);
  const AppEdgeInsets.h12() : super.symmetric(horizontal: 12);
  const AppEdgeInsets.h20() : super.symmetric(horizontal: 20);
  const AppEdgeInsets.h8() : super.symmetric(horizontal: 8);
  const AppEdgeInsets.h10() : super.symmetric(horizontal: 10);
  const AppEdgeInsets.h5() : super.symmetric(horizontal: 5);
  const AppEdgeInsets.hv105() : super.symmetric(horizontal: 10,vertical: 5);
  const AppEdgeInsets.hv165() : super.symmetric(horizontal: 16,vertical: 5);
    const AppEdgeInsets.hv1610() : super.symmetric(horizontal: 16,vertical: 10);

  const AppEdgeInsets.v16() : super.symmetric(vertical: 16);
  const AppEdgeInsets.v14() : super.symmetric(vertical: 14);
  const AppEdgeInsets.v10() : super.symmetric(vertical: 10);
  const AppEdgeInsets.v5() : super.symmetric(vertical: 5);
  const AppEdgeInsets.v8() : super.symmetric(vertical: 8);

  const AppEdgeInsets.oL8() : super.only(left: 8);
  const AppEdgeInsets.oB15() : super.only(bottom: 15);
  const AppEdgeInsets.oT15() : super.only(top: 15);
  const AppEdgeInsets.oB10() : super.only(bottom: 10);
  const AppEdgeInsets.oB16() : super.only(bottom: 16);
  const AppEdgeInsets.oR8() : super.only(right: 8);
  const AppEdgeInsets.oR15() : super.only(right: 15);
}
