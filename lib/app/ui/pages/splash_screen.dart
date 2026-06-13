import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/splash_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';


class SplashScreen extends GetItHook<SplashController> {
  const SplashScreen({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.splash);
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Assets.images.png.splashImage.image(fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.navigateNextScreen();
  }

  @override
  void onDispose() {
    controller.locationService.stopListening();
  }
}
