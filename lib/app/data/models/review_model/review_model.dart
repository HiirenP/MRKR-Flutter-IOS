import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'review_model.g.dart';

ReviewModel deserializeReviewModel(Map<String, dynamic> json) => ReviewModel.fromJson(json);

Map<String, dynamic> serializeReviewModel(ReviewModel model) => model.toJson();

@JsonSerializable()
class ReviewModel extends ApiResponse {
  ReviewModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return _$ReviewModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  ReviewData? data;

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class ReviewData {
  ReviewData({this.data, this.totalRecord});

  factory ReviewData.fromJson(Map<String, dynamic> json) => _$ReviewDataFromJson(json);
  int? totalRecord;
  List<ReviewListData>? data;

  Map<String, dynamic> toJson() => _$ReviewDataToJson(this);
}

@JsonSerializable()
class ReviewListData {
  ReviewListData({this.sId, this.userId, this.barId, this.review, this.stars, this.updatedAt, this.createdAt});

  factory ReviewListData.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final userIdVal = normalized['userId'];
    if (userIdVal is String) {
      normalized['userId'] = {'sId': userIdVal, '_id': userIdVal};
    } else if (userIdVal is Map) {
      final userMap = Map<String, dynamic>.from(userIdVal);
      final id = userMap['_id']?.toString() ?? userMap['sId']?.toString();
      if (id != null) {
        userMap.putIfAbsent('sId', () => id);
        userMap.putIfAbsent('_id', () => id);
      }
      normalized['userId'] = userMap;
    }
    final barIdVal = normalized['barId'];
    if (barIdVal is String) {
      normalized['barId'] = {'_id': barIdVal};
    } else if (barIdVal is Map) {
      normalized['barId'] = Map<String, dynamic>.from(barIdVal);
    }
    return _$ReviewListDataFromJson(normalized);
  }
  @JsonKey(name: '_id')
  String? sId;
  UserId? userId;
  BarId? barId;
  String? review;
  int? stars;
  String? updatedAt;
  String? createdAt;

  Map<String, dynamic> toJson() => _$ReviewListDataToJson(this);
}
