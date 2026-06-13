import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:marker/app/routes/app_pages.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/themes/app_theme.dart';
import 'package:marker/l10n/app_localizations.dart';
import 'package:marker/service/notification_service.dart';

const _kAppName = 'Marker';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  await configuration(myApp: const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // FIX PINK IMAGES ISSUE
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      try {
        DefaultCacheManager().emptyCache(); // for CachedNetworkImage users
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: _kAppName,
        navigatorKey: Get.key,
        getPages: AppPages.routes,
        initialRoute: (Platform.isIOS && isVideoNavigate) ? AppRoutes.homePage : AppRoutes.splash,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        builder: EasyLoading.init(),
      ),
    );
  }
}
