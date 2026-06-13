import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';

part 'bar_drink_model.g.dart';

BarDrinkModel deserializeBarDrinkModel(Map<String, dynamic> json) => BarDrinkModel.fromJson(json);

Map<String, dynamic> serializeBarDrinkModel(BarDrinkModel model) => model.toJson();

@JsonSerializable()
class BarDrinkModel extends ApiResponse {
  BarDrinkModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BarDrinkModel.fromJson(Map<String, dynamic> json) {
    return _$BarDrinkModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  int? totalRecord;
  List<BarDrinkData>? data;

  Map<String, dynamic> toJson() => _$BarDrinkModelToJson(this);
}

@JsonSerializable()
class BarDrinkData {
  BarDrinkData({
    this.barId,
    this.name,
    this.deletedAt,
    this.image,
    this.imageThumb,
    this.description,
    this.price,
    this.categoryId,
    this.category,
    this.updatedAt,
    this.sId,
    this.createdAt,
    this.shareableLink,
  });

  factory BarDrinkData.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json.isNotEmpty ? json : <String, dynamic>{});
    return _$BarDrinkDataFromJson(normalized);
  }

  String? barId;
  String? name;
  String? image;
  String? imageThumb;
  String? description;
  num? price;
  String? categoryId;
  DrinkCategoryData? category;
  String? updatedAt;
  String? deletedAt;
  @JsonKey(name: '_id')
  String? sId;
  String? createdAt;
  String? shareableLink;

  Map<String, dynamic> toJson() => _$BarDrinkDataToJson(this);
}
