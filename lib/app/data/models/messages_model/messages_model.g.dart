// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesModel _$MessagesModelFromJson(Map<String, dynamic> json) =>
    MessagesModel(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MessagesDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessagesModelToJson(MessagesModel instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

MessagesDataModel _$MessagesDataModelFromJson(Map<String, dynamic> json) =>
    MessagesDataModel(
      sid: json['_id'] as String?,
      senderId: json['senderId'] == null
          ? null
          : SearchUserFriendData.fromJson(
              json['senderId'] as Map<String, dynamic>),
      receiverId: json['receiverId'] == null
          ? null
          : SearchUserFriendData.fromJson(
              json['receiverId'] as Map<String, dynamic>),
      friendId: json['friendId'] as String?,
      message: json['message'] as String?,
      messageType: json['messageType'] as String?,
      markerId: json['markerId'] == null
          ? null
          : RedeemedUpcomingListData.fromJson(
              json['markerId'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$MessagesDataModelToJson(MessagesDataModel instance) =>
    <String, dynamic>{
      '_id': instance.sid,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'friendId': instance.friendId,
      'message': instance.message,
      'messageType': instance.messageType,
      'markerId': instance.markerId,
      'isRead': instance.isRead,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
