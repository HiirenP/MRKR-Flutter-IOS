// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_nearby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcomingNearbyModel _$UpcomingNearbyModelFromJson(Map<String, dynamic> json) =>
    UpcomingNearbyModel(
      data: json['data'] == null
          ? null
          : UpcomingNearbyData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UpcomingNearbyModelToJson(
        UpcomingNearbyModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

UpcomingNearbyData _$UpcomingNearbyDataFromJson(Map<String, dynamic> json) =>
    UpcomingNearbyData(
      nearbyBars: (json['nearbyBars'] as List<dynamic>?)
          ?.map((e) => BarDetailsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..upcomingMarkers = (json['upcomingMarkers'] as List<dynamic>?)
        ?.map(
            (e) => RedeemedUpcomingListData.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$UpcomingNearbyDataToJson(UpcomingNearbyData instance) =>
    <String, dynamic>{
      'nearbyBars': instance.nearbyBars,
      'upcomingMarkers': instance.upcomingMarkers,
    };
