import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'bar_availability_model.g.dart';

BarAvailabilityModel deserializeBarAvailabilityModel(Map<String, dynamic> json) => BarAvailabilityModel.fromJson(json);

Map<String, dynamic> serializeBarAvailabilityModel(BarAvailabilityModel model) => model.toJson();

@JsonSerializable()
class BarAvailabilityModel extends ApiResponse {
  BarAvailabilityModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BarAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return _$BarAvailabilityModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  BarAvailabilityData? data;

  Map<String, dynamic> toJson() => _$BarAvailabilityModelToJson(this);
}

@JsonSerializable()
class BarAvailabilityData {
  BarAvailabilityData(
      {this.barId,
      this.daysOpen,
      this.specificDaysOff,
      this.vacation,
      this.updatedAt,
      this.sId,
      this.createdAt,
      this.iV});

  factory BarAvailabilityData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$BarAvailabilityDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  String? barId;
  List<String>? daysOpen;
  List<String>? specificDaysOff;
  List<Vacation>? vacation;
  String? updatedAt;
  String? sId;
  String? createdAt;
  int? iV;

  Map<String, dynamic> toJson() => _$BarAvailabilityDataToJson(this);
}

@JsonSerializable()
class Vacation {
  Vacation({this.fromDate, this.toDate, this.sId});

  factory Vacation.fromJson(Map<String, dynamic> json) => _$VacationFromJson(json);
  String? fromDate;
  String? toDate;
  String? sId;

  Map<String, dynamic> toJson() => _$VacationToJson(this);
}
