// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallTokenModel _$CallTokenModelFromJson(Map<String, dynamic> json) =>
    CallTokenModel(
      data: json['data'] == null
          ? null
          : TokenDataModel.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$CallTokenModelToJson(CallTokenModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

TokenDataModel _$TokenDataModelFromJson(Map<String, dynamic> json) =>
    TokenDataModel(
      uid: json['uid'] as String?,
      channel: json['channel'] as String?,
      token: json['token'] as String?,
      randomID: json['randomID'] as num?,
    );

Map<String, dynamic> _$TokenDataModelToJson(TokenDataModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'channel': instance.channel,
      'token': instance.token,
      'randomID': instance.randomID,
    };
