// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'near_by_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearByModel _$NearByModelFromJson(Map<String, dynamic> json) => NearByModel(
      data: json['data'] == null
          ? null
          : NearByListData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$NearByModelToJson(NearByModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

NearByListData _$NearByListDataFromJson(Map<String, dynamic> json) =>
    NearByListData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BarDetailsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NearByListDataToJson(NearByListData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalRecord': instance.totalRecord,
    };
