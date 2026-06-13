import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomSizedBox extends StatelessWidget {
  const CustomSizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    return Gap(isAndroid ? 0 : 20);
  }
}
