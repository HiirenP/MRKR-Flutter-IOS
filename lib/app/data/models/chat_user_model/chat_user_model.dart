import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';
import 'package:marker/app/data/models/messages_model/messages_model.dart';

part 'chat_user_model.g.dart';

ChatUserModel deserializeChatUserModel(Map<String, dynamic> json) =>
    ChatUserModel.fromJson(json);

Map<String, dynamic> serializeChatUserModel(ChatUserModel model) =>
    model.toJson();

@JsonSerializable()
class ChatUserModel {
  ChatUserModel({
    this.totalRecord,
    this.data,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) =>
      _$ChatUserModelFromJson(json);
  int? totalRecord;
  List<ChatDataModel>? data;

  Map<String, dynamic> toJson() => _$ChatUserModelToJson(this);
}

@JsonSerializable()
class ChatDataModel {
  ChatDataModel({
    this.userDetail,
    this.lastMessage,
    this.unreadCount,
  });

  factory ChatDataModel.fromJson(Map<String, dynamic> json) =>
      _$ChatDataModelFromJson(json);

  @JsonKey(name: 'user_detail')
  SearchUserFriendData? userDetail;
  MessagesDataModel? lastMessage;
  bool? sendMarker;
  num? unreadCount;

  Map<String, dynamic> toJson() => _$ChatDataModelToJson(this);
}
