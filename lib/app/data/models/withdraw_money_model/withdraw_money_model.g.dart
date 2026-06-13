// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_money_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawMoneyModel _$WithdrawMoneyModelFromJson(Map<String, dynamic> json) =>
    WithdrawMoneyModel(
      data: json['data'] == null
          ? null
          : WithdrawData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$WithdrawMoneyModelToJson(WithdrawMoneyModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

WithdrawData _$WithdrawDataFromJson(Map<String, dynamic> json) => WithdrawData(
      remaingAmount: json['remaingAmount'] as num?,
    );

Map<String, dynamic> _$WithdrawDataToJson(WithdrawData instance) =>
    <String, dynamic>{
      'remaingAmount': instance.remaingAmount,
    };
