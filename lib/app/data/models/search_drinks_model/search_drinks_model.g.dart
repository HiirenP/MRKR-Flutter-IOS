// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_drinks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchDrinksModel _$SearchDrinksModelFromJson(Map<String, dynamic> json) =>
    SearchDrinksModel(
      data: json['data'] == null
          ? null
          : SearchDrinksData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SearchDrinksModelToJson(SearchDrinksModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

SearchDrinksData _$SearchDrinksDataFromJson(Map<String, dynamic> json) =>
    SearchDrinksData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchDrinksList.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRecord: (json['totalRecord'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchDrinksDataToJson(SearchDrinksData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalRecord': instance.totalRecord,
    };

SearchDrinksList _$SearchDrinksListFromJson(Map<String, dynamic> json) =>
    SearchDrinksList(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as num?,
      bar: json['bar'] == null
          ? null
          : BarDrinksDetails.fromJson(json['bar'] as Map<String, dynamic>),
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
      averageRating: (json['averageRating'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchDrinksListToJson(SearchDrinksList instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'bar': instance.bar,
      'totalReviews': instance.totalReviews,
      'averageRating': instance.averageRating,
    };

BarDrinksDetails _$BarDrinksDetailsFromJson(Map<String, dynamic> json) =>
    BarDrinksDetails(
      sId: json['sId'] as String?,
      logo: json['logo'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$BarDrinksDetailsToJson(BarDrinksDetails instance) =>
    <String, dynamic>{
      'sId': instance.sId,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'logo': instance.logo,
    };
