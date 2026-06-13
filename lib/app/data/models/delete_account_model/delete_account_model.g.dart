// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteAccountModel _$DeleteAccountModelFromJson(Map<String, dynamic> json) =>
    DeleteAccountModel(
      data: json['data'] as List<dynamic>?,
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteAccountModelToJson(DeleteAccountModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };
