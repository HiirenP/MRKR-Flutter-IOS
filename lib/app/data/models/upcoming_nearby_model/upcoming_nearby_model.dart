import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_details_model/bar_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'upcoming_nearby_model.g.dart';

UpcomingNearbyModel deserializeUpcomingNearbyModel(Map<String, dynamic> json) => UpcomingNearbyModel.fromJson(json);

Map<String, dynamic> serializeUpcomingNearbyModel(UpcomingNearbyModel model) => model.toJson();

@JsonSerializable()
class UpcomingNearbyModel extends ApiResponse {
  UpcomingNearbyModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory UpcomingNearbyModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json.isNotEmpty ? json : <String, dynamic>{});
    normalized['isSuccess'] ??= normalized['isSucess'];
    final rawData = normalized['data'];
    UpcomingNearbyData? parsedData;
    if (rawData is Map<String, dynamic>) {
      parsedData = UpcomingNearbyData.fromJson(rawData);
    } else if (rawData is Map) {
      parsedData = UpcomingNearbyData.fromJson(Map<String, dynamic>.from(rawData));
    }
    return UpcomingNearbyModel(
      data: parsedData,
      version: normalized['version']?.toString() ?? '',
      statusCode: normalized['statusCode'] as num? ?? 0,
      isSuccess: normalized['isSuccess'] as bool? ?? false,
      message: normalized['message']?.toString() ?? '',
    );
  }

  UpcomingNearbyData? data;

  Map<String, dynamic> toJson() => _$UpcomingNearbyModelToJson(this);
}

@JsonSerializable()
class UpcomingNearbyData {
  UpcomingNearbyData({this.nearbyBars});

  factory UpcomingNearbyData.fromJson(Map<String, dynamic> json) {
    final nearbyRaw = json['nearbyBars'] as List<dynamic>?;
    final nearbyParsed = <BarDetailsData>[];
    if (nearbyRaw != null) {
      for (final item in nearbyRaw) {
        if (item is Map<String, dynamic>) {
          try {
            nearbyParsed.add(BarDetailsData.fromJson(item));
          } catch (_) {}
        } else if (item is Map) {
          try {
            nearbyParsed.add(BarDetailsData.fromJson(Map<String, dynamic>.from(item)));
          } catch (_) {}
        }
      }
    }

    final upcomingRaw = json['upcomingMarkers'] as List<dynamic>?;
    final upcomingParsed = <RedeemedUpcomingListData>[];
    if (upcomingRaw != null) {
      for (final item in upcomingRaw) {
        if (item is Map<String, dynamic>) {
          try {
            upcomingParsed.add(RedeemedUpcomingListData.fromJson(item));
          } catch (_) {}
        } else if (item is Map) {
          try {
            upcomingParsed.add(RedeemedUpcomingListData.fromJson(Map<String, dynamic>.from(item)));
          } catch (_) {}
        }
      }
    }

    return UpcomingNearbyData(nearbyBars: nearbyParsed)
      ..upcomingMarkers = upcomingParsed;
  }
  List<BarDetailsData>? nearbyBars;
  List<RedeemedUpcomingListData>? upcomingMarkers;

  Map<String, dynamic> toJson() => _$UpcomingNearbyDataToJson(this);
}
