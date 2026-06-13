// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'auth_model.g.dart';

AuthModel deserializeAuthModel(Map<String, dynamic> json) => AuthModel.fromJson(json);

Map<String, dynamic> serializeAuthModel(AuthModel model) => model.toJson();

@JsonSerializable()
class AuthModel extends ApiResponse {
  AuthData? data;

  AuthModel({
    this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  // Factory method to create an AuthModel from JSON
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    // Return an empty AuthModel if `data` is missing or empty
    return _$AuthModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  // Method to convert an AuthModel instance to JSON
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}

@JsonSerializable()
class AuthData {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  String? iso;
  String? email;
  String? password;
  String? mobile;
  String? profile;
  String? ucode;
  String? gender;
  String? address;
  String? country;
  String? token;
  String? channel;
  @JsonKey(name: 'isBarCreated')
  String? isBarCreated;
  @JsonKey(name: 'deviceToken')
  String? deviceToken;
  @JsonKey(name: 'deviceType')
  String? deviceType;
  @JsonKey(name: 'userType')
  String? userType;
  dynamic otpCode;
  String? deleteReason;
  String? stripeSubAccountId;
  String? isChatOpen;
  String? profileStatus;
  String? countryFlag;
  int? wallet;
  String? isBankAdded;
  bool? serviceCharge;
  bool? isConfirm;
  bool? tapToPayEnabled;

  AuthData(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.iso,
      this.address,
      this.gender,
      this.country,
      this.mobile,
      this.profile,
      this.ucode,
      this.token,
      this.deviceToken,
      this.isBarCreated,
      this.deviceType,
      this.userType,
      this.otpCode,
      this.isConfirm,
      this.deleteReason,
      this.stripeSubAccountId,
      this.isChatOpen,
      this.profileStatus,
      this.countryFlag,
      this.wallet,
      this.isBankAdded,
      this.channel,
      this.serviceCharge,
      this.tapToPayEnabled});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    // Check if the json is not empty and return a default empty AuthData if it is
    return _$AuthDataFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

RefreshTokenResponse deserializeRefreshTokenResponse(Map<String, dynamic> json) => RefreshTokenResponse.fromJson(json);

Map<String, dynamic> serializeRefreshTokenResponse(AuthModel model) => model.toJson();

@JsonSerializable()
class RefreshTokenResponse extends ApiResponse {
  const RefreshTokenResponse({
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
    required this.data,
  });

  final Map<String, dynamic> data;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) => _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

ForgotPasswordResponse deserializeForgotPasswordResponse(Map<String, dynamic> json) => ForgotPasswordResponse.fromJson(json);

Map<String, dynamic> serializeForgotPasswordResponse(ForgotPasswordResponse model) => model.toJson();

@JsonSerializable()
class ForgotPasswordResponse extends ApiResponse {
  const ForgotPasswordResponse({
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
    this.data,
  });

  final ForgotPasswordData? data;

  // Factory method to create an AuthModel from JSON
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) => _$ForgotPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordResponseToJson(this);
}

@JsonSerializable()
class ForgotPasswordData {
  @JsonKey(name: '_id')
  String? id;
  String? otpCode;
  String? email;

  ForgotPasswordData({this.id, this.otpCode, this.email});

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) => _$ForgotPasswordDataFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordDataToJson(this);
}

ForgotPasswordOTPResponse deserializeForgotPasswordOTPResponse(Map<String, dynamic> json) => ForgotPasswordOTPResponse.fromJson(json);

Map<String, dynamic> serializeForgotPasswordOTPResponse(ForgotPasswordOTPResponse model) => model.toJson();

@JsonSerializable()
class ForgotPasswordOTPResponse extends ApiResponse {
  const ForgotPasswordOTPResponse({
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
    this.data,
  });

  final ForgotPasswordOTPData? data;

  // Factory method to create an AuthModel from JSON
  factory ForgotPasswordOTPResponse.fromJson(Map<String, dynamic> json) => _$ForgotPasswordOTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordOTPResponseToJson(this);
}

@JsonSerializable()
class ForgotPasswordOTPData {
  String? userId;

  ForgotPasswordOTPData({this.userId});

  factory ForgotPasswordOTPData.fromJson(Map<String, dynamic> json) => _$ForgotPasswordOTPDataFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordOTPDataToJson(this);
}
