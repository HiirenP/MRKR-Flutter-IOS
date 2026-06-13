// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeemed_upcoming_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemedUpcomingModel _$RedeemedUpcomingModelFromJson(
        Map<String, dynamic> json) =>
    RedeemedUpcomingModel(
      data: json['data'] == null
          ? null
          : RedeemedUpcomingData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RedeemedUpcomingModelToJson(
        RedeemedUpcomingModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

RedeemedUpcomingData _$RedeemedUpcomingDataFromJson(
        Map<String, dynamic> json) =>
    RedeemedUpcomingData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              RedeemedUpcomingListData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RedeemedUpcomingDataToJson(
        RedeemedUpcomingData instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

RedeemedUpcomingListData _$RedeemedUpcomingListDataFromJson(
        Map<String, dynamic> json) =>
    RedeemedUpcomingListData(
      sId: json['_id'] as String?,
      barId: json['barId'] == null
          ? null
          : BarId.fromJson(json['barId'] as Map<String, dynamic>),
      drinkId: json['drinkId'] == null
          ? null
          : BarDrinkData.fromJson(json['drinkId'] as Map<String, dynamic>),
      ownerId: json['ownerId'] == null
          ? null
          : Owner.fromJson(json['ownerId'] as Map<String, dynamic>),
      redeemerId: json['redeemerId'] == null
          ? null
          : Owner.fromJson(json['redeemerId'] as Map<String, dynamic>),
      scannedBy: json['scannedBy'] == null
          ? null
          : Owner.fromJson(json['scannedBy'] as Map<String, dynamic>),
      secretCode: json['secretCode'] as String?,
      basePrice: json['basePrice'] as num?,
      tip: json['tip'] as num?,
      totalAmount: json['totalAmount'] as num?,
      platformFeesTotal: json['platformFeesTotal'] as num?,
      amountPaid: json['amountPaid'] as num?,
      platformFeeBreakdown: (json['platformFeeBreakdown'] as List<dynamic>?)
          ?.map((e) => PlatformFeeBreakdownItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      redeemedAt: json['redeemedAt'] as String?,
      hasTip: json['hasTip'] as bool?,
      qrCode: json['qrCode'] as String?,
      transactionId: json['transactionId'] as String?,
      transferredAt: json['transferredAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

PlatformFeeBreakdownItem _$PlatformFeeBreakdownItemFromJson(
        Map<String, dynamic> json) =>
    PlatformFeeBreakdownItem(
      name: json['name'] as String?,
      percentage: json['percentage'] as num?,
      amount: json['amount'] as num?,
      chargeType: json['chargeType'] as String?,
    );

Map<String, dynamic> _$PlatformFeeBreakdownItemToJson(
        PlatformFeeBreakdownItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'percentage': instance.percentage,
      'amount': instance.amount,
      'chargeType': instance.chargeType,
    };

Map<String, dynamic> _$RedeemedUpcomingListDataToJson(
        RedeemedUpcomingListData instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'barId': instance.barId,
      'drinkId': instance.drinkId,
      'ownerId': instance.ownerId,
      'redeemerId': instance.redeemerId,
      'scannedBy': instance.scannedBy,
      'secretCode': instance.secretCode,
      'basePrice': instance.basePrice,
      'tip': instance.tip,
      'totalAmount': instance.totalAmount,
      'platformFeesTotal': instance.platformFeesTotal,
      'amountPaid': instance.amountPaid,
      'platformFeeBreakdown': instance.platformFeeBreakdown,
      'status': instance.status,
      'redeemedAt': instance.redeemedAt,
      'hasTip': instance.hasTip,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
      'qrCode': instance.qrCode,
      'transactionId': instance.transactionId,
      'transferredAt': instance.transferredAt,
    };

BarId _$BarIdFromJson(Map<String, dynamic> json) => BarId(
      location: json['location'] == null
          ? null
          : BarLocation.fromJson(json['location'] as Map<String, dynamic>),
      sId: json['_id'] as String?,
      ownerId: json['ownerId'] == null
          ? null
          : Owner.fromJson(json['ownerId'] as Map<String, dynamic>),
      logo: json['logo'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$BarIdToJson(BarId instance) => <String, dynamic>{
      'location': instance.location,
      '_id': instance.sId,
      'ownerId': instance.ownerId,
      'logo': instance.logo,
      'name': instance.name,
      'address': instance.address,
    };
