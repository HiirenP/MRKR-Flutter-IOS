import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';

part 'bar_drink_details_model.g.dart';

BarDrinkDetailsModel deserializeBarDrinkDetailsModel(Map<String, dynamic> json) => BarDrinkDetailsModel.fromJson(json);

Map<String, dynamic> serializeBarDrinkDetailsModel(BarDrinkDetailsModel model) => model.toJson();

@JsonSerializable()
class BarDrinkDetailsModel extends ApiResponse {
  BarDrinkDetailsModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BarDrinkDetailsModel.fromJson(Map<String, dynamic> json) {
    return _$BarDrinkDetailsModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  DrinkDetailsData? data;

  Map<String, dynamic> toJson() => _$BarDrinkDetailsModelToJson(this);
}

@JsonSerializable()
class DrinkDetailsData {
  DrinkDetailsData({
    this.barId,
    this.name,
    this.image,
    this.description,
    this.price,
    this.categoryId,
    this.category,
    this.latestReviews,
    this.reviewStats,
    this.shareableLink,
    this.myReview,
  });

  factory DrinkDetailsData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$DrinkDetailsDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  String? barId;
  String? name;
  String? image;
  String? description;
  num? price;
  String? categoryId;
  DrinkCategoryData? category;
  List<LatestReviews>? latestReviews;
  ReviewStats? reviewStats;
  String? shareableLink;
  BarMyReview? myReview;

  Map<String, dynamic> toJson() => _$DrinkDetailsDataToJson(this);
}

@JsonSerializable()
class LatestReviews {
  LatestReviews({this.sId, this.userId, this.drinkId, this.review, this.stars, this.updatedAt, this.createdAt});

  factory LatestReviews.fromJson(Map<String, dynamic> json) => _$LatestReviewsFromJson(json);
  String? sId;
  UserId? userId;
  DrinkId? drinkId;
  String? review;
  int? stars;
  String? updatedAt;
  String? createdAt;

  Map<String, dynamic> toJson() => _$LatestReviewsToJson(this);
}

@JsonSerializable()
class UserId {
  UserId({this.sId, this.name, this.profile});

  factory UserId.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['sId'] ??= normalized['_id']?.toString();
    return _$UserIdFromJson(normalized);
  }
  String? sId;
  String? name;
  String? profile;

  Map<String, dynamic> toJson() => _$UserIdToJson(this);
}

@JsonSerializable()
class DrinkId {
  DrinkId({this.sId, this.name, this.image, this.description, this.price});

  factory DrinkId.fromJson(Map<String, dynamic> json) => _$DrinkIdFromJson(json);
  @JsonKey(name: '_id')
  String? sId;
  String? name;
  String? image;
  String? description;
  num? price;

  Map<String, dynamic> toJson() => _$DrinkIdToJson(this);
}

@JsonSerializable()
class ReviewStats {
  ReviewStats({this.nId, this.avgRating, this.total});

  factory ReviewStats.fromJson(Map<String, dynamic> json) => _$ReviewStatsFromJson(json);
  String? nId;
  double? avgRating;
  int? total;

  Map<String, dynamic> toJson() => _$ReviewStatsToJson(this);
}
