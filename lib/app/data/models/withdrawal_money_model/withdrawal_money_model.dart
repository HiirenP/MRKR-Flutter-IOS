import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'withdrawal_money_model.g.dart';

WithdrawalMoneyModel deserializeWithdrawalMoneyModel(Map<String, dynamic> json) => WithdrawalMoneyModel.fromJson(json);

Map<String, dynamic> serializeWithdrawalMoneyModel(WithdrawalMoneyModel model) => model.toJson();

@JsonSerializable()
class WithdrawalMoneyModel extends ApiResponse {
  WithdrawalMoneyModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory WithdrawalMoneyModel.fromJson(Map<String, dynamic> json) {
    return _$WithdrawalMoneyModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  WithdrawalMoneyData? data;

  Map<String, dynamic> toJson() => _$WithdrawalMoneyModelToJson(this);
}

@JsonSerializable()
class WithdrawalMoneyData {
  WithdrawalMoneyData({this.remaingAmount});

  factory WithdrawalMoneyData.fromJson(Map<String, dynamic> json) {
    return _$WithdrawalMoneyDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  RemaingAmount? remaingAmount;

  Map<String, dynamic> toJson() => _$WithdrawalMoneyDataToJson(this);
}

@JsonSerializable()
class RemaingAmount {
  RemaingAmount(
      {this.id,
      this.object,
      this.amount,
      this.amountReversed,
      this.balanceTransaction,
      this.created,
      this.currency,
      this.description,
      this.destination,
      this.destinationPayment,
      this.livemode,
      this.metadata,
      this.reversals,
      this.reversed,
      this.sourceTransaction,
      this.sourceType,
      this.transferGroup});

  factory RemaingAmount.fromJson(Map<String, dynamic> json) => _$RemaingAmountFromJson(json);
  String? id;
  String? object;
  num? amount;
  num? amountReversed;
  String? balanceTransaction;
  int? created;
  String? currency;
  String? description;
  String? destination;
  String? destinationPayment;
  bool? livemode;
  Metadata? metadata;
  Reversals? reversals;
  bool? reversed;
  String? sourceTransaction;
  String? sourceType;
  String? transferGroup;

  Map<String, dynamic> toJson() => _$RemaingAmountToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

@JsonSerializable()
class Reversals {
  Reversals({this.object, this.data, this.hasMore, this.totalCount, this.url});

  factory Reversals.fromJson(Map<String, dynamic> json) => _$ReversalsFromJson(json);
  String? object;
  List<String>? data;
  bool? hasMore;
  int? totalCount;
  String? url;

  Map<String, dynamic> toJson() => _$ReversalsToJson(this);
}
