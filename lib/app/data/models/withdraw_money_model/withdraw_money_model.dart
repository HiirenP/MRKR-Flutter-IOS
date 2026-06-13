import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'withdraw_money_model.g.dart';

WithdrawMoneyModel deserializeWithdrawMoneyModel(Map<String, dynamic> json) => WithdrawMoneyModel.fromJson(json);

Map<String, dynamic> serializeWithdrawMoneyModel(WithdrawMoneyModel model) => model.toJson();

@JsonSerializable()
class WithdrawMoneyModel extends ApiResponse {
  WithdrawMoneyModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory WithdrawMoneyModel.fromJson(Map<String, dynamic> json) {
    return _$WithdrawMoneyModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  WithdrawData? data;

  Map<String, dynamic> toJson() => _$WithdrawMoneyModelToJson(this);
}

@JsonSerializable()
class WithdrawData {
  WithdrawData({this.remaingAmount});

  factory WithdrawData.fromJson(Map<String, dynamic> json) {
    return _$WithdrawDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  num? remaingAmount;

  Map<String, dynamic> toJson() => _$WithdrawDataToJson(this);
}
