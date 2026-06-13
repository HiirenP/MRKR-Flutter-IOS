import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'call_token_model.g.dart';

CallTokenModel deserializeCallTokenModel(Map<String, dynamic> json) => CallTokenModel.fromJson(json);

Map<String, dynamic> serializeCallTokenModel(CallTokenModel model) => model.toJson();

@JsonSerializable()
class CallTokenModel extends ApiResponse {
  CallTokenModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory CallTokenModel.fromJson(Map<String, dynamic> json) {
    return _$CallTokenModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  TokenDataModel? data;

  Map<String, dynamic> toJson() => _$CallTokenModelToJson(this);
}

@JsonSerializable()
class TokenDataModel {
  TokenDataModel({
    this.uid,
    this.channel,
    this.token,
    this.randomID,
  });

  factory TokenDataModel.fromJson(Map<String, dynamic> json) => _$TokenDataModelFromJson(json);

  String? uid;
  String? channel;
  String? token;
  num? randomID;

  Map<String, dynamic> toJson() => _$TokenDataModelToJson(this);
}
