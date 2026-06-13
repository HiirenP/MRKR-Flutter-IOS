// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedUserModel _$BlockedUserModelFromJson(Map<String, dynamic> json) =>
    BlockedUserModel(
      version: json['version'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : BlockedUsers.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockedUserModelToJson(BlockedUserModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

BlockedUsers _$BlockedUsersFromJson(Map<String, dynamic> json) => BlockedUsers(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BlockedUsersInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockedUsersToJson(BlockedUsers instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

BlockedUsersInfo _$BlockedUsersInfoFromJson(Map<String, dynamic> json) =>
    BlockedUsersInfo(
      blockedAt: json['blockedAt'] as String?,
      blockedUser: json['blockedUser'] == null
          ? null
          : AuthData.fromJson(json['blockedUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockedUsersInfoToJson(BlockedUsersInfo instance) =>
    <String, dynamic>{
      'blockedUser': instance.blockedUser,
      'blockedAt': instance.blockedAt,
    };
