import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/models/delete_account_model/delete_account_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

// ignore: public_member_api_docs
Map<String, dynamic> deserializedynamic(Map<String, dynamic> json) => json;

/// Add base Url here..
@RestApi(parser: Parser.FlutterCompute, baseUrl: AppConfig.baseUrl)
@lazySingleton
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST(EndPoints.userLogin)
  Future<AuthModel> login(
    @Field() String email,
    @Field() String pass, {
    @Field('deviceToken') required String deviceToken,
    @Field('deviceType') required String deviceType,
    @Field('voipToken') String? voipToken,
  });

  @POST(EndPoints.userSignUp)
  @MultiPart()
  Future<AuthModel> memberRegister({
    @Part() required String name,
    @Part() required String iso,
    @Part() required String countryFlag,
    @Part() required String mobile,
    @Part() required String email,
    @Part() String? gender,
    @Part() required String address,
    @Part() required String country,
    @Part() required String pass,
    @Part() required String userType,
    @Part() required String deviceType,
    @Part() required String deviceToken,
    @Part(name: 'profile') File? profile,
    @Part() String? otp,
    @Part() String? channel,
    @Part(name: 'voipToken') String? voipToken,
  });

  @POST(EndPoints.userForgotPassword)
  Future<ForgotPasswordResponse> forgotPassword(@Field() String email, @Field() String channel);

  @POST(EndPoints.verifyForgotPassOTP)
  Future<ForgotPasswordOTPResponse> verifyForgotPassOTP(@Part() String email, @Part() String otp, @Part() String channel);

  @POST(EndPoints.userUpdatePassword)
  Future<AuthModel> resetPassword(
    @Part(name: 'newPassword') String newPassword,
    @Part(name: 'userId') String userId,
  );

  @POST(EndPoints.userVerifyOTP)
  Future<AuthModel> verifyCode(
    @Part() String email,
    @Part() String otp,
    @Part() String? channel,
    @Part() String? mobile,
    @Part() String? iso,
  );

  @POST(EndPoints.userSendOTP)
  Future<AuthModel> sendOTP({
    @Part() required String email,
    @Part() required String mobile,
    @Part() required String iso,
    @Part() required String countryFlag,
    @Part() required String name,
    @Part() required String channel,
  });

  @POST(EndPoints.changePassword)
  Future<AuthModel> changePassword({
    @Part() required String oldPassword,
    @Part() required String newPassword,
  });

  @POST(EndPoints.logOut)
  Future<AuthModel> logOut();

  @POST(EndPoints.deleteAccount)
  Future<DeleteAccountModel> deleteAccount({
    @Part() required String deleteReason,
  });

  @POST(EndPoints.contactUs)
  Future<AuthModel> contactUs({
    @Part() required String name,
    @Part() required String email,
    @Part() required String subject,
    @Part() required String message,
  });

  @POST(EndPoints.updateProfile)
  @MultiPart()
  Future<AuthModel> updateMemberUserProfile({
    @Part() required String name,
    @Part() String? mobile,
    @Part() String? iso,
    @Part() String? countryFlag,
    @Part() required String gender,
    @Part() required String address,
    @Part() required String country,
    @Part(name: 'profile') File? profile,
  });

  @GET(EndPoints.profile)
  Future<AuthModel> profileAPI();

  @PATCH('/user/tapToPay')
  Future<AuthModel> setTapToPayEnabled(@Body() Map<String, dynamic> data);
}
