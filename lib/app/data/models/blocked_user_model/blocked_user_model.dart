import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';

part 'blocked_user_model.g.dart';

BlockedUserModel deserializeBlockedUserModel(Map<String, dynamic> json) => BlockedUserModel.fromJson(json);

Map<String, dynamic> serializeBlockedUserModel(BlockedUserModel model) => model.toJson();

@JsonSerializable()
class BlockedUserModel {
  BlockedUserModel({
    this.version,
    this.statusCode,
    this.isSuccess,
    this.message,
    this.data,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) => _$BlockedUserModelFromJson(json);
  String? version;
  int? statusCode;
  bool? isSuccess;
  String? message;
  BlockedUsers? data;

  Map<String, dynamic> toJson() => _$BlockedUserModelToJson(this);
}

BlockedUsers deserializeBlockedUsers(Map<String, dynamic> json) => BlockedUsers.fromJson(json);

Map<String, dynamic> serializeBlockedUsers(BlockedUsers model) => model.toJson();

@JsonSerializable()
class BlockedUsers {
  int? totalRecord;
  List<BlockedUsersInfo>? data;

  BlockedUsers({this.totalRecord, this.data});

  factory BlockedUsers.fromJson(Map<String, dynamic> json) => _$BlockedUsersFromJson(json);

  Map<String, dynamic> toJson() => _$BlockedUsersToJson(this);
}

BlockedUsersInfo deserializeBlockedUsersInfo(Map<String, dynamic> json) => BlockedUsersInfo.fromJson(json);

Map<String, dynamic> serializeBlockedUsersInfo(BlockedUsersInfo model) => model.toJson();

@JsonSerializable()
class BlockedUsersInfo {
  AuthData? blockedUser;
  String? blockedAt;

  BlockedUsersInfo({this.blockedAt, this.blockedUser});

  factory BlockedUsersInfo.fromJson(Map<String, dynamic> json) => _$BlockedUsersInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BlockedUsersInfoToJson(this);
}
