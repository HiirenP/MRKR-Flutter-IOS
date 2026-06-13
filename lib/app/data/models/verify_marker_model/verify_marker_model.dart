import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'verify_marker_model.g.dart';

VerifyMarkerModel deserializeVerifyMarkerModel(Map<String, dynamic> json) => VerifyMarkerModel.fromJson(json);

Map<String, dynamic> serializeVerifyMarkerModel(VerifyMarkerModel model) => model.toJson();

@JsonSerializable()
class VerifyMarkerModel extends ApiResponse {
  VerifyMarkerModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory VerifyMarkerModel.fromJson(Map<String, dynamic> json) {
    return _$VerifyMarkerModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }
  VerifyMarkerData? data;
  Map<String, dynamic> toJson() => _$VerifyMarkerModelToJson(this);
}

@JsonSerializable()
class VerifyMarkerData {
  VerifyMarkerData({this.marker, this.requiresApproval});

  factory VerifyMarkerData.fromJson(Map<String, dynamic> json) => _$VerifyMarkerDataFromJson(json);
  Marker? marker;
  bool? requiresApproval;

  Map<String, dynamic> toJson() => _$VerifyMarkerDataToJson(this);
}

@JsonSerializable()
class Marker {
  Marker(
      {this.sId,
      this.barId,
      this.drinkId,
      this.ownerId,
      this.redeemerId,
      this.secretCode,
      this.qrCode,
      this.basePrice,
      this.tip,
      this.totalAmount,
      this.status,
      this.transactionId,
      this.redeemedAt,
      this.transferredAt,
      this.hasTip,
      this.updatedAt,
      this.createdAt});

  factory Marker.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$MarkerFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  String? sId;
  BarId? barId;
  DrinkId? drinkId;
  Owner? ownerId;
  Owner? redeemerId;
  String? secretCode;
  String? qrCode;
  num? basePrice;
  num? tip;
  num? totalAmount;
  String? status;
  String? transactionId;
  String? redeemedAt;
  String? transferredAt;
  bool? hasTip;
  String? updatedAt;
  String? createdAt;
  Map<String, dynamic> toJson() => _$MarkerToJson(this);
}

@JsonSerializable()
class BarId {
  BarId({this.location, this.sId, this.ownerId, this.logo, this.name, this.address});

  factory BarId.fromJson(Map<String, dynamic> json) => _$BarIdFromJson(json);
  BarLocation? location;
  String? sId;
  Owner? ownerId;
  String? logo;
  String? name;
  String? address;

  Map<String, dynamic> toJson() => _$BarIdToJson(this);
}
