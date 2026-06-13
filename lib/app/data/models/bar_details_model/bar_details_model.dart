import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'bar_details_model.g.dart';

BarDetailsModel deserializeBarDetailsModel(Map<String, dynamic> json) => BarDetailsModel.fromJson(json);

Map<String, dynamic> serializeBarDetailsModel(BarDetailsModel model) => model.toJson();

@JsonSerializable()
class BarDetailsModel extends ApiResponse {
  BarDetailsModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BarDetailsModel.fromJson(Map<String, dynamic> json) {
    return _$BarDetailsModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  BarDetailsData? data;

  Map<String, dynamic> toJson() => _$BarDetailsModelToJson(this);
}

@JsonSerializable()
class BarDetailsData {
  BarDetailsData(
      {this.sId,
      this.name,
      this.logo,
      this.logoThumb,
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
      this.averageRating,
      this.totalReviews,
      this.owner,
      this.wallet,
      this.images,
      this.distance,
      this.distanceMi,
      this.serviceCharge,
      this.reviewCount,
      this.createdAt,
      this.barId,
      this.drinks});

  factory BarDetailsData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$BarDetailsDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  @JsonKey(name: 'ownerId')
  String? ownerId;
  String? sId;
  String? name;
  int? wallet;
  String? logo;
  String? logoThumb;
  String? address;
  String? city;
  String? state;
  double? distance;
  double? distanceMi;
  String? country;
  String? createdAt;
  String? email;
  String? mobile;
  BarLocation? location;
  OpeningHours? openingHours;
  String? countryFlag;
  List<Images>? images;
  String? iso;
  bool? isOpenNow;
  bool? isOpenToday;
  bool? serviceCharge;
  dynamic averageRating;
  @JsonKey(name: '_id')
  String? barId;
  int? totalReviews;
  @JsonKey(name: 'reviewCount')
  int? reviewCount;
  Owner? owner;
  List<BarDrinkData>? drinks;

  Map<String, dynamic> toJson() => _$BarDetailsDataToJson(this);
}
