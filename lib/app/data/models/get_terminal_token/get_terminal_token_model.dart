// To parse this JSON data, do
//
//     final getTerminalToken = getTerminalTokenFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

part 'get_terminal_token_model.g.dart';

GetTerminalTokenModel getTerminalTokenFromJson(Map<String, dynamic> json) => GetTerminalTokenModel.fromJson(json);

Map<String, dynamic> getTerminalTokenToJson(GetTerminalTokenModel model) => model.toJson();

@JsonSerializable()
class GetTerminalTokenModel {
  @JsonKey(name: "secret")
  final String? secret;

  GetTerminalTokenModel({
    this.secret,
  });

  factory GetTerminalTokenModel.fromJson(Map<String, dynamic> json) => _$GetTerminalTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetTerminalTokenModelToJson(this);
}
