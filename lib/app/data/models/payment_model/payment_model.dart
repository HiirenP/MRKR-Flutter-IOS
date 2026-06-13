import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'payment_model.g.dart';

PaymentModel deserializePaymentModel(Map<String, dynamic> json) => PaymentModel.fromJson(json);

Map<String, dynamic> serializePaymentModel(PaymentModel model) => model.toJson();

@JsonSerializable()
class PaymentModel extends ApiResponse {
  PaymentModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return _$PaymentModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  PaymentData? data;

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}

@JsonSerializable()
class PaymentData {
  PaymentData({this.clientSecret, this.transactionId, this.callback, this.publicKey});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$PaymentDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  String? clientSecret;
  String? transactionId;
  String? callback;
  String? publicKey;

  Map<String, dynamic> toJson() => _$PaymentDataToJson(this);
}
