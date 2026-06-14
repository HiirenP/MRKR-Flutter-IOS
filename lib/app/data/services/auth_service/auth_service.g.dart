// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _AuthService implements AuthService {
  _AuthService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= AppConfig.baseUrl;
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<AuthModel> login(
    String email,
    String pass, {
    required String deviceToken,
    required String deviceType,
    String? voipToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'pass': pass,
      'deviceToken': deviceToken,
      'deviceType': deviceType,
      'voipToken': voipToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/login',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> memberRegister({
    required String name,
    required String iso,
    required String countryFlag,
    required String mobile,
    required String email,
    String? gender,
    required String address,
    required String country,
    required String pass,
    required String userType,
    required String deviceType,
    required String deviceToken,
    File? profile,
    String? otp,
    String? channel,
    String? voipToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('iso', iso));
    _data.fields.add(MapEntry('countryFlag', countryFlag));
    _data.fields.add(MapEntry('mobile', mobile));
    _data.fields.add(MapEntry('email', email));
    if (gender != null) {
      _data.fields.add(MapEntry('gender', gender));
    }
    _data.fields.add(MapEntry('address', address));
    _data.fields.add(MapEntry('country', country));
    _data.fields.add(MapEntry('pass', pass));
    _data.fields.add(MapEntry('userType', userType));
    _data.fields.add(MapEntry('deviceType', deviceType));
    _data.fields.add(MapEntry('deviceToken', deviceToken));
    if (profile != null) {
      _data.files.add(
        MapEntry(
          'profile',
          MultipartFile.fromFileSync(
            profile.path,
            filename: profile.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (otp != null) {
      _data.fields.add(MapEntry('otp', otp));
    }
    if (channel != null) {
      _data.fields.add(MapEntry('channel', channel));
    }
    if (voipToken != null) {
      _data.fields.add(MapEntry('voipToken', voipToken));
    }
    final _options = _setStreamType<AuthModel>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'multipart/form-data',
      )
          .compose(
            _dio.options,
            '/auth/signUp',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(
    String email,
    String channel,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email, 'channel': channel};
    final _options = _setStreamType<ForgotPasswordResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/forgotPassword',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ForgotPasswordResponse _value;
    try {
      _value = await compute(deserializeForgotPasswordResponse, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ForgotPasswordOTPResponse> verifyForgotPassOTP(
    String email,
    String otp,
    String channel,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('otp', otp));
    _data.fields.add(MapEntry('channel', channel));
    final _options = _setStreamType<ForgotPasswordOTPResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/verifyForgotPassOTP',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ForgotPasswordOTPResponse _value;
    try {
      _value = await compute(
        deserializeForgotPasswordOTPResponse,
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> resetPassword(String newPassword, String userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('newPassword', newPassword));
    _data.fields.add(MapEntry('userId', userId));
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/updatePassword',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> verifyCode(
    String email,
    String otp,
    String? channel,
    String? mobile,
    String? iso,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('otp', otp));
    if (channel != null) {
      _data.fields.add(MapEntry('channel', channel));
    }
    if (mobile != null) {
      _data.fields.add(MapEntry('mobile', mobile));
    }
    if (iso != null) {
      _data.fields.add(MapEntry('iso', iso));
    }
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/verifyOTP',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> sendOTP({
    required String email,
    required String mobile,
    required String iso,
    required String countryFlag,
    required String name,
    required String channel,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('mobile', mobile));
    _data.fields.add(MapEntry('iso', iso));
    _data.fields.add(MapEntry('countryFlag', countryFlag));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('channel', channel));
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/sendOtp',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('oldPassword', oldPassword));
    _data.fields.add(MapEntry('newPassword', newPassword));
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/changePassword',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> logOut() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/logOut',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteAccountModel> deleteAccount({
    required String deleteReason,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('deleteReason', deleteReason));
    final _options = _setStreamType<DeleteAccountModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/deleteAccount',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeleteAccountModel _value;
    try {
      _value = await compute(deserializeDeleteAccountModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> contactUs({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('subject', subject));
    _data.fields.add(MapEntry('message', message));
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/contactUs',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> updateMemberUserProfile({
    required String name,
    String? mobile,
    String? iso,
    String? countryFlag,
    required String gender,
    required String address,
    required String country,
    File? profile,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('name', name));
    if (mobile != null) {
      _data.fields.add(MapEntry('mobile', mobile));
    }
    if (iso != null) {
      _data.fields.add(MapEntry('iso', iso));
    }
    if (countryFlag != null) {
      _data.fields.add(MapEntry('countryFlag', countryFlag));
    }
    _data.fields.add(MapEntry('gender', gender));
    _data.fields.add(MapEntry('address', address));
    _data.fields.add(MapEntry('country', country));
    if (profile != null) {
      _data.files.add(
        MapEntry(
          'profile',
          MultipartFile.fromFileSync(
            profile.path,
            filename: profile.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    final _options = _setStreamType<AuthModel>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'multipart/form-data',
      )
          .compose(
            _dio.options,
            '/user/updateProfile',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> profileAPI() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<AuthModel>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/profile',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AuthModel> setTapToPayEnabled(bool enabled) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{'enabled': enabled};
    final _options = _setStreamType<AuthModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/tapToPay',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AuthModel _value;
    try {
      _value = await compute(deserializeAuthModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
