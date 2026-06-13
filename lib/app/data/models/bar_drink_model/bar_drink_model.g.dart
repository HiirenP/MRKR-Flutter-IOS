// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarDrinkModel _$BarDrinkModelFromJson(Map<String, dynamic> json) =>
    BarDrinkModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BarDrinkData.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    )..totalRecord = (json['totalRecord'] as num?)?.toInt();

Map<String, dynamic> _$BarDrinkModelToJson(BarDrinkModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'totalRecord': instance.totalRecord,
      'data': instance.data,
    };

BarDrinkData _$BarDrinkDataFromJson(Map<String, dynamic> json) => BarDrinkData(
      barId: json['barId'] is String ? json['barId'] as String? : json['barId']?._id?.toString(),
      name: json['name'] as String?,
      deletedAt: json['deletedAt'] as String?,
      image: json['image'] as String?,
      imageThumb: json['imageThumb'] as String?,
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
      updatedAt: json['updatedAt'] as String?,
      sId: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      shareableLink: json['shareableLink'] as String?,
    );

Map<String, dynamic> _$BarDrinkDataToJson(BarDrinkData instance) =>
    <String, dynamic>{
      'barId': instance.barId,
      'name': instance.name,
      'image': instance.image,
      'imageThumb': instance.imageThumb,
      'description': instance.description,
      'price': instance.price,
      'categoryId': instance.categoryId,
      'category': instance.category,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      '_id': instance.sId,
      'createdAt': instance.createdAt,
      'shareableLink': instance.shareableLink,
    };
