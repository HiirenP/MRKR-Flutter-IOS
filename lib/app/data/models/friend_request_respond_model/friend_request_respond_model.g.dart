// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_respond_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequestRespondModel _$FriendRequestRespondModelFromJson(
        Map<String, dynamic> json) =>
    FriendRequestRespondModel(
      version: json['version'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : FriendRequestRespondData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendRequestRespondModelToJson(
        FriendRequestRespondModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

FriendRequestRespondData _$FriendRequestRespondDataFromJson(
        Map<String, dynamic> json) =>
    FriendRequestRespondData(
      senderId: json['senderId'] == null
          ? null
          : SearchUserFriendData.fromJson(
              json['senderId'] as Map<String, dynamic>),
      receiverId: json['receiverId'] == null
          ? null
          : SearchUserFriendData.fromJson(
              json['receiverId'] as Map<String, dynamic>),
      status: json['status'] as String?,
      requestSentAt: json['requestSentAt'] as String?,
      requestRespondedAt: json['requestRespondedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      sid: json['_id'] as String?,
      updatedAt: json['updatedAt'] as String?,
    )..createdAt = json['createdAt'] as String?;

Map<String, dynamic> _$FriendRequestRespondDataToJson(
        FriendRequestRespondData instance) =>
    <String, dynamic>{
      '_id': instance.sid,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'status': instance.status,
      'requestSentAt': instance.requestSentAt,
      'requestRespondedAt': instance.requestRespondedAt,
      'deletedAt': instance.deletedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
