import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';

part 'friend_request_respond_model.g.dart';

FriendRequestRespondModel deserializeFriendRequestRespondModel(
        Map<String, dynamic> json) =>
    FriendRequestRespondModel.fromJson(json);

Map<String, dynamic> serializeFriendRequestRespondModel(
        FriendRequestRespondModel model) =>
    model.toJson();

@JsonSerializable()
class FriendRequestRespondModel {
  FriendRequestRespondModel({
    this.version,
    this.statusCode,
    this.isSuccess,
    this.message,
    this.data,
  });

  factory FriendRequestRespondModel.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestRespondModelFromJson(json);
  String? version;
  int? statusCode;
  bool? isSuccess;
  String? message;
  FriendRequestRespondData? data;

  Map<String, dynamic> toJson() => _$FriendRequestRespondModelToJson(this);
}

@JsonSerializable()
class FriendRequestRespondData {
  FriendRequestRespondData({
    this.senderId,
    this.receiverId,
    this.status,
    this.requestSentAt,
    this.requestRespondedAt,
    this.deletedAt,
    this.sid,
    this.updatedAt,
  });

  factory FriendRequestRespondData.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestRespondDataFromJson(json);

  @JsonKey(name: '_id')
  String? sid;
  SearchUserFriendData? senderId;
  SearchUserFriendData? receiverId;
  String? status;
  String? requestSentAt;
  String? requestRespondedAt;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() => _$FriendRequestRespondDataToJson(this);
}
