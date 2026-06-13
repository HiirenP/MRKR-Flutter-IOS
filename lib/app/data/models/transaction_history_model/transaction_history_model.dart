import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/common/common.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';

part 'transaction_history_model.g.dart';

TransactionHistoryWithdrawalModel deserializeTransactionHistoryWithdrawalModel(Map<String, dynamic> json) =>
    TransactionHistoryWithdrawalModel.fromJson(json);

Map<String, dynamic> serializeTransactionHistoryWithdrawalModel(TransactionHistoryWithdrawalModel model) => model.toJson();

@JsonSerializable()
class TransactionHistoryWithdrawalModel extends ApiResponse {
  TransactionHistoryWithdrawalModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory TransactionHistoryWithdrawalModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json.isNotEmpty ? json : <String, dynamic>{});
    normalized['isSuccess'] ??= normalized['isSucess'];
    return _$TransactionHistoryWithdrawalModelFromJson(normalized);
  }

  TransactionWithdrawalHistoryData? data;

  Map<String, dynamic> toJson() => _$TransactionHistoryWithdrawalModelToJson(this);
}

@JsonSerializable()
class TransactionWithdrawalHistoryData {
  TransactionWithdrawalHistoryData({this.totalRecord, this.data});

  factory TransactionWithdrawalHistoryData.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>?;
    final parsed = <TransactionWithdrawalHistoryListData>[];
    if (rawList != null) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          try {
            parsed.add(TransactionWithdrawalHistoryListData.fromJson(item));
          } catch (_) {
            // Skip malformed rows instead of failing the whole list.
          }
        } else if (item is Map) {
          try {
            parsed.add(TransactionWithdrawalHistoryListData.fromJson(Map<String, dynamic>.from(item)));
          } catch (_) {}
        }
      }
    }
    return TransactionWithdrawalHistoryData(
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
      data: parsed,
    )..wallet = json['wallet'] as num?;
  }

  int? totalRecord;
  num? wallet;
  List<TransactionWithdrawalHistoryListData>? data;

  Map<String, dynamic> toJson() => _$TransactionWithdrawalHistoryDataToJson(this);
}

@JsonSerializable()
class TransactionWithdrawalHistoryListData {
  TransactionWithdrawalHistoryListData(
      {this.sId,
      this.transactionId,
      this.paymentId,
      this.userId,
      this.barId,
      this.drinkId,
      this.transactionType,
      this.amount,
      this.serviceCharge,
      this.serviceChargePercentage,
      this.basePrice,
      this.tip,
      this.markerTotal,
      this.platformFeesTotal,
      this.platformFeeBreakdown,
      this.serviceChargeBreakdown,
      this.amountPaid,
      this.updatedAt,
      this.createdAt});

  factory TransactionWithdrawalHistoryListData.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['userId'] = _normalizeNestedRef(normalized['userId']);
    normalized['barId'] = _normalizeNestedRef(normalized['barId']);
    normalized['drinkId'] = _normalizeNestedRef(normalized['drinkId']);
    if (normalized['created_at'] != null) {
      normalized['created_at'] = normalized['created_at'].toString();
    }
    if (normalized['updated_at'] != null) {
      normalized['updated_at'] = normalized['updated_at'].toString();
    }
    final item = _$TransactionWithdrawalHistoryListDataFromJson(normalized);
    item.basePrice = normalized['basePrice'] as num?;
    item.tip = normalized['tip'] as num?;
    item.markerTotal = normalized['markerTotal'] as num?;
    item.platformFeesTotal = normalized['platformFeesTotal'] as num?;
    item.amountPaid = normalized['amountPaid'] as num?;
    item.platformFeeBreakdown = _parseFeeItems(normalized['platformFeeBreakdown']);
    item.serviceChargeBreakdown = _parseFeeItems(normalized['serviceChargeBreakdown']);
    return item;
  }

  static List<TransactionPlatformFeeItem>? _parseFeeItems(dynamic rawList) {
    if (rawList is! List) return null;
    return rawList
        .where((entry) => entry is Map)
        .map(
          (entry) => TransactionPlatformFeeItem.fromJson(
            Map<String, dynamic>.from(entry as Map),
          ),
        )
        .toList();
  }

  static dynamic _normalizeNestedRef(dynamic value) {
    if (value == null) return null;
    if (value is String) return {'_id': value};
    if (value is Map<String, dynamic>) {
      final copy = Map<String, dynamic>.from(value);
      copy.remove('location');
      return copy;
    }
    if (value is Map) {
      final copy = Map<String, dynamic>.from(value);
      copy.remove('location');
      return copy;
    }
    return null;
  }
  @JsonKey(name: '_id')
  String? sId;
  String? transactionId;
  String? paymentId;
  UserId? userId;
  BarId? barId;
  DrinkId? drinkId;
  String? transactionType;
  num? amount;
  num? serviceCharge;
  num? serviceChargePercentage;
  num? basePrice;
  num? tip;
  num? markerTotal;
  num? platformFeesTotal;
  List<TransactionPlatformFeeItem>? platformFeeBreakdown;
  List<TransactionPlatformFeeItem>? serviceChargeBreakdown;
  num? amountPaid;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'created_at')
  String? createdAt;

  num? get grossMarkerAmount {
    if (markerTotal != null && markerTotal! > 0) return markerTotal;
    return (amount ?? 0) + (serviceCharge ?? 0);
  }

  bool get hasWalletServiceChargeBreakdown =>
      (serviceCharge ?? 0) > 0 || (serviceChargePercentage ?? 0) > 0;

  bool get hasTransactionPriceBreakdown {
    if (transactionType == 'withdraw') return false;
    if (transactionType == 'debit') return true;
    if (transactionType == 'credit') {
      return (drinkId?.name ?? '').isNotEmpty || (amount ?? 0) > 0;
    }
    return false;
  }

  num get resolvedBasePrice {
    if (basePrice != null && basePrice! > 0) return basePrice!;
    final paid = amountPaid ?? amount ?? 0;
    final fees = platformFeesTotal ?? 0;
    final t = tip ?? 0;
    if (paid > fees + t) return paid - fees - t;
    return paid;
  }

  num get resolvedTip => tip ?? 0;

  num get resolvedAmountPaid {
    if (amountPaid != null && amountPaid! > 0) return amountPaid!;
    return amount ?? 0;
  }

  Map<String, dynamic> toJson() => _$TransactionWithdrawalHistoryListDataToJson(this);
}

@JsonSerializable()
class TransactionPlatformFeeItem {
  TransactionPlatformFeeItem({this.name, this.percentage, this.amount, this.chargeType});

  factory TransactionPlatformFeeItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionPlatformFeeItemFromJson(json);

  String? name;
  num? percentage;
  num? amount;
  String? chargeType;

  Map<String, dynamic> toJson() => _$TransactionPlatformFeeItemToJson(this);
}

@JsonSerializable()
class UserId {
  UserId({this.sId, this.profile, this.name});

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      sId: (json['_id'] ?? json['sId'])?.toString(),
      profile: json['profile']?.toString(),
      name: json['name']?.toString(),
    );
  }
  @JsonKey(name: '_id')
  String? sId;
  String? profile;
  String? name;

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'profile': profile,
        'name': name,
      };
}
