import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'bank_details_model.g.dart';

BankDetailsModel deserializeBankDetailsModel(Map<String, dynamic> json) => BankDetailsModel.fromJson(json);

Map<String, dynamic> serializeBankDetailsModel(BankDetailsModel model) => model.toJson();

@JsonSerializable()
class BankDetailsModel extends ApiResponse {
  BankDetailsModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return _$BankDetailsModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  BankDetailsData? data;

  Map<String, dynamic> toJson() => _$BankDetailsModelToJson(this);
}

@JsonSerializable()
class BankDetailsData {
  BankDetailsData(
      {this.user,
      this.fname,
      this.lname,
      this.email,
      this.phone,
      this.bdate,
      this.bmonth,
      this.byear,
      this.identityNumber,
      this.city,
      this.addressLine1,
      this.pincode,
      this.state,
      this.accNumber,
      this.routingNumber,
      this.backImage,
      this.frontImage,
      this.stripeAccId,
      this.sId});

  factory BankDetailsData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$BankDetailsDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  String? user;
  String? fname;
  String? lname;
  String? email;
  int? phone;
  int? bdate;
  int? bmonth;
  int? byear;
  String? identityNumber;
  String? city;
  @JsonKey(name: 'address_line1')
  String? addressLine1;
  String? pincode;
  String? state;
  @JsonKey(name: 'accNumber')
  String? accNumber;
  @JsonKey(name: 'routing_number')
  String? routingNumber;
  String? backImage;
  String? frontImage;
  @JsonKey(name: 'stripe_acc_id')
  String? stripeAccId;
  @JsonKey(name: '_id')
  String? sId;

  Map<String, dynamic> toJson() => _$BankDetailsDataToJson(this);
}
