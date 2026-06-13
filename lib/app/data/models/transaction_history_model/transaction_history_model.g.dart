// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionHistoryWithdrawalModel _$TransactionHistoryWithdrawalModelFromJson(
        Map<String, dynamic> json) =>
    TransactionHistoryWithdrawalModel(
      data: json['data'] == null
          ? null
          : TransactionWithdrawalHistoryData.fromJson(
              json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$TransactionHistoryWithdrawalModelToJson(
        TransactionHistoryWithdrawalModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

TransactionWithdrawalHistoryData _$TransactionWithdrawalHistoryDataFromJson(
        Map<String, dynamic> json) =>
    TransactionWithdrawalHistoryData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionWithdrawalHistoryListData.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    )..wallet = json['wallet'] as num?;

Map<String, dynamic> _$TransactionWithdrawalHistoryDataToJson(
        TransactionWithdrawalHistoryData instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'wallet': instance.wallet,
      'data': instance.data,
    };

TransactionWithdrawalHistoryListData
    _$TransactionWithdrawalHistoryListDataFromJson(Map<String, dynamic> json) =>
        TransactionWithdrawalHistoryListData(
          sId: json['_id'] as String?,
          transactionId: json['transactionId'] as String?,
          paymentId: json['paymentId'] as String?,
          userId: json['userId'] == null
              ? null
              : UserId.fromJson(json['userId'] as Map<String, dynamic>),
          barId: json['barId'] == null
              ? null
              : BarId.fromJson(json['barId'] as Map<String, dynamic>),
          drinkId: json['drinkId'] == null
              ? null
              : DrinkId.fromJson(json['drinkId'] as Map<String, dynamic>),
          transactionType: json['transactionType'] as String?,
          amount: json['amount'] as num?,
          serviceCharge: json['serviceCharge'] as num?,
          serviceChargePercentage: json['serviceChargePercentage'] as num?,
          updatedAt: json['updated_at'] as String?,
          createdAt: json['created_at'] as String?,
        );

Map<String, dynamic> _$TransactionWithdrawalHistoryListDataToJson(
        TransactionWithdrawalHistoryListData instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'transactionId': instance.transactionId,
      'paymentId': instance.paymentId,
      'userId': instance.userId,
      'barId': instance.barId,
      'drinkId': instance.drinkId,
      'transactionType': instance.transactionType,
      'amount': instance.amount,
      'serviceCharge': instance.serviceCharge,
      'serviceChargePercentage': instance.serviceChargePercentage,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
    };

UserId _$UserIdFromJson(Map<String, dynamic> json) => UserId(
      sId: json['_id'] as String?,
      profile: json['profile'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UserIdToJson(UserId instance) => <String, dynamic>{
      '_id': instance.sId,
      'profile': instance.profile,
      'name': instance.name,
    };

TransactionPlatformFeeItem _$TransactionPlatformFeeItemFromJson(
        Map<String, dynamic> json) =>
    TransactionPlatformFeeItem(
      name: json['name'] as String?,
      percentage: json['percentage'] as num?,
      amount: json['amount'] as num?,
      chargeType: json['chargeType'] as String?,
    );

Map<String, dynamic> _$TransactionPlatformFeeItemToJson(
        TransactionPlatformFeeItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'percentage': instance.percentage,
      'amount': instance.amount,
      'chargeType': instance.chargeType,
    };
