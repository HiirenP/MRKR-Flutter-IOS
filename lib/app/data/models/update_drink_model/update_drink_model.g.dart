// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDrinkModel _$UpdateDrinkModelFromJson(Map<String, dynamic> json) =>
    UpdateDrinkModel(
      data: json['data'] == null
          ? null
          : BarDrinkData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UpdateDrinkModelToJson(UpdateDrinkModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };
