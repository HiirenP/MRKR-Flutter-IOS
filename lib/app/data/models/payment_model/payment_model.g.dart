// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      data: json['data'] == null
          ? null
          : PaymentData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) => PaymentData(
      clientSecret: json['clientSecret'] as String?,
      transactionId: json['transactionId'] as String?,
      callback: json['callback'] as String?,
      publicKey: json['publicKey'] as String?,
    );

Map<String, dynamic> _$PaymentDataToJson(PaymentData instance) =>
    <String, dynamic>{
      'clientSecret': instance.clientSecret,
      'transactionId': instance.transactionId,
      'callback': instance.callback,
      'publicKey': instance.publicKey,
    };
