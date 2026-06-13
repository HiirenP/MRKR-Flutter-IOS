// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_get_update_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarGetUpdateModel _$BarGetUpdateModelFromJson(Map<String, dynamic> json) =>
    BarGetUpdateModel(
      data: json['data'] == null
          ? null
          : BarGetUpdateData.fromJson(json['data'] as Map<String, dynamic>),
      version: json['version'] as String,
      statusCode: json['statusCode'] as num,
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BarGetUpdateModelToJson(BarGetUpdateModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'statusCode': instance.statusCode,
      'isSuccess': instance.isSuccess,
      'message': instance.message,
      'data': instance.data,
    };

BarGetUpdateData _$BarGetUpdateDataFromJson(Map<String, dynamic> json) =>
    BarGetUpdateData(
      sId: json['sId'] as String?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      ownerId: json['ownerId'] == null
          ? null
          : Owner.fromJson(json['ownerId'] as Map<String, dynamic>),
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
      isAvailabilityAdded: json['isAvailabilityAdded'] as bool?,
      averageRating: json['averageRating'] as num?,
      totalReviews: json['totalReviews'] as num?,
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      wallet: (json['wallet'] as num?)?.toInt(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      barId: json['_id'] as String?,
      drinks: (json['drinks'] as List<dynamic>?)
          ?.map((e) => BarDrinkData.fromJson(e as Map<String, dynamic>))
          .toList(),
      myReview: json['myReview'] == null
          ? null
          : BarMyReview.fromJson(json['myReview'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BarGetUpdateDataToJson(BarGetUpdateData instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'sId': instance.sId,
      'name': instance.name,
      'wallet': instance.wallet,
      'logo': instance.logo,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'email': instance.email,
      'mobile': instance.mobile,
      'location': instance.location,
      'openingHours': instance.openingHours,
      'countryFlag': instance.countryFlag,
      'images': instance.images,
      'iso': instance.iso,
      'isOpenNow': instance.isOpenNow,
      'isOpenToday': instance.isOpenToday,
      'isAvailabilityAdded': instance.isAvailabilityAdded,
      'averageRating': instance.averageRating,
      '_id': instance.barId,
      'totalReviews': instance.totalReviews,
      'owner': instance.owner,
      'drinks': instance.drinks,
      'myReview': instance.myReview,
    };

BarMyReview _$BarMyReviewFromJson(Map<String, dynamic> json) => BarMyReview(
      sId: json['_id'] as String?,
      review: json['review'] as String?,
      stars: json['stars'] as num?,
    );

Map<String, dynamic> _$BarMyReviewToJson(BarMyReview instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'review': instance.review,
      'stars': instance.stars,
    };

BarLocation _$BarLocationFromJson(Map<String, dynamic> json) => BarLocation(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      lastUpdated: json['lastUpdated'] as String?,
    );

Map<String, dynamic> _$BarLocationToJson(BarLocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'lastUpdated': instance.lastUpdated,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      sId: json['_id'] as String?,
      url: json['url'] as String?,
      urlThumb: json['urlThumb'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      '_id': instance.sId,
      'url': instance.url,
      'urlThumb': instance.urlThumb,
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) => OpeningHours(
      open: json['open'] as String?,
      close: json['close'] as String?,
    );

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'open': instance.open,
      'close': instance.close,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      sId: json['_id'] as String?,
      email: json['email'] as String?,
      profile: json['profile'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      '_id': instance.sId,
      'email': instance.email,
      'profile': instance.profile,
      'name': instance.name,
    };
