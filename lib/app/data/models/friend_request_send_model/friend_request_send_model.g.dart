// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_send_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequestSendModel _$FriendRequestSendModelFromJson(
        Map<String, dynamic> json) =>
    FriendRequestSendModel(
      version: json['version'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : FriendRequestSendData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendRequestSendModelToJson(
        FriendRequestSendModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

FriendRequestSendData _$FriendRequestSendDataFromJson(
        Map<String, dynamic> json) =>
    FriendRequestSendData(
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      status: json['status'] as String?,
      requestSentAt: json['requestSentAt'] as String?,
      requestRespondedAt: json['requestRespondedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      sid: json['_id'] as String?,
      updatedAt: json['updatedAt'] as String?,
    )..createdAt = json['createdAt'] as String?;

Map<String, dynamic> _$FriendRequestSendDataToJson(
        FriendRequestSendData instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'status': instance.status,
      'requestSentAt': instance.requestSentAt,
      'requestRespondedAt': instance.requestRespondedAt,
      'deletedAt': instance.deletedAt,
      '_id': instance.sid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
