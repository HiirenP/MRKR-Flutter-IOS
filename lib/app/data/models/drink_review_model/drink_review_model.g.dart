// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkReviewModel _$DrinkReviewModelFromJson(Map<String, dynamic> json) =>
    DrinkReviewModel(
      data: json['data'] == null
          ? null
          : DrinkReviewData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DrinkReviewModelToJson(DrinkReviewModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

DrinkReviewData _$DrinkReviewDataFromJson(Map<String, dynamic> json) =>
    DrinkReviewData(
      userId: json['userId'] as String?,
      barId: json['barId'] as String?,
      drinkId: json['drinkId'] as String?,
      review: json['review'] as String?,
      stars: (json['stars'] as num?)?.toDouble(),
      updatedAt: json['updatedAt'] as String?,
      sId: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$DrinkReviewDataToJson(DrinkReviewData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'barId': instance.barId,
      'drinkId': instance.drinkId,
      'review': instance.review,
      'stars': instance.stars,
      'updatedAt': instance.updatedAt,
      '_id': instance.sId,
      'createdAt': instance.createdAt,
    };
