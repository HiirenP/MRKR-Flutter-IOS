import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'verify_marker_details_model.g.dart';

VerifyMarkerDetailsModel deserializeVerifyMarkerDetailsModel(Map<String, dynamic> json) => VerifyMarkerDetailsModel.fromJson(json);

Map<String, dynamic> serializeVerifyMarkerDetailsModel(VerifyMarkerDetailsModel model) => model.toJson();

@JsonSerializable()
class VerifyMarkerDetailsModel extends ApiResponse {
  VerifyMarkerDetailsModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory VerifyMarkerDetailsModel.fromJson(Map<String, dynamic> json) {
    return _$VerifyMarkerDetailsModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  VerifyMarkerData? data;

  Map<String, dynamic> toJson() => _$VerifyMarkerDetailsModelToJson(this);
}

@JsonSerializable()
class VerifyMarkerData {
  VerifyMarkerData({this.marker, this.requiresApproval});

  factory VerifyMarkerData.fromJson(Map<String, dynamic> json) => _$VerifyMarkerDataFromJson(json);

  RedeemedUpcomingListData? marker;
  bool? requiresApproval;
  String? markerId;
  String? originalBarName;
  num? markerPrice;
  String? scannedBarName;
  String? drinkName;

  Map<String, dynamic> toJson() => _$VerifyMarkerDataToJson(this);
}
