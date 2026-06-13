// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      data: json['data'] == null
          ? null
          : ReviewData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

ReviewData _$ReviewDataFromJson(Map<String, dynamic> json) => ReviewData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReviewListData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewDataToJson(ReviewData instance) =>
    <String, dynamic>{
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

ReviewListData _$ReviewListDataFromJson(Map<String, dynamic> json) =>
    ReviewListData(
      sId: json['_id'] as String?,
      userId: json['userId'] == null
          ? null
          : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      barId: json['barId'] == null
          ? null
          : BarId.fromJson(json['barId'] as Map<String, dynamic>),
      review: json['review'] as String?,
      stars: (json['stars'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ReviewListDataToJson(ReviewListData instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'userId': instance.userId,
      'barId': instance.barId,
      'review': instance.review,
      'stars': instance.stars,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };
