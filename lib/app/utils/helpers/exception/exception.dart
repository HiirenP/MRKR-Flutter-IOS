// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/loading.dart';

@immutable
class UserFriendlyError {
  final String title;
  final String description;

  const UserFriendlyError(this.title, this.description);
}

extension DioExceptionX on DioException {
  /// context should pass for incase app works with Localization so the context is required
  UserFriendlyError toUserFriendlyError() {
    return type.toUserFriendlyError(
      badResponseDesc: _statusCode(
        response?.statusCode,
      ),
    );
  }

  String _statusCode(int? statusCode) {
    final res = response?.data;
    if (res is Map<String, dynamic>) {
      if (res.containsKey('message')) {
        return '${res['message']}';
      }
    }
    return switch (statusCode) {
      200 => AppStrings.T.code200,
      201 => AppStrings.T.code201,
      202 => AppStrings.T.code202,
      301 => AppStrings.T.code301,
      302 => AppStrings.T.code302,
      304 => AppStrings.T.code304,
      400 => AppStrings.T.code400,
      401 => AppStrings.T.code401,
      403 => AppStrings.T.code403,
      404 => AppStrings.T.code404,
      405 => AppStrings.T.code405,
      409 => AppStrings.T.code409,
      500 => AppStrings.T.code500,
      503 => AppStrings.T.code503,
      _ => AppStrings.T.badResponseDesc,
    };
  }
}

extension DioExceptionTypeX on DioExceptionType {
  /// context should pass for incase app works with Localization so the context is required
  UserFriendlyError toUserFriendlyError({
    String? badResponseDesc,
  }) {
    switch (this) {
      case DioExceptionType.connectionTimeout:
        return UserFriendlyError(
          AppStrings.T.connectionTimeout,
          AppStrings.T.connectionTimeoutDesc,
        );
      case DioExceptionType.sendTimeout:
        return UserFriendlyError(
          AppStrings.T.sendTimeout,
          AppStrings.T.sendTimeoutDesc,
        );
      case DioExceptionType.receiveTimeout:
        return UserFriendlyError(
          AppStrings.T.receiveTimeout,
          AppStrings.T.receiveTimeoutDesc,
        );
      case DioExceptionType.badCertificate:
        return UserFriendlyError(
          AppStrings.T.badCertificate,
          AppStrings.T.badCertificateDesc,
        );
      case DioExceptionType.badResponse:
        return UserFriendlyError(
          AppStrings.T.badResponse,
          badResponseDesc ?? AppStrings.T.badResponseDesc,
        );
      case DioExceptionType.cancel:
        return UserFriendlyError(
          AppStrings.T.cancel,
          AppStrings.T.cancelDesc,
        );
      case DioExceptionType.connectionError:
        return UserFriendlyError(
          AppStrings.T.connectionError,
          AppStrings.T.connectionErrorDesc,
        );
      case DioExceptionType.unknown:
        return UserFriendlyError(
          AppStrings.T.unknown,
          AppStrings.T.unknownDesc,
        );
    }
  }
}

typedef ApiSuccessCallback<T> = void Function(T value);

typedef ApiFailedCallback<T> = void Function(FailedState<T> value);

extension ApiHandlingX<T> on Future<T> {
  Future<void> handler(
    Rx<ApiState>? state, {
    bool isLoading = true,
    ApiSuccessCallback<T>? onSuccess,
    ApiFailedCallback<T>? onFailed,
  }) async {
    try {
      state?.value = LoadingState(); // Set state to loading

      if (isLoading) Loading.show(); // Show loading indicator

      final response = await this; // Await the API call
      state?.value = SuccessState<T>(response); // Set state to success
      onSuccess?.call(response);
    } on DioException catch (e) {
      final failedState = FailedState<T>(
        statusCode: e.response?.statusCode ?? 0,
        isRetirable: switch (e.type) {
          DioExceptionType.connectionError ||
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout =>
            true,
          _ => false,
        },
        dioError: e,
      );

      state?.value = failedState; // Set state to failed
      // onFailed?.call((state?.value ?? failedState) as FailedState<T>); // Call the onFailed callback
    } on Object catch (e) {
      debugPrint('ApiHandlingX unexpected error: $e');
      final failedState = FailedState<T>(
        statusCode: 0,
        isRetirable: false,
        dioError: e is DioException ? e : null,
      );

      state?.value = failedState; // Set state to failed
    } finally {
      if (isLoading) Loading.dismiss(); // Dismiss loading indicator
      
      // Only call onFailed if we're in a failed state
      if (state?.value is FailedState<T>) {
        onFailed?.call(state!.value as FailedState<T>);
      }
    }
  }
}

extension RxApiStateX on Rx<ApiState> {
  bool get isInitial => value is InitialState;

  bool get isLoading => value is LoadingState;

  bool get isSuccess => value is SuccessState;

  bool get isFailed => value is FailedState;
}

extension ApiStateX on ApiState {
  bool get isInitial => this is InitialState;

  bool get isLoading => this is LoadingState;

  bool get isSuccess => this is SuccessState;

  bool get isFailed => this is FailedState;
}

sealed class ApiState {
  static ApiState initial() => InitialState();
}

class SuccessState<T> extends ApiState {
  T value;

  SuccessState(this.value);
}

class InitialState extends ApiState {}

class LoadingState extends ApiState {
  void showProgressDialog({@required BuildContext? buildContext}) {
    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (context) {
        return const Center(
          child: SpinKitCircle(
            color: Colors.white,
            size: 30,
          ),
        );
      },
    );
  }
}

class FailedState<T> extends ApiState {
  bool isRetirable;

  UserFriendlyError get error =>
      dioError?.toUserFriendlyError() ??
      UserFriendlyError(
        AppStrings.T.apiError,
        AppStrings.T.apiErrorDescription,
      );

  Response<T>? get response {
    if (dioError?.response is Response<T>) {
      return dioError!.response! as Response<T>;
    }
    return null;
  }

  DioException? dioError;

  int statusCode;

  FailedState({
    required this.isRetirable,
    required this.statusCode,
    required this.dioError,
  });
}
