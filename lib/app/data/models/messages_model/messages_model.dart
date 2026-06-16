import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'messages_model.g.dart';

MessagesModel deserializeMessagesModel(Map<String, dynamic> json) =>
    MessagesModel.fromJson(json);

Map<String, dynamic> serializeMessagesModel(MessagesModel model) =>
    model.toJson();

@JsonSerializable()
class MessagesModel {
  MessagesModel({
    this.totalRecord,
    this.data,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) =>
      _$MessagesModelFromJson(json);
  int? totalRecord;
  List<MessagesDataModel>? data;

  Map<String, dynamic> toJson() => _$MessagesModelToJson(this);
}

@JsonSerializable()
class MessagesDataModel {
  MessagesDataModel({
    this.sid,
    this.senderId,
    this.receiverId,
    this.friendId,
    this.message,
    this.messageType,
    this.markerId,
    this.reactions,
    this.isRead,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory MessagesDataModel.fromJson(Map<String, dynamic> json) =>
      _$MessagesDataModelFromJson(json);

  @JsonKey(name: '_id')
  String? sid;
  SearchUserFriendData? senderId;
  SearchUserFriendData? receiverId;
  String? friendId;
  String? message;
  String? messageType;
  RedeemedUpcomingListData? markerId;
  List<MessageReaction>? reactions;
  bool? isRead;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() => _$MessagesDataModelToJson(this);
}

class MessageReaction {
  MessageReaction({this.userId, this.emoji, this.reactedAt});

  factory MessageReaction.fromJson(Map<String, dynamic> json) => MessageReaction(
        userId: (json['userId'] is Map) ? (json['userId']['_id']?.toString()) : json['userId']?.toString(),
        emoji: json['emoji']?.toString(),
        reactedAt: json['reactedAt']?.toString(),
      );

  final String? userId;
  final String? emoji;
  final String? reactedAt;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'emoji': emoji,
        'reactedAt': reactedAt,
      };
}
