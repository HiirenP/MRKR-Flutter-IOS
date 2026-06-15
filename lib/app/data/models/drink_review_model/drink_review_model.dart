import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'drink_review_model.g.dart';

DrinkReviewModel deserializeDrinkReviewModel(Map<String, dynamic> json) => DrinkReviewModel.fromJson(json);
Map<String, dynamic> serializeDrinkReviewModel(DrinkReviewModel model) => model.toJson();


@JsonSerializable()
class DrinkReviewModel extends ApiResponse {
  DrinkReviewModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory DrinkReviewModel.fromJson(Map<String, dynamic> json) {
    return _$DrinkReviewModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  DrinkReviewData? data;
  Map<String, dynamic> toJson() => _$DrinkReviewModelToJson(this);
}



@JsonSerializable()
class DrinkReviewData {
  DrinkReviewData({this.userId, this.barId, this.drinkId, this.review, this.stars, this.updatedAt, this.sId, this.createdAt});

  factory DrinkReviewData.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final userIdVal = normalized['userId'];
    if (userIdVal is Map) {
      normalized['userId'] = userIdVal['_id']?.toString() ?? userIdVal['sId']?.toString();
    } else if (userIdVal != null) {
      normalized['userId'] = userIdVal.toString();
    }
    final barIdVal = normalized['barId'];
    if (barIdVal is Map) {
      normalized['barId'] = barIdVal['_id']?.toString();
    } else if (barIdVal != null) {
      normalized['barId'] = barIdVal.toString();
    }
    final drinkIdVal = normalized['drinkId'];
    if (drinkIdVal is Map) {
      normalized['drinkId'] = drinkIdVal['_id']?.toString() ?? drinkIdVal['sId']?.toString();
    } else if (drinkIdVal != null) {
      normalized['drinkId'] = drinkIdVal.toString();
    }
    if (normalized['stars'] != null) {
      normalized['stars'] = (normalized['stars'] as num).toDouble();
    }
    return _$DrinkReviewDataFromJson(normalized);
  }

  String? userId;
  String? barId;
  String? drinkId;
  String? review;
  num? stars;
  String? updatedAt;
  @JsonKey(name: '_id')
  String? sId;
  String? createdAt;

  Map<String, dynamic> toJson() => _$DrinkReviewDataToJson(this);
}
