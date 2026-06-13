import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'owner_bar_drink_model.g.dart';

OwnerDrinkModel deserializeOwnerDrinkModel(Map<String, dynamic> json) => OwnerDrinkModel.fromJson(json);

Map<String, dynamic> serializeOwnerDrinkModel(OwnerDrinkModel model) => model.toJson();

@JsonSerializable()
class OwnerDrinkModel extends ApiResponse {
  OwnerDrinkModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory OwnerDrinkModel.fromJson(Map<String, dynamic> json) {
    return _$OwnerDrinkModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  OwnerDrinkData? data;

  Map<String, dynamic> toJson() => _$OwnerDrinkModelToJson(this);
}

@JsonSerializable()
class OwnerDrinkData {
  OwnerDrinkData({this.totalRecord, this.data});

  factory OwnerDrinkData.fromJson(Map<String, dynamic> json) => _$OwnerDrinkDataFromJson(json);
  int? totalRecord;
  List<BarDrinkData>? data;

  Map<String, dynamic> toJson() => _$OwnerDrinkDataToJson(this);
}
