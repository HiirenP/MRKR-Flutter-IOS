import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:marker/app/data/models/bar_availability_model/bar_availability_model.dart';
import 'package:marker/app/data/models/bar_details_model/bar_details_model.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/bar_home_model/bar_home_model.dart';
import 'package:marker/app/data/models/notifications_model/notifications_model.dart';
import 'package:marker/app/data/models/owner_drink_list_model/owner_bar_drink_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/models/update_drink_model/update_drink_model.dart';
import 'package:marker/app/data/models/verify_marker_details_model/verify_marker_details_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:retrofit/retrofit.dart';

part 'bar_owner_service.g.dart';

// ignore: public_member_api_docs
Map<String, dynamic> deserializedynamic(Map<String, dynamic> json) => json;

/// Add base Url here..
@RestApi(parser: Parser.FlutterCompute, baseUrl: AppConfig.restApiBaseUrl)
@lazySingleton
abstract class BarOwnerService {
  @factoryMethod
  factory BarOwnerService(Dio dio) = _BarOwnerService;

  @POST(EndPoints.barProfileCreate)
  @MultiPart()
  Future<BarDetailsModel> barProfileCreate({
    @Part() required String name,
    @Part() required String email,
    @Part() required String address,
    @Part() required String latitude,
    @Part() required String longitude,
    @Part() required String iso,
    @Part() required String countryFlag,
    @Part() required String mobile,
    @Part() required String city,
    @Part() required String state,
    @Part() required String country,
    @Part() required String opensFrom,
    @Part() required String openTill,
    @Part(name: 'logo') File? logo,
    @Part() List<MultipartFile>? images,
  });

  @POST(EndPoints.addDrinks)
  @MultiPart()
  Future<BarDrinkModel> addDrinks({
    @Body() required FormData drinkList,
  });

  @POST(EndPoints.notifications)
  Future<NotificationsModel> notifications(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.deleteNotification)
  Future<NotificationsModel> deleteNotification(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.markerBarList)
  Future<RedeemedUpcomingModel> upcomingRedeemed(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.verify)
  Future<VerifyMarkerDetailsModel> verifyQRCode(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.markerApprovalRequest)
  Future<VerifyMarkerDetailsModel> markerRequest(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.redeem)
  Future<VerifyMarkerDetailsModel> redeem(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.barHome)
  Future<BarHomeModel> barHome();

  @PUT('/bar/drinks/{drinkId}')
  @MultiPart()
  Future<UpdateDrinkModel> updateDrinks(
    @Path('drinkId') String drinkId, {
    @Part() required String name,
    @Part() required String price,
    @Part() required String description,
    @Part() String? categoryId,
    @Part(name: 'drinksImage') File? drinksImage,
  });

  @GET(EndPoints.drinkCategoriesList)
  Future<Map<String, dynamic>> drinkCategoriesList();

  @DELETE('/bar/drinks/{drinkId}')
  Future<UpdateDrinkModel> deleteDrinks(@Path('drinkId') String drinkId);

  @POST(EndPoints.barAvailability)
  Future<BarAvailabilityModel> addBarAvailability(@Body() Map<String, dynamic> data);

  @PUT('/bar/barAvailability/update/{barId}')
  Future<BarAvailabilityModel> updateBarAvailability(
    @Path('barId') String barId,
    @Body() Map<String, dynamic> data,
  );

  @GET('/bar/barAvailability/{barId}')
  Future<BarAvailabilityModel> getBarAvailability(@Path('barId') String barId);

  @GET('/bar/drinks/{drinkId}/get')
  Future<BarDrinkDetailsModel> getDrinksDetails(
    @Path('drinkId') String drinkId,
    @Body() Map<String, dynamic> data,
  );

/*  @GET(EndPoints.owner)
  Future<BarGetUpdateModel> ownerBarDetails();*/
  @GET('/bar/{barId}/details')
  Future<BarGetUpdateModel> ownerBarDetails(
    @Path('barId') String barId,
  );

  @POST(EndPoints.listByBar)
  Future<OwnerDrinkModel> listByBarDrinks({
    @Body() required Map<String, dynamic> data,
  });

  @POST(EndPoints.markerUpdateDrink)
  Future<OwnerDrinkModel> markerUpdateDrink({
    @Body() required Map<String, dynamic> data,
  });

  @PUT('/bar/{barId}')
  Future<BarGetUpdateModel> updateBar(@Path('barId') String barId, {@Body() required FormData imagesToRemove});
}
