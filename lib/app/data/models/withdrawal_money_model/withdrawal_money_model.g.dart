// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_money_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalMoneyModel _$WithdrawalMoneyModelFromJson(
        Map<String, dynamic> json) =>
    WithdrawalMoneyModel(
      data: json['data'] == null
          ? null
          : WithdrawalMoneyData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$WithdrawalMoneyModelToJson(
        WithdrawalMoneyModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

WithdrawalMoneyData _$WithdrawalMoneyDataFromJson(Map<String, dynamic> json) =>
    WithdrawalMoneyData(
      remaingAmount: json['remaingAmount'] == null
          ? null
          : RemaingAmount.fromJson(
              json['remaingAmount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WithdrawalMoneyDataToJson(
        WithdrawalMoneyData instance) =>
    <String, dynamic>{
      'remaingAmount': instance.remaingAmount,
    };

RemaingAmount _$RemaingAmountFromJson(Map<String, dynamic> json) =>
    RemaingAmount(
      id: json['id'] as String?,
      object: json['object'] as String?,
      amount: json['amount'] as num?,
      amountReversed: json['amountReversed'] as num?,
      balanceTransaction: json['balanceTransaction'] as String?,
      created: (json['created'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      description: json['description'] as String?,
      destination: json['destination'] as String?,
      destinationPayment: json['destinationPayment'] as String?,
      livemode: json['livemode'] as bool?,
      metadata: json['metadata'] == null
          ? null
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      reversals: json['reversals'] == null
          ? null
          : Reversals.fromJson(json['reversals'] as Map<String, dynamic>),
      reversed: json['reversed'] as bool?,
      sourceTransaction: json['sourceTransaction'] as String?,
      sourceType: json['sourceType'] as String?,
      transferGroup: json['transferGroup'] as String?,
    );

Map<String, dynamic> _$RemaingAmountToJson(RemaingAmount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'amount': instance.amount,
      'amountReversed': instance.amountReversed,
      'balanceTransaction': instance.balanceTransaction,
      'created': instance.created,
      'currency': instance.currency,
      'description': instance.description,
      'destination': instance.destination,
      'destinationPayment': instance.destinationPayment,
      'livemode': instance.livemode,
      'metadata': instance.metadata,
      'reversals': instance.reversals,
      'reversed': instance.reversed,
      'sourceTransaction': instance.sourceTransaction,
      'sourceType': instance.sourceType,
      'transferGroup': instance.transferGroup,
    };

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata();

Map<String, dynamic> _$MetadataToJson(Metadata instance) => <String, dynamic>{};

Reversals _$ReversalsFromJson(Map<String, dynamic> json) => Reversals(
      object: json['object'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((e) => e as String).toList(),
      hasMore: json['hasMore'] as bool?,
      totalCount: (json['totalCount'] as num?)?.toInt(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ReversalsToJson(Reversals instance) => <String, dynamic>{
      'object': instance.object,
      'data': instance.data,
      'hasMore': instance.hasMore,
      'totalCount': instance.totalCount,
      'url': instance.url,
    };
