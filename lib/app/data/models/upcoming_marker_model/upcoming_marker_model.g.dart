// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_marker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcomingMarkerModel _$UpcomingMarkerModelFromJson(Map<String, dynamic> json) =>
    UpcomingMarkerModel(
      data: json['data'] == null
          ? null
          : UpcomingMarkerData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UpcomingMarkerModelToJson(
        UpcomingMarkerModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

UpcomingMarkerData _$UpcomingMarkerDataFromJson(Map<String, dynamic> json) =>
    UpcomingMarkerData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              RedeemedUpcomingListData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpcomingMarkerDataToJson(UpcomingMarkerData instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };
