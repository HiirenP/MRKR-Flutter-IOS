import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_details_model/bar_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'near_by_model.g.dart';

NearByModel deserializeNearByModel(Map<String, dynamic> json) => NearByModel.fromJson(json);

Map<String, dynamic> serializeNearByModel(NearByModel model) => model.toJson();

@JsonSerializable()
class NearByModel extends ApiResponse {
  NearByModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory NearByModel.fromJson(Map<String, dynamic> json) {
    return _$NearByModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  NearByListData? data;

  Map<String, dynamic> toJson() => _$NearByModelToJson(this);
}

@JsonSerializable()
class NearByListData {
  NearByListData({this.data, this.totalRecord});

  factory NearByListData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$NearByListDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  List<BarDetailsData>? data;
  int? totalRecord;

  Map<String, dynamic> toJson() => _$NearByListDataToJson(this);
}
