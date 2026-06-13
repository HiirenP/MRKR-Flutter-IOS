import 'package:json_annotation/json_annotation.dart';
import 'package:marker/app/data/models/common/common.dart';

part 'delete_account_model.g.dart';

DeleteAccountModel deserializeDeleteAccountModel(Map<String, dynamic> json) => DeleteAccountModel.fromJson(json);

Map<String, dynamic> serializeDeleteAccountModel(DeleteAccountModel model) => model.toJson();

@JsonSerializable()
class DeleteAccountModel extends ApiResponse {
  DeleteAccountModel({
    required this.data,
    required super.version,
    required super.statusCode,
    required super.isSuccess,
    required super.message,
  });

  factory DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    return _$DeleteAccountModelFromJson(json.isNotEmpty ? json : <String, dynamic>{});
  }

  List<dynamic>? data;

  Map<String, dynamic> toJson() => _$DeleteAccountModelToJson(this);
}
