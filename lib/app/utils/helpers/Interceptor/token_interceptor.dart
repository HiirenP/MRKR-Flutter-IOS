import 'dart:io';

import 'package:dio/dio.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/refresh_token_service/refresh_token_service.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/ui/pages/authentication/login_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart' hide Response;
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class QueueRequest<T> {
  QueueRequest({
    required this.err,
    required this.handler,
  });

  final DioException err;

  final ErrorInterceptorHandler handler;

  void next() {
    handler.next(err);
  }

  Future<void> resolve() {
    final requestOptions = err.requestOptions;
    requestOptions.extra['token'] = getIt<SharedPreferences>().getToken;
    return getIt<Dio>().fetch(_recreateOptions(requestOptions)).handler(
      null,
      isLoading: false,
      onSuccess: handler.resolve,
      onFailed: (value) {
        if (value.dioError != null) {
          debugPrintStack(stackTrace: value.dioError?.stackTrace, label: value.dioError?.response?.data.toString());
          handler.reject(value.dioError!);
        } else {
          handler.next(err);
        }
      },
    );
  }

  static RequestOptions _recreateOptions(RequestOptions options) {
    return RequestOptions(
      headers: {
        ...options.headers,
      },
      data: options.data,
      baseUrl: options.baseUrl,
      path: options.path,
      cancelToken: options.cancelToken,
      connectTimeout: options.connectTimeout,
      sendTimeout: options.sendTimeout,
      receiveTimeout: options.receiveTimeout,
      receiveDataWhenStatusError: options.receiveDataWhenStatusError,
      followRedirects: options.followRedirects,
      maxRedirects: options.maxRedirects,
      validateStatus: options.validateStatus,
      onReceiveProgress: options.onReceiveProgress,
      onSendProgress: options.onSendProgress,
      contentType: options.contentType,
      responseType: options.responseType,
      extra: options.extra,
      method: options.method,
      queryParameters: options.queryParameters,
    );
  }
}

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor();

  final List<QueueRequest<dynamic>> requestQueue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getIt<SharedPreferences>().getToken;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['lang'] = getIt<SharedPreferences>().getAppLocal ?? 'en';

    options.headers['version_code'] = AppConfig.currentBuildVersion;
    options.headers['device_type'] = AppConfig.deviceType;
    options.headers['device_name'] = AppConfig.deviceName;
    options.headers['Accept'] = "application/json";
    if (options.extra.containsKey('token')) {
      options.extra['token'];
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('err.response?.statusCode------------------->${err.response?.statusCode}');

    if (err.response?.statusCode == 401) {
      final isError = await _unAuthorized(err.response);
      if (!isError) super.onError(err, handler);
    } else if (err.response?.statusCode == 433) {
      _queueRequest(err, handler);
    } else if (err.response?.statusCode == AppConfig.forceUpdateCode) {
      Loading.dismiss();

      Get.bottomSheet(
        isDismissible: false,
        enableDrag: false,
        AppBottomSheet(
          title: err.response?.data['data']['title'] as String?,
          canPOP: false,
          subTitle: err.response?.data['data']['description'] as String?,
          // iconName: Padding(
          //   padding: const AppEdgeInsets.all8(),
          //   child: ImageView(Assets.svg.allDone),
          // ),

          positiveButtonTitle: AppStrings.T.update,
          onPositivePressed: () async {
            await launchUrl(Uri.parse((Platform.isAndroid)?'https://play.google.com/store/apps/details?id=com.marker.app':'https://apps.apple.com/us/app/mrkr/id6748701173'), mode: LaunchMode.externalApplication);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
        ),
      );
      super.onError(err, handler);
    } else {
      super.onError(err, handler);
    }
  }

  Future<bool> _unAuthorized(Response<dynamic>? response) async {
    final pref = getIt<SharedPreferences>();
    final hasSession =
        (pref.getToken != null && pref.getToken!.isNotEmpty) || pref.getUserData != null || pref.getUserId != null;
    if (!hasSession) {
      return false;
    }
    Loading.dismiss();
    final res = response?.data;
    if (res is Map<String, dynamic>) {
      final isMessage = res.containsKey('message');
      if (isMessage) {
        showError((res['message'] ?? '').toString());
      }
    }
    await redirectLogin();
    return true;
  }

  void _queueRequest(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('queueRequest------------------->${err.response?.statusCode}');
    requestQueue.add(
      QueueRequest(
        err: err,
        handler: handler,
      ),
    );

    if (refreshTokenState.isInitial) {
      refreshToken();
    }
  }

  final refreshTokenState = ApiState.initial().obs;

  Future<void> refreshToken() async {
    debugPrint('---------refreshToken--------------');
    final pref = getIt<SharedPreferences>()..setToken = null;
    final userId = pref.getUserId;

    if (userId != null) {
      await getIt<RefreshTokenService>().refreshToken(userId).handler(
            refreshTokenState,
            isLoading: false,
            onSuccess: _onRefreshSuccess,
            onFailed: _rejectQueuedRequests,
          );
    } else {
      requestQueue
        ..forEach((element) => element.next())
        ..clear();
    }
  }

  Future<void> _rejectQueuedRequests(FailedState<dynamic> value) async {
    for (final element in requestQueue) {
      element.next();
    }
    requestQueue.clear();
    refreshTokenState.value = InitialState();
    await redirectLogin();
  }

  void _onRefreshSuccess(RefreshTokenResponse value) {
    debugPrint('-----------onRefreshSuccess-------------');
    if (value.data.containsKey('token')) {
      getIt<SharedPreferences>().setToken = value.data['token'] as String;
    } else {
      requestQueue
        ..forEach((element) => element.next())
        ..clear();

      return;
    }
    refreshTokenState.value = InitialState();

    Future.wait(
      requestQueue.map((e) => e.resolve()),
    ).whenComplete(requestQueue.clear);
  }

  Future<void> redirectLogin() async {
    await getIt<SharedPreferences>().clearData();
    await LoginPage.offAllRouteLogin();
  }
}
