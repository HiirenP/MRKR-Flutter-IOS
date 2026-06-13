import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/friend_request_respond_model/friend_request_respond_model.dart';

part 'notifications_model.g.dart';

NotificationsModel deserializeNotificationsModel(Map<String, dynamic> json) => NotificationsModel.fromJson(json);

Map<String, dynamic> serializeNotificationsModel(NotificationsModel model) => model.toJson();

@JsonSerializable()
class NotificationsModel extends ApiResponse {
  NotificationsModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json.isNotEmpty ? json : <String, dynamic>{});
    normalized['isSuccess'] ??= normalized['isSucess'];
    return _$NotificationsModelFromJson(normalized);
  }

  NotificationsData? data;

  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);
}

@JsonSerializable()
class NotificationsData {
  NotificationsData({this.totalRecord, this.data});

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$NotificationsDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  int? totalRecord;
  List<NotificationsListData>? data;

  Map<String, dynamic> toJson() => _$NotificationsDataToJson(this);
}

@JsonSerializable()
class NotificationsListData {
  NotificationsListData(
      {this.sId,
      this.userId,
      this.type,
      this.title,
      this.body,
      this.markerId,
      this.friendId,
      this.approvalRequestId,
      this.isRead,
      this.deletedAt,
      this.updatedAt,
      this.createdAt});

  factory NotificationsListData.fromJson(Map<String, dynamic> json) => _$NotificationsListDataFromJson(json);
  @JsonKey(name: '_id')
  String? sId;
  String? userId;
  String? type;
  String? title;
  String? body;
  String? markerId;
  FriendRequestRespondData? friendId;
  dynamic approvalRequestId;
  bool? isRead;
  String? deletedAt;
  String? updatedAt;
  String? createdAt;

  Map<String, dynamic> toJson() => _$NotificationsListDataToJson(this);
}

/*@JsonSerializable()
class FriendId {
  FriendId({this.sId, this.senderId, this.receiverId, this.status});

  factory FriendId.fromJson(Map<String, dynamic> json) => _$FriendIdFromJson(json);
  @JsonKey(name: '_id')
  String? sId;
  SenderId? senderId;
  SenderId? receiverId;
  String? status;

  Map<String, dynamic> toJson() => _$FriendIdToJson(this);
}

@JsonSerializable()
class SenderId {
  SenderId({this.sId, this.name, this.mobile, this.email, this.profile, this.deletedAt, this.profileStatus});

  factory SenderId.fromJson(Map<String, dynamic> json) => _$SenderIdFromJson(json);
  @JsonKey(name: '_id')
  String? sId;
  String? name;
  String? mobile;
  String? email;
  String? profile;
  String? deletedAt;
  String? profileStatus;

  Map<String, dynamic> toJson() => _$SenderIdToJson(this);
}*/
