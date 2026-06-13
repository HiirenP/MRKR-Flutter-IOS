// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankDetailsModel _$BankDetailsModelFromJson(Map<String, dynamic> json) =>
    BankDetailsModel(
      data: json['data'] == null
          ? null
          : BankDetailsData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BankDetailsModelToJson(BankDetailsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

BankDetailsData _$BankDetailsDataFromJson(Map<String, dynamic> json) =>
    BankDetailsData(
      user: json['user'] as String?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      email: json['email'] as String?,
      phone: (json['phone'] as num?)?.toInt(),
      bdate: (json['bdate'] as num?)?.toInt(),
      bmonth: (json['bmonth'] as num?)?.toInt(),
      byear: (json['byear'] as num?)?.toInt(),
      identityNumber: json['identityNumber'] as String?,
      city: json['city'] as String?,
      addressLine1: json['address_line1'] as String?,
      pincode: json['pincode'] as String?,
      state: json['state'] as String?,
      accNumber: json['accNumber'] as String?,
      routingNumber: json['routing_number'] as String?,
      backImage: json['backImage'] as String?,
      frontImage: json['frontImage'] as String?,
      stripeAccId: json['stripe_acc_id'] as String?,
      sId: json['_id'] as String?,
    );

Map<String, dynamic> _$BankDetailsDataToJson(BankDetailsData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'fname': instance.fname,
      'lname': instance.lname,
      'email': instance.email,
      'phone': instance.phone,
      'bdate': instance.bdate,
      'bmonth': instance.bmonth,
      'byear': instance.byear,
      'identityNumber': instance.identityNumber,
      'city': instance.city,
      'address_line1': instance.addressLine1,
      'pincode': instance.pincode,
      'state': instance.state,
      'accNumber': instance.accNumber,
      'routing_number': instance.routingNumber,
      'backImage': instance.backImage,
      'frontImage': instance.frontImage,
      'stripe_acc_id': instance.stripeAccId,
      '_id': instance.sId,
    };
