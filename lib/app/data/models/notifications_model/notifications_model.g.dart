// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) =>
    NotificationsModel(
      data: json['data'] == null
          ? null
          : NotificationsData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$NotificationsModelToJson(NotificationsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

NotificationsData _$NotificationsDataFromJson(Map<String, dynamic> json) =>
    NotificationsData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => NotificationsListData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationsDataToJson(NotificationsData instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

NotificationsListData _$NotificationsListDataFromJson(
        Map<String, dynamic> json) =>
    NotificationsListData(
      sId: json['_id'] as String?,
      userId: json['userId'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      markerId: json['markerId'] as String?,
      friendId: json['friendId'] == null
          ? null
          : FriendRequestRespondData.fromJson(
              json['friendId'] as Map<String, dynamic>),
      approvalRequestId: json['approvalRequestId'],
      isRead: json['isRead'] as bool?,
      deletedAt: json['deletedAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$NotificationsListDataToJson(
        NotificationsListData instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'userId': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'markerId': instance.markerId,
      'friendId': instance.friendId,
      'approvalRequestId': instance.approvalRequestId,
      'isRead': instance.isRead,
      'deletedAt': instance.deletedAt,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };
