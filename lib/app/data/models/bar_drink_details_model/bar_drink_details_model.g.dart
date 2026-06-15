// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_drink_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarDrinkDetailsModel _$BarDrinkDetailsModelFromJson(
        Map<String, dynamic> json) =>
    BarDrinkDetailsModel(
      data: json['data'] == null
          ? null
          : DrinkDetailsData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BarDrinkDetailsModelToJson(
        BarDrinkDetailsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

DrinkDetailsData _$DrinkDetailsDataFromJson(Map<String, dynamic> json) =>
    DrinkDetailsData(
      barId: json['barId'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      price: json['price'] as num?,
      categoryId: json['categoryId'] is String
          ? json['categoryId'] as String?
          : json['categoryId']?['_id']?.toString(),
      category: json['category'] is Map<String, dynamic>
          ? DrinkCategoryData.fromJson(json['category'] as Map<String, dynamic>)
          : (json['categoryId'] is Map<String, dynamic>
              ? DrinkCategoryData.fromJson(json['categoryId'] as Map<String, dynamic>)
              : null),
      latestReviews: (json['latestReviews'] as List<dynamic>?)
          ?.map((e) => LatestReviews.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviewStats: json['reviewStats'] == null
          ? null
          : ReviewStats.fromJson(json['reviewStats'] as Map<String, dynamic>),
      shareableLink: json['shareableLink'] as String?,
      myReview: json['myReview'] == null
          ? null
          : BarMyReview.fromJson(json['myReview'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DrinkDetailsDataToJson(DrinkDetailsData instance) =>
    <String, dynamic>{
      'barId': instance.barId,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'price': instance.price,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'latestReviews': instance.latestReviews,
      'reviewStats': instance.reviewStats,
      'shareableLink': instance.shareableLink,
      'myReview': instance.myReview,
    };

LatestReviews _$LatestReviewsFromJson(Map<String, dynamic> json) =>
    LatestReviews(
      sId: json['sId'] as String?,
      userId: json['userId'] == null
          ? null
          : UserId.fromJson(json['userId'] as Map<String, dynamic>),
      drinkId: json['drinkId'] == null
          ? null
          : DrinkId.fromJson(json['drinkId'] as Map<String, dynamic>),
      review: json['review'] as String?,
      stars: (json['stars'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$LatestReviewsToJson(LatestReviews instance) =>
    <String, dynamic>{
      'sId': instance.sId,
      'userId': instance.userId,
      'drinkId': instance.drinkId,
      'review': instance.review,
      'stars': instance.stars,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };

UserId _$UserIdFromJson(Map<String, dynamic> json) => UserId(
      sId: json['sId'] as String?,
      name: json['name'] as String?,
      profile: json['profile'] as String?,
    );

Map<String, dynamic> _$UserIdToJson(UserId instance) => <String, dynamic>{
      'sId': instance.sId,
      'name': instance.name,
      'profile': instance.profile,
    };

DrinkId _$DrinkIdFromJson(Map<String, dynamic> json) => DrinkId(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      price: json['price'] as num?,
    );

Map<String, dynamic> _$DrinkIdToJson(DrinkId instance) => <String, dynamic>{
      '_id': instance.sId,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'price': instance.price,
    };

ReviewStats _$ReviewStatsFromJson(Map<String, dynamic> json) => ReviewStats(
      nId: json['nId'] as String?,
      avgRating: (json['avgRating'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewStatsToJson(ReviewStats instance) =>
    <String, dynamic>{
      'nId': instance.nId,
      'avgRating': instance.avgRating,
      'total': instance.total,
    };
