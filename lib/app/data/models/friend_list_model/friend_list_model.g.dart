// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendListModel _$FriendListModelFromJson(Map<String, dynamic> json) =>
    FriendListModel(
      version: json['version'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Users.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendListModelToJson(FriendListModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };
