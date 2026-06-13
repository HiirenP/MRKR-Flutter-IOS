import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'upcoming_marker_details_model.g.dart';

UpcomingMarkerDetailsModel deserializeUpcomingMarkerDetailsModel(Map<String, dynamic> json) =>
    UpcomingMarkerDetailsModel.fromJson(json);

Map<String, dynamic> serializeUpcomingMarkerDetailsModel(UpcomingMarkerDetailsModel model) => model.toJson();

@JsonSerializable()
class UpcomingMarkerDetailsModel extends ApiResponse {
  UpcomingMarkerDetailsModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory UpcomingMarkerDetailsModel.fromJson(Map<String, dynamic> json) {
    return _$UpcomingMarkerDetailsModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  RedeemedUpcomingListData? data;

  Map<String, dynamic> toJson() => _$UpcomingMarkerDetailsModelToJson(this);
}
