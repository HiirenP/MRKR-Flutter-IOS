// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_marker_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcomingMarkerDetailsModel _$UpcomingMarkerDetailsModelFromJson(
        Map<String, dynamic> json) =>
    UpcomingMarkerDetailsModel(
      data: json['data'] == null
          ? null
          : RedeemedUpcomingListData.fromJson(
              json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UpcomingMarkerDetailsModelToJson(
        UpcomingMarkerDetailsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };
