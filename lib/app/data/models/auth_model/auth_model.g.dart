// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      data: json['data'] == null
          ? null
          : AuthData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      iso: json['iso'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      mobile: json['mobile'] as String?,
      profile: json['profile'] as String?,
      ucode: json['ucode'] as String?,
      token: json['token'] as String?,
      deviceToken: json['deviceToken'] as String?,
      isBarCreated: json['isBarCreated'] as String?,
      deviceType: json['deviceType'] as String?,
      userType: json['userType'] as String?,
      otpCode: json['otpCode'],
      isConfirm: json['isConfirm'] as bool?,
      deleteReason: json['deleteReason'] as String?,
      stripeSubAccountId: json['stripeSubAccountId'] as String?,
      isChatOpen: json['isChatOpen'] as String?,
      profileStatus: json['profileStatus'] as String?,
      countryFlag: json['countryFlag'] as String?,
      wallet: (json['wallet'] as num?)?.toInt(),
      isBankAdded: json['isBankAdded'] as String?,
      channel: json['channel'] as String?,
      serviceCharge: json['serviceCharge'] as bool?,
      tapToPayEnabled: json['tapToPayEnabled'] as bool?,
    );

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'iso': instance.iso,
      'email': instance.email,
      'password': instance.password,
      'mobile': instance.mobile,
      'profile': instance.profile,
      'ucode': instance.ucode,
      'gender': instance.gender,
      'address': instance.address,
      'country': instance.country,
      'token': instance.token,
      'channel': instance.channel,
      'isBarCreated': instance.isBarCreated,
      'deviceToken': instance.deviceToken,
      'deviceType': instance.deviceType,
      'userType': instance.userType,
      'otpCode': instance.otpCode,
      'deleteReason': instance.deleteReason,
      'stripeSubAccountId': instance.stripeSubAccountId,
      'isChatOpen': instance.isChatOpen,
      'profileStatus': instance.profileStatus,
      'countryFlag': instance.countryFlag,
      'wallet': instance.wallet,
      'isBankAdded': instance.isBankAdded,
      'serviceCharge': instance.serviceCharge,
      'isConfirm': instance.isConfirm,
      'tapToPayEnabled': instance.tapToPayEnabled,
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RefreshTokenResponse(
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$RefreshTokenResponseToJson(
        RefreshTokenResponse instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordResponse(
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ForgotPasswordData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForgotPasswordResponseToJson(
        ForgotPasswordResponse instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

ForgotPasswordData _$ForgotPasswordDataFromJson(Map<String, dynamic> json) =>
    ForgotPasswordData(
      id: json['_id'] as String?,
      otpCode: json['otpCode'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ForgotPasswordDataToJson(ForgotPasswordData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'otpCode': instance.otpCode,
      'email': instance.email,
    };

ForgotPasswordOTPResponse _$ForgotPasswordOTPResponseFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordOTPResponse(
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ForgotPasswordOTPData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForgotPasswordOTPResponseToJson(
        ForgotPasswordOTPResponse instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

ForgotPasswordOTPData _$ForgotPasswordOTPDataFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordOTPData(
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$ForgotPasswordOTPDataToJson(
        ForgotPasswordOTPData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };
