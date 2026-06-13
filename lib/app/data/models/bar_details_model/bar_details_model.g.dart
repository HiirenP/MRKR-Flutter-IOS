// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarDetailsModel _$BarDetailsModelFromJson(Map<String, dynamic> json) =>
    BarDetailsModel(
      data: json['data'] == null
          ? null
          : BarDetailsData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BarDetailsModelToJson(BarDetailsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

BarDetailsData _$BarDetailsDataFromJson(Map<String, dynamic> json) =>
    BarDetailsData(
      sId: json['sId'] as String?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      logoThumb: json['logoThumb'] as String?,
      ownerId: json['ownerId'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      location: json['location'] == null
          ? null
          : BarLocation.fromJson(json['location'] as Map<String, dynamic>),
      openingHours: json['openingHours'] == null
          ? null
          : OpeningHours.fromJson(json['openingHours'] as Map<String, dynamic>),
      countryFlag: json['countryFlag'] as String?,
      iso: json['iso'] as String?,
      isOpenNow: json['isOpenNow'] as bool?,
      isOpenToday: json['isOpenToday'] as bool?,
      averageRating: json['averageRating'],
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      wallet: (json['wallet'] as num?)?.toInt(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance: (json['distance'] as num?)?.toDouble(),
      distanceMi: (json['distanceMi'] as num?)?.toDouble(),
      serviceCharge: json['serviceCharge'] as bool?,
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      barId: json['_id'] as String?,
      drinks: (json['drinks'] as List<dynamic>?)
          ?.map((e) => BarDrinkData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BarDetailsDataToJson(BarDetailsData instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'sId': instance.sId,
      'name': instance.name,
      'wallet': instance.wallet,
      'logo': instance.logo,
      'logoThumb': instance.logoThumb,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'distance': instance.distance,
      'distanceMi': instance.distanceMi,
      'country': instance.country,
      'createdAt': instance.createdAt,
      'email': instance.email,
      'mobile': instance.mobile,
      'location': instance.location,
      'openingHours': instance.openingHours,
      'countryFlag': instance.countryFlag,
      'images': instance.images,
      'iso': instance.iso,
      'isOpenNow': instance.isOpenNow,
      'isOpenToday': instance.isOpenToday,
      'serviceCharge': instance.serviceCharge,
      'averageRating': instance.averageRating,
      '_id': instance.barId,
      'totalReviews': instance.totalReviews,
      'reviewCount': instance.reviewCount,
      'owner': instance.owner,
      'drinks': instance.drinks,
    };
