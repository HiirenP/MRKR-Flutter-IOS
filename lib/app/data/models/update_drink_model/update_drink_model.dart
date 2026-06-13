import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'update_drink_model.g.dart';

UpdateDrinkModel deserializeUpdateDrinkModel(Map<String, dynamic> json) => UpdateDrinkModel.fromJson(json);

Map<String, dynamic> serializeUpdateDrinkModel(UpdateDrinkModel model) => model.toJson();

@JsonSerializable()
class UpdateDrinkModel extends ApiResponse {
  UpdateDrinkModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory UpdateDrinkModel.fromJson(Map<String, dynamic> json) {
    return _$UpdateDrinkModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  BarDrinkData? data;

  Map<String, dynamic> toJson() => _$UpdateDrinkModelToJson(this);
}
