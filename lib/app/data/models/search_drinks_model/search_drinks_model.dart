import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'search_drinks_model.g.dart';

SearchDrinksModel deserializeSearchDrinksModel(Map<String, dynamic> json) => SearchDrinksModel.fromJson(json);

Map<String, dynamic> serializeSearchDrinksModel(SearchDrinksModel model) => model.toJson();

@JsonSerializable()
class SearchDrinksModel extends ApiResponse {
  SearchDrinksModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory SearchDrinksModel.fromJson(Map<String, dynamic> json) {
    return _$SearchDrinksModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  SearchDrinksData? data;

  Map<String, dynamic> toJson() => _$SearchDrinksModelToJson(this);
}

@JsonSerializable()
class SearchDrinksData {
  SearchDrinksData({this.data, this.totalRecord});

  factory SearchDrinksData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$SearchDrinksDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  List<SearchDrinksList>? data;
  int? totalRecord;

  Map<String, dynamic> toJson() => _$SearchDrinksDataToJson(this);
}

@JsonSerializable()
class SearchDrinksList {
  SearchDrinksList({this.sId, this.name, this.image, this.price, this.bar, this.totalReviews, this.averageRating});

  factory SearchDrinksList.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$SearchDrinksListFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  @JsonKey(name: '_id')
  String? sId;
  String? name;
  String? image;
  num? price;
  BarDrinksDetails? bar;
  int? totalReviews;
  int? averageRating;

  Map<String, dynamic> toJson() => _$SearchDrinksListToJson(this);
}

@JsonSerializable()
class BarDrinksDetails {
  BarDrinksDetails({this.sId, this.logo, this.name, this.address, this.city, this.state, this.country});

  factory BarDrinksDetails.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$BarDrinksDetailsFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  String? sId;
  String? name;
  String? address;
  String? city;
  String? state;
  String? country;
  String? logo;

  Map<String, dynamic> toJson() => _$BarDrinksDetailsToJson(this);
}
