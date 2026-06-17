import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/ui/pages/member_main/home/drinks_details_page.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/Interceptor/token_interceptor.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.config.dart';
import 'package:marker/app/utils/helpers/loading.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/service/notification_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@i.injectableInit
Future<void> configuration({required Widget myApp}) async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      await AppConfig.getCurrentVersionCode();
      await AppConfig.getDeviceName();
      debugPrint(
        'Marker API → env=${AppConfig.resolvedApiEnv} url=${AppConfig.socketUrl}',
      );
      await getIt.init();
      AppLifecycleHandler().initialize();
      PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20; // 200MB cache
      try {
        setupCallKitListeners();
        await PushNotifications.localNotiInit();
      } catch (e) {
        debugPrint('Error initializing Firebase: $e');
      }
      final appLinks = AppLinks();
      // Capture cold-start link (Play-Store "Open" case)
      appLinks.uriLinkStream.listen(
        (event) async {
          final userData = getIt<SharedPreferences>().getUserData;
          if (userData != null) {
            final link = '$event';
            final id = link.split('drinkId=').last;
            debugPrint('deep_link_event:  $id');
            await DrinkDetailsView.route(barId: id, isShow: true);
          }
        },
      );

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ));
      if (Platform.isAndroid) {
        await hideBottomBar();
      }
      if (kDebugMode) {
        getIt<Dio>().interceptors.add(
              PrettyDioLogger(
                requestBody: true,
              ),
            );
      }

      getIt<Dio>().interceptors
        ..add(RefreshTokenInterceptor())
        // ..add(DioCacheInterceptor(options: cacheOption))
        ..add(RetryInterceptor(dio: getIt<Dio>()));

      runApp(myApp);
      Loading().configLoading();
    },
    (error, stackTrace) {},
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (Zone zone, ZoneDelegate delegate, Zone parent, Object error, StackTrace stackTrace) {},
    ),
  );
}
