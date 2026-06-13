import 'package:json_annotation/json_annotation.dart';

part 'friend_request_send_model.g.dart';

FriendRequestSendModel deserializeFriendRequestSendModel(
        Map<String, dynamic> json) =>
    FriendRequestSendModel.fromJson(json);

Map<String, dynamic> serializeFriendRequestSendModel(
        FriendRequestSendModel model) =>
    model.toJson();

@JsonSerializable()
class FriendRequestSendModel {
  FriendRequestSendModel({
    this.version,
    this.statusCode,
    this.isSuccess,
    this.message,
    this.data,
  });

  factory FriendRequestSendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestSendModelFromJson(json);
  String? version;
  int? statusCode;
  bool? isSuccess;
  String? message;
  FriendRequestSendData? data;

  Map<String, dynamic> toJson() => _$FriendRequestSendModelToJson(this);
}

@JsonSerializable()
class FriendRequestSendData {
  FriendRequestSendData({
    this.senderId,
    this.receiverId,
    this.status,
    this.requestSentAt,
    this.requestRespondedAt,
    this.deletedAt,
    this.sid,
    this.updatedAt,
  });

  factory FriendRequestSendData.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestSendDataFromJson(json);
  String? senderId;
  String? receiverId;
  String? status;
  String? requestSentAt;
  String? requestRespondedAt;
  String? deletedAt;
  @JsonKey(name: '_id')
  String? sid;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() => _$FriendRequestSendDataToJson(this);
}
