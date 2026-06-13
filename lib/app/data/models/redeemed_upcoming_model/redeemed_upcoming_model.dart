import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'redeemed_upcoming_model.g.dart';

RedeemedUpcomingModel deserializeRedeemedUpcomingModel(Map<String, dynamic> json) => RedeemedUpcomingModel.fromJson(json);

Map<String, dynamic> serializeRedeemedUpcomingModel(RedeemedUpcomingModel model) => model.toJson();

@JsonSerializable()
class RedeemedUpcomingModel extends ApiResponse {
  RedeemedUpcomingModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory RedeemedUpcomingModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json.isNotEmpty ? json : <String, dynamic>{});
    normalized['isSuccess'] ??= normalized['isSucess'];
    final rawData = normalized['data'];
    RedeemedUpcomingData? parsedData;
    if (rawData is Map<String, dynamic>) {
      parsedData = RedeemedUpcomingData.fromJson(rawData);
    } else if (rawData is Map) {
      parsedData = RedeemedUpcomingData.fromJson(Map<String, dynamic>.from(rawData));
    } else if (rawData is List) {
      parsedData = RedeemedUpcomingData.fromList(rawData);
    }
    return RedeemedUpcomingModel(
      data: parsedData,
      version: normalized['version']?.toString() ?? '',
      statusCode: normalized['statusCode'] as num? ?? 0,
      isSuccess: normalized['isSuccess'] == true || normalized['isSuccess'] == 1,
      message: normalized['message']?.toString() ?? '',
    );
  }

  RedeemedUpcomingData? data;

  Map<String, dynamic> toJson() => _$RedeemedUpcomingModelToJson(this);
}

@JsonSerializable()
class RedeemedUpcomingData {
  RedeemedUpcomingData({this.totalRecord, this.data});

  factory RedeemedUpcomingData.fromJson(Map<String, dynamic> json) {
    return RedeemedUpcomingData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: _parseMarkerItems(json['data']),
    );
  }

  factory RedeemedUpcomingData.fromList(List<dynamic> rawList) {
    final items = _parseMarkerItems(rawList);
    return RedeemedUpcomingData(
      totalRecord: items.length,
      data: items,
    );
  }

  static List<RedeemedUpcomingListData> _parseMarkerItems(dynamic rawList) {
    final items = <RedeemedUpcomingListData>[];
    if (rawList is! List) return items;
    for (final item in rawList) {
      final itemMap = _asStringKeyMap(item);
      if (itemMap == null) continue;
      try {
        items.add(RedeemedUpcomingListData.fromJson(itemMap));
      } catch (e) {
        debugPrint('RedeemedUpcomingListData parse skipped: $e');
      }
    }
    return items;
  }

  static Map<String, dynamic>? _asStringKeyMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
  int? totalRecord;
  List<RedeemedUpcomingListData>? data;

  Map<String, dynamic> toJson() => _$RedeemedUpcomingDataToJson(this);
}

@JsonSerializable()
class RedeemedUpcomingListData {
  RedeemedUpcomingListData(
      {this.sId,
      this.barId,
      this.drinkId,
      this.ownerId,
      this.redeemerId,
      this.scannedBy,
      this.secretCode,
      this.basePrice,
      this.tip,
      this.totalAmount,
      this.platformFeesTotal,
      this.amountPaid,
      this.platformFeeBreakdown,
      this.status,
      this.redeemedAt,
      this.hasTip,
      this.qrCode,
      this.transactionId,
      this.transferredAt,
      this.updatedAt,
      this.createdAt});

  factory RedeemedUpcomingListData.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json.isNotEmpty ? json : <String, dynamic>{});
    normalized['barId'] = _normalizeRef(normalized['barId']);
    normalized['drinkId'] = _normalizeRef(normalized['drinkId']);
    normalized['ownerId'] = _normalizeRef(normalized['ownerId']);
    normalized['redeemerId'] = _normalizeRef(normalized['redeemerId']);
    normalized['scannedBy'] = _normalizeRef(normalized['scannedBy']);
    for (final key in ['createdAt', 'updatedAt', 'redeemedAt', 'transferredAt']) {
      if (normalized[key] != null) {
        normalized[key] = normalized[key].toString();
      }
    }
    return _$RedeemedUpcomingListDataFromJson(normalized);
  }

  static dynamic _normalizeRef(dynamic value) {
    if (value == null) return null;
    if (value is String) return {'_id': value};
    if (value is Map) {
      final copy = Map<String, dynamic>.from(value);
      final nestedOwnerId = copy['ownerId'];
      if (nestedOwnerId is String) {
        copy['ownerId'] = {'_id': nestedOwnerId};
      }
      final location = copy['location'];
      if (location != null && location is! Map) {
        copy.remove('location');
      }
      return copy;
    }
    return null;
  }

  @JsonKey(name: '_id')
  String? sId;
  BarId? barId;
  BarDrinkData? drinkId;
  Owner? ownerId;
  Owner? redeemerId;
  Owner? scannedBy;
  String? secretCode;
  num? basePrice;
  num? tip;
  num? totalAmount;
  num? platformFeesTotal;
  num? amountPaid;
  List<PlatformFeeBreakdownItem>? platformFeeBreakdown;
  String? status;
  String? redeemedAt;
  bool? hasTip;
  String? updatedAt;
  String? createdAt;
  String? qrCode;
  String? transactionId;
  String? transferredAt;
  Map<String, dynamic> toJson() => _$RedeemedUpcomingListDataToJson(this);
}

@JsonSerializable()
class PlatformFeeBreakdownItem {
  PlatformFeeBreakdownItem({this.name, this.percentage, this.amount, this.chargeType});

  factory PlatformFeeBreakdownItem.fromJson(Map<String, dynamic> json) =>
      _$PlatformFeeBreakdownItemFromJson(json);

  String? name;
  num? percentage;
  num? amount;
  String? chargeType;

  Map<String, dynamic> toJson() => _$PlatformFeeBreakdownItemToJson(this);
}

@JsonSerializable()
class BarId {
  BarId({this.location, this.sId, this.ownerId, this.logo, this.name, this.address});

  factory BarId.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final ownerId = normalized['ownerId'];
    if (ownerId is String) {
      normalized['ownerId'] = {'_id': ownerId};
    }
    final location = normalized['location'];
    if (location != null && location is! Map) {
      normalized.remove('location');
    }
    return _$BarIdFromJson(normalized);
  }
  BarLocation? location;
  @JsonKey(name: '_id')
  String? sId;
  Owner? ownerId;
  String? logo;
  String? name;
  String? address;

  Map<String, dynamic> toJson() => _$BarIdToJson(this);
}
