import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'bar_get_update_details_model.g.dart';

BarGetUpdateModel deserializeBarGetUpdateModel(Map<String, dynamic> json) => BarGetUpdateModel.fromJson(json);

Map<String, dynamic> serializeBarGetUpdateModel(BarGetUpdateModel model) => model.toJson();

@JsonSerializable()
class BarGetUpdateModel extends ApiResponse {
  BarGetUpdateModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BarGetUpdateModel.fromJson(Map<String, dynamic> json) {
    return _$BarGetUpdateModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  BarGetUpdateData? data;

  Map<String, dynamic> toJson() => _$BarGetUpdateModelToJson(this);
}

@JsonSerializable()
class BarGetUpdateData {
  BarGetUpdateData(
      {this.sId,
      this.name,
      this.logo,
      this.ownerId,
      this.address,
      this.city,
      this.state,
      this.country,
      this.email,
      this.mobile,
      this.location,
      this.openingHours,
      this.countryFlag,
      this.iso,
      this.isOpenNow,
      this.isOpenToday,
      this.isAvailabilityAdded,
      this.averageRating,
      this.totalReviews,
      this.owner,
      this.wallet,
      this.images,
      this.barId,
      this.drinks,
      this.myReview});

  factory BarGetUpdateData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$BarGetUpdateDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  @JsonKey(name: 'ownerId')
  Owner? ownerId;
  String? sId;
  String? name;
  int? wallet;
  String? logo;
  String? address;
  String? city;
  String? state;
  String? country;
  String? email;
  String? mobile;
  BarLocation? location;
  OpeningHours? openingHours;
  String? countryFlag;
  List<Images>? images;
  String? iso;
  bool? isOpenNow;
  bool? isOpenToday;
  bool? isAvailabilityAdded;
  num? averageRating;
  @JsonKey(name: '_id')
  String? barId;
  num? totalReviews;
  Owner? owner;
  List<BarDrinkData>? drinks;
  BarMyReview? myReview;

  Map<String, dynamic> toJson() => _$BarGetUpdateDataToJson(this);
}

@JsonSerializable()
class BarMyReview {
  BarMyReview({this.sId, this.review, this.stars});

  factory BarMyReview.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['stars'] != null) {
      normalized['stars'] = (normalized['stars'] as num).toDouble();
    }
    return _$BarMyReviewFromJson(normalized);
  }

  @JsonKey(name: '_id')
  String? sId;
  String? review;
  num? stars;

  Map<String, dynamic> toJson() => _$BarMyReviewToJson(this);
}

@JsonSerializable()
class BarLocation {
  BarLocation({this.type, this.coordinates, this.lastUpdated});

  factory BarLocation.fromJson(Map<String, dynamic> json) => _$BarLocationFromJson(json);
  String? type;
  List<double>? coordinates;
  String? lastUpdated;

  Map<String, dynamic> toJson() => _$BarLocationToJson(this);
}

@JsonSerializable()
class Images {
  Images({this.sId, this.url, this.urlThumb});

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
  @JsonKey(name: '_id')
  String? sId;
  String? url;
  String? urlThumb;

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class OpeningHours {
  OpeningHours({this.open, this.close});

  factory OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);
  String? open;
  String? close;

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class Owner {
  Owner({this.sId, this.email, this.profile, this.name});

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  @JsonKey(name: '_id')
  String? sId;
  String? email;
  String? profile;
  String? name;

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
