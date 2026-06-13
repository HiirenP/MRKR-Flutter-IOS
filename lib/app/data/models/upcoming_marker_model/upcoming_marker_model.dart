import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'upcoming_marker_model.g.dart';

UpcomingMarkerModel deserializeUpcomingMarkerModel(Map<String, dynamic> json) => UpcomingMarkerModel.fromJson(json);

Map<String, dynamic> serializeUpcomingMarkerModel(UpcomingMarkerModel model) => model.toJson();

@JsonSerializable()
class UpcomingMarkerModel extends ApiResponse {
  UpcomingMarkerModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory UpcomingMarkerModel.fromJson(Map<String, dynamic> json) {
    return _$UpcomingMarkerModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  UpcomingMarkerData? data;

  Map<String, dynamic> toJson() => _$UpcomingMarkerModelToJson(this);
}

@JsonSerializable()
class UpcomingMarkerData {
  UpcomingMarkerData({this.totalRecord, this.data});

  factory UpcomingMarkerData.fromJson(Map<String, dynamic> json) => _$UpcomingMarkerDataFromJson(json);
  int? totalRecord;
  List<RedeemedUpcomingListData>? data;

  Map<String, dynamic> toJson() => _$UpcomingMarkerDataToJson(this);
}
