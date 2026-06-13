// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_bar_drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerDrinkModel _$OwnerDrinkModelFromJson(Map<String, dynamic> json) =>
    OwnerDrinkModel(
      data: json['data'] == null
          ? null
          : OwnerDrinkData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$OwnerDrinkModelToJson(OwnerDrinkModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

OwnerDrinkData _$OwnerDrinkDataFromJson(Map<String, dynamic> json) =>
    OwnerDrinkData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BarDrinkData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OwnerDrinkDataToJson(OwnerDrinkData instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };
