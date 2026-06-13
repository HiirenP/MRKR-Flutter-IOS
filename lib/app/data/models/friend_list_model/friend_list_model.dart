import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';

part 'friend_list_model.g.dart';

FriendListModel deserializeFriendListModel(Map<String, dynamic> json) =>
    FriendListModel.fromJson(json);

Map<String, dynamic> serializeFriendListModel(FriendListModel model) =>
    model.toJson();

@JsonSerializable()
class FriendListModel {
  FriendListModel({
    this.version,
    this.statusCode,
    this.isSuccess,
    this.message,
    this.data,
  });

  factory FriendListModel.fromJson(Map<String, dynamic> json) =>
      _$FriendListModelFromJson(json);
  String? version;
  int? statusCode;
  bool? isSuccess;
  String? message;
  Users? data;

  Map<String, dynamic> toJson() => _$FriendListModelToJson(this);
}
