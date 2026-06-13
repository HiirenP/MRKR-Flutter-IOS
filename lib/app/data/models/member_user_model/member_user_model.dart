// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';

part 'member_user_model.g.dart';

MemberUserModel deserializeMemberUserModel(Map<String, dynamic> json) => MemberUserModel.fromJson(json);

Map<String, dynamic> serializeMemberUserModel(MemberUserModel model) => model.toJson();

@JsonSerializable()
class MemberUserModel {
  String? version;
  int? statusCode;
  bool? isSuccess;
  String? message;
  SearchMemberData? data;

  MemberUserModel({
    this.version,
    this.statusCode,
    this.isSuccess,
    this.message,
    this.data,
  });

  factory MemberUserModel.fromJson(Map<String, dynamic> json) => _$MemberUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberUserModelToJson(this);
}

@JsonSerializable()
class SearchMemberData {
  Users? users;

  SearchMemberData({this.users});

  factory SearchMemberData.fromJson(Map<String, dynamic> json) => _$SearchMemberDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMemberDataToJson(this);
}

@JsonSerializable()
class Users {
  int? totalRecord;
  List<SearchUserFriendData>? data;

  Users({this.totalRecord, this.data});

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
}

@JsonSerializable()
class SearchUserFriendData {
  @JsonKey(name: '_id')
  String? sId;
  String? name;
  String? mobile;
  String? iso;
  String? countryFlag;
  String? email;
  String? profile;
  String? userType;
  String? deletedAt;
  String? profileStatus;
  String? friendId;
  BarLocation? location;

  SearchUserFriendData({
    this.sId,
    this.name,
    this.mobile,
    this.iso,
    this.countryFlag,
    this.email,
    this.profile,
    this.userType,
    this.deletedAt,
    this.profileStatus,
    this.friendId,
    this.location,
  });

  factory SearchUserFriendData.fromJson(Map<String, dynamic> json) => _$SearchUserFriendDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUserFriendDataToJson(this);
}
