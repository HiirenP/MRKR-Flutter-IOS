// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_marker_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyMarkerDetailsModel _$VerifyMarkerDetailsModelFromJson(
        Map<String, dynamic> json) =>
    VerifyMarkerDetailsModel(
      data: json['data'] == null
          ? null
          : VerifyMarkerData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$VerifyMarkerDetailsModelToJson(
        VerifyMarkerDetailsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

VerifyMarkerData _$VerifyMarkerDataFromJson(Map<String, dynamic> json) =>
    VerifyMarkerData(
      marker: json['marker'] == null
          ? null
          : RedeemedUpcomingListData.fromJson(
              json['marker'] as Map<String, dynamic>),
      requiresApproval: json['requiresApproval'] as bool?,
    )
      ..markerId = json['markerId'] as String?
      ..originalBarName = json['originalBarName'] as String?
      ..markerPrice = json['markerPrice'] as num?
      ..scannedBarName = json['scannedBarName'] as String?
      ..drinkName = json['drinkName'] as String?;

Map<String, dynamic> _$VerifyMarkerDataToJson(VerifyMarkerData instance) =>
    <String, dynamic>{
      'marker': instance.marker,
      'requiresApproval': instance.requiresApproval,
      'markerId': instance.markerId,
      'originalBarName': instance.originalBarName,
      'markerPrice': instance.markerPrice,
      'scannedBarName': instance.scannedBarName,
      'drinkName': instance.drinkName,
    };
