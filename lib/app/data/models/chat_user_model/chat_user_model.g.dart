// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) =>
    ChatUserModel(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatUserModelToJson(ChatUserModel instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

ChatDataModel _$ChatDataModelFromJson(Map<String, dynamic> json) =>
    ChatDataModel(
      userDetail: json['user_detail'] == null
          ? null
          : SearchUserFriendData.fromJson(
              json['user_detail'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessagesDataModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      unreadCount: json['unreadCount'] as num?,
    )..sendMarker = json['sendMarker'] as bool?;

Map<String, dynamic> _$ChatDataModelToJson(ChatDataModel instance) =>
    <String, dynamic>{
      'user_detail': instance.userDetail,
      'lastMessage': instance.lastMessage,
      'sendMarker': instance.sendMarker,
      'unreadCount': instance.unreadCount,
    };
