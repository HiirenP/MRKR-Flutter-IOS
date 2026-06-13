// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _PaymentService implements PaymentService {
  _PaymentService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= AppConfig.baseUrl;
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<BankDetailsModel> addBankDetail({
    required String email,
    required String phone,
    required String iso,
    required String country,
    required String countryFlag,
    required String identityNumber,
    required String city,
    required String address,
    required String state,
    required String bankAccountNumber,
    required String bdate,
    required String bmonth,
    required String byear,
    required String pincode,
    required String routing_number,
    required String fname,
    required String lname,
    File? frontImage,
    File? backImage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('email', email));
    _data.fields.add(MapEntry('phone', phone));
    _data.fields.add(MapEntry('iso', iso));
    _data.fields.add(MapEntry('country', country));
    _data.fields.add(MapEntry('countryFlag', countryFlag));
    _data.fields.add(MapEntry('identityNumber', identityNumber));
    _data.fields.add(MapEntry('city', city));
    _data.fields.add(MapEntry('address', address));
    _data.fields.add(MapEntry('state', state));
    _data.fields.add(MapEntry('bankAccountNumber', bankAccountNumber));
    _data.fields.add(MapEntry('bdate', bdate));
    _data.fields.add(MapEntry('bmonth', bmonth));
    _data.fields.add(MapEntry('byear', byear));
    _data.fields.add(MapEntry('pincode', pincode));
    _data.fields.add(MapEntry('routing_number', routing_number));
    _data.fields.add(MapEntry('fname', fname));
    _data.fields.add(MapEntry('lname', lname));
    if (frontImage != null) {
      _data.files.add(
        MapEntry(
          'frontImage',
          MultipartFile.fromFileSync(
            frontImage.path,
            filename: frontImage.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (backImage != null) {
      _data.files.add(
        MapEntry(
          'backImage',
          MultipartFile.fromFileSync(
            backImage.path,
            filename: backImage.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    final _options = _setStreamType<BankDetailsModel>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'multipart/form-data',
      )
          .compose(
            _dio.options,
            '/payment/addBankDetail',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BankDetailsModel _value;
    try {
      _value = await compute(deserializeBankDetailsModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BankDetailsModel> getBankDetail() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BankDetailsModel>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/getBankDetail',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BankDetailsModel _value;
    try {
      _value = await compute(deserializeBankDetailsModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BankDetailsModel> updateBankDetail({
    String? email,
    String? phone,
    String? iso,
    String? country,
    String? countryFlag,
    String? city,
    String? address,
    String? state,
    String? bankAccountNumber,
    String? pincode,
    String? routing_number,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (email != null) {
      _data.fields.add(MapEntry('email', email));
    }
    if (phone != null) {
      _data.fields.add(MapEntry('phone', phone));
    }
    if (iso != null) {
      _data.fields.add(MapEntry('iso', iso));
    }
    if (country != null) {
      _data.fields.add(MapEntry('country', country));
    }
    if (countryFlag != null) {
      _data.fields.add(MapEntry('countryFlag', countryFlag));
    }
    if (city != null) {
      _data.fields.add(MapEntry('city', city));
    }
    if (address != null) {
      _data.fields.add(MapEntry('address', address));
    }
    if (state != null) {
      _data.fields.add(MapEntry('state', state));
    }
    if (bankAccountNumber != null) {
      _data.fields.add(MapEntry('bankAccountNumber', bankAccountNumber));
    }
    if (pincode != null) {
      _data.fields.add(MapEntry('pincode', pincode));
    }
    if (routing_number != null) {
      _data.fields.add(MapEntry('routing_number', routing_number));
    }
    final _options = _setStreamType<BankDetailsModel>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/updateBankDetail',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BankDetailsModel _value;
    try {
      _value = await compute(deserializeBankDetailsModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<WithdrawMoneyModel> withdrawalMoney(Map<String, dynamic> data) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _options = _setStreamType<WithdrawMoneyModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/withdrawalMoney',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late WithdrawMoneyModel _value;
    try {
      _value = await compute(deserializeWithdrawMoneyModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TransactionHistoryWithdrawalModel> transactionHistory(
    Map<String, dynamic> data,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _options = _setStreamType<TransactionHistoryWithdrawalModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/user/transactionHistory',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TransactionHistoryWithdrawalModel _value;
    try {
      _value = await compute(
        deserializeTransactionHistoryWithdrawalModel,
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TransactionHistoryWithdrawalModel> wallet(
    Map<String, dynamic> data,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _options = _setStreamType<TransactionHistoryWithdrawalModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/wallet',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TransactionHistoryWithdrawalModel _value;
    try {
      _value = await compute(
        deserializeTransactionHistoryWithdrawalModel,
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TransactionHistoryWithdrawalModel> withdrawalHistory(
    Map<String, dynamic> data,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _options = _setStreamType<TransactionHistoryWithdrawalModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/withdrawalHistory',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TransactionHistoryWithdrawalModel _value;
    try {
      _value = await compute(
        deserializeTransactionHistoryWithdrawalModel,
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetTerminalTokenModel> terminalToken() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetTerminalTokenModel>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/terminalToken',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetTerminalTokenModel _value;
    try {
      _value = await compute(deserializeGetTerminalTokenModel, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Map<String, dynamic>> memberPlatformFeePreview(String basePrice) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'basePrice': basePrice};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Map<String, dynamic>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/payment/member-platform-fees/preview',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    return _result.data!;
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
