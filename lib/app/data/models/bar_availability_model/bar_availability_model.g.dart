// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarAvailabilityModel _$BarAvailabilityModelFromJson(
        Map<String, dynamic> json) =>
    BarAvailabilityModel(
      data: json['data'] == null
          ? null
          : BarAvailabilityData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BarAvailabilityModelToJson(
        BarAvailabilityModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

BarAvailabilityData _$BarAvailabilityDataFromJson(Map<String, dynamic> json) =>
    BarAvailabilityData(
      barId: json['barId'] as String?,
      daysOpen: (json['daysOpen'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specificDaysOff: (json['specificDaysOff'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vacation: (json['vacation'] as List<dynamic>?)
          ?.map((e) => Vacation.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] as String?,
      sId: json['sId'] as String?,
      createdAt: json['createdAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BarAvailabilityDataToJson(
        BarAvailabilityData instance) =>
    <String, dynamic>{
      'barId': instance.barId,
      'daysOpen': instance.daysOpen,
      'specificDaysOff': instance.specificDaysOff,
      'vacation': instance.vacation,
      'updatedAt': instance.updatedAt,
      'sId': instance.sId,
      'createdAt': instance.createdAt,
      'iV': instance.iV,
    };

Vacation _$VacationFromJson(Map<String, dynamic> json) => Vacation(
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
      sId: json['sId'] as String?,
    );

Map<String, dynamic> _$VacationToJson(Vacation instance) => <String, dynamic>{
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'sId': instance.sId,
    };
