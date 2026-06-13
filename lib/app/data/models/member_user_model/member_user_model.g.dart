// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberUserModel _$MemberUserModelFromJson(Map<String, dynamic> json) =>
    MemberUserModel(
      version: json['version'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : SearchMemberData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberUserModelToJson(MemberUserModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

SearchMemberData _$SearchMemberDataFromJson(Map<String, dynamic> json) =>
    SearchMemberData(
      users: json['users'] == null
          ? null
          : Users.fromJson(json['users'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchMemberDataToJson(SearchMemberData instance) =>
    <String, dynamic>{
      'users': instance.users,
    };

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchUserFriendData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

SearchUserFriendData _$SearchUserFriendDataFromJson(
        Map<String, dynamic> json) =>
    SearchUserFriendData(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      iso: json['iso'] as String?,
      countryFlag: json['countryFlag'] as String?,
      email: json['email'] as String?,
      profile: json['profile'] as String?,
      userType: json['userType'] as String?,
      deletedAt: json['deletedAt'] as String?,
      profileStatus: json['profileStatus'] as String?,
      friendId: json['friendId'] as String?,
      location: json['location'] == null
          ? null
          : BarLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchUserFriendDataToJson(
        SearchUserFriendData instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'name': instance.name,
      'mobile': instance.mobile,
      'iso': instance.iso,
      'countryFlag': instance.countryFlag,
      'email': instance.email,
      'profile': instance.profile,
      'userType': instance.userType,
      'deletedAt': instance.deletedAt,
      'profileStatus': instance.profileStatus,
      'friendId': instance.friendId,
      'location': instance.location,
    };
