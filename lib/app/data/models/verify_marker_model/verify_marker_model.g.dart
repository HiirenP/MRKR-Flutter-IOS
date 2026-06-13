// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_marker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyMarkerModel _$VerifyMarkerModelFromJson(Map<String, dynamic> json) =>
    VerifyMarkerModel(
      data: json['data'] == null
          ? null
          : VerifyMarkerData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$VerifyMarkerModelToJson(VerifyMarkerModel instance) =>
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
          : Marker.fromJson(json['marker'] as Map<String, dynamic>),
      requiresApproval: json['requiresApproval'] as bool?,
    );

Map<String, dynamic> _$VerifyMarkerDataToJson(VerifyMarkerData instance) =>
    <String, dynamic>{
      'marker': instance.marker,
      'requiresApproval': instance.requiresApproval,
    };

Marker _$MarkerFromJson(Map<String, dynamic> json) => Marker(
      sId: json['sId'] as String?,
      barId: json['barId'] == null
          ? null
          : BarId.fromJson(json['barId'] as Map<String, dynamic>),
      drinkId: json['drinkId'] == null
          ? null
          : DrinkId.fromJson(json['drinkId'] as Map<String, dynamic>),
      ownerId: json['ownerId'] == null
          ? null
          : Owner.fromJson(json['ownerId'] as Map<String, dynamic>),
      redeemerId: json['redeemerId'] == null
          ? null
          : Owner.fromJson(json['redeemerId'] as Map<String, dynamic>),
      secretCode: json['secretCode'] as String?,
      qrCode: json['qrCode'] as String?,
      basePrice: json['basePrice'] as num?,
      tip: json['tip'] as num?,
      totalAmount: json['totalAmount'] as num?,
      status: json['status'] as String?,
      transactionId: json['transactionId'] as String?,
      redeemedAt: json['redeemedAt'] as String?,
      transferredAt: json['transferredAt'] as String?,
      hasTip: json['hasTip'] as bool?,
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$MarkerToJson(Marker instance) => <String, dynamic>{
      'sId': instance.sId,
      'barId': instance.barId,
      'drinkId': instance.drinkId,
      'ownerId': instance.ownerId,
      'redeemerId': instance.redeemerId,
      'secretCode': instance.secretCode,
      'qrCode': instance.qrCode,
      'basePrice': instance.basePrice,
      'tip': instance.tip,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'transactionId': instance.transactionId,
      'redeemedAt': instance.redeemedAt,
      'transferredAt': instance.transferredAt,
      'hasTip': instance.hasTip,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };

BarId _$BarIdFromJson(Map<String, dynamic> json) => BarId(
      location: json['location'] == null
          ? null
          : BarLocation.fromJson(json['location'] as Map<String, dynamic>),
      sId: json['sId'] as String?,
      ownerId: json['ownerId'] == null
          ? null
          : Owner.fromJson(json['ownerId'] as Map<String, dynamic>),
      logo: json['logo'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$BarIdToJson(BarId instance) => <String, dynamic>{
      'location': instance.location,
      'sId': instance.sId,
      'ownerId': instance.ownerId,
      'logo': instance.logo,
      'name': instance.name,
      'address': instance.address,
    };
