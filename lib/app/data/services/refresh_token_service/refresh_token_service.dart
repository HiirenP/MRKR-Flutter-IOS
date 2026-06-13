import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'refresh_token_service.g.dart';

@RestApi(parser: Parser.FlutterCompute, baseUrl: AppConfig.baseUrl)
@lazySingleton
// ignore: one_member_abstracts
abstract class RefreshTokenService {
  @factoryMethod
  factory RefreshTokenService(Dio dio) = _RefreshTokenService;

  @POST(EndPoints.refreshToken)
  Future<RefreshTokenResponse> refreshToken(
    @Field('userId') String userId,
  );
}
