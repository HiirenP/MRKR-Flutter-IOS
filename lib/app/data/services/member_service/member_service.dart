import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/blocked_user_model/blocked_user_model.dart';
import 'package:marker/app/data/models/call_token_model/call_token_model.dart';
import 'package:marker/app/data/models/drink_review_model/drink_review_model.dart';
import 'package:marker/app/data/models/friend_list_model/friend_list_model.dart';
import 'package:marker/app/data/models/friend_request_respond_model/friend_request_respond_model.dart';
import 'package:marker/app/data/models/friend_request_send_model/friend_request_send_model.dart';
import 'package:marker/app/data/models/member_user_model/member_user_model.dart';
import 'package:marker/app/data/models/near_by_model/near_by_model.dart';
import 'package:marker/app/data/models/notifications_model/notifications_model.dart';
import 'package:marker/app/data/models/payment_model/payment_model.dart';
import 'package:marker/app/data/models/review_model/review_model.dart';
import 'package:marker/app/data/models/search_drinks_model/search_drinks_model.dart';
import 'package:marker/app/data/models/upcoming_marker_details_model/upcoming_marker_details_model.dart';
import 'package:marker/app/data/models/upcoming_marker_model/upcoming_marker_model.dart';
import 'package:marker/app/data/models/upcoming_nearby_model/upcoming_nearby_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:retrofit/retrofit.dart';

part 'member_service.g.dart';

// ignore: public_member_api_docs
Map<String, dynamic> deserializedynamic(Map<String, dynamic> json) => json;

/// Add base Url here..
@RestApi(parser: Parser.FlutterCompute, baseUrl: AppConfig.restApiBaseUrl)
@lazySingleton
abstract class MemberService {
  @factoryMethod
  factory MemberService(Dio dio) = _MemberService;

  @POST(EndPoints.searchUsers)
  Future<MemberUserModel> searchMemberUserFriend(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.nearByList)
  Future<NearByModel> nearByList(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.barReviewSubmit)
  Future<DrinkReviewModel> barReviewSubmit(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.barReviewMy)
  Future<DrinkReviewModel> getMyBarReview(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.searchDrinks)
  Future<SearchDrinksModel> searchDrinksList(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.barHome)
  Future<UpcomingNearbyModel> memberHome(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.markerList)
  Future<UpcomingMarkerModel> upcomingMarkerList(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.reviewList)
  Future<ReviewModel> reviewList(
    @Body() Map<String, dynamic> data,
  );

  @GET('/bar/{barId}/details')
  Future<BarGetUpdateModel> details(
    @Path('barId') String barId,
  );

  @POST(EndPoints.friendsList)
  Future<FriendListModel> friendsList(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.sendRequest)
  Future<FriendRequestSendModel> sendRequest(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.respondRequest)
  Future<FriendRequestRespondModel> respondRequest(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.markerApprovalRespond)
  Future<FriendRequestRespondModel> markerRespondRequest(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.generateToken)
  Future<CallTokenModel> callingToken(
    @Body() Map<String, dynamic> data,
  );

  @DELETE('/friends/{friendId}')
  Future<FriendListModel> deleteFriend(
    @Path('friendId') String friendId,
  );

  @GET('/marker/{barId}')
  Future<UpcomingMarkerDetailsModel> getMarkerDetails(@Path('barId') String barId);

  @POST(EndPoints.createPaymentLink)
  Future<PaymentModel> createPaymentLink({
    @Part() required String barId,
    @Part() required String drinkId,
    @Part() required String basePrice,
    @Part() required String tip,
    @Part() required String hasTip,
  });

  @POST(EndPoints.blockUser)
  Future<MemberUserModel> blockUser(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.unBlockUser)
  Future<MemberUserModel> unBlockUser(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.blockedUsers)
  Future<BlockedUserModel> blockedUsers(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.deleteNotification)
  Future<NotificationsModel> deleteNotification(
    @Body() Map<String, dynamic> data,
  );

  @POST(EndPoints.userReports)
  Future<MemberUserModel> userReports(
    @Body() Map<String, dynamic> data,
  );
}
