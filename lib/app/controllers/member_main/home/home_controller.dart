import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_details_model/bar_details_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class HomeController extends GetxController {
  HomeController() {
    onInit();
  }

  RxString userName = ''.obs;
  RxList<BarDetailsData> nearbyBars = <BarDetailsData>[].obs;
  RxList<RedeemedUpcomingListData> upComingMarker = <RedeemedUpcomingListData>[].obs;
  RxBool isNear = false.obs;
  final homeState = ApiState.initial().obs;
  RxBool isUpcoming = false.obs;

  Future<void> getUserData() async {
    final userData = getIt<SharedPreferences>().getUserData;
    if (userData != null) {
      userName.value = userData.name ?? '';
    }
  }

  bool isNoLocation = false;

  /// Fetch API and update data
  Future<void> fetchBarOwnerHomeData() async {
    isNoLocation = false;
    debugPrint('fetchBarOwnerHomeData------------getLatitude--------------${getIt<SharedPreferences>().getLatitude}');
    debugPrint('fetchBarOwnerHomeData------------getLongitude--------------${getIt<SharedPreferences>().getLongitude}');
    homeState.value = LoadingState();
    final coords = await resolveMemberMapCoordinates();
    final lat = coords.lat;
    final lng = coords.lng;
    isNoLocation = !coords.hasFix;
    debugPrint('Home map coordinates: $lat, $lng (hasFix=${coords.hasFix})');
    final requestData = <String, dynamic>{
      'latitude': lat,
      'longitude': lng,
    };

    await getIt<MemberService>().memberHome(requestData).handler(
      homeState,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.data != null) {
          nearbyBars.value = value.data!.nearbyBars ?? [];
          upComingMarker.value = value.data!.upcomingMarkers ?? [];
          if (nearbyBars.isNotEmpty) {
            isNear.value = true;
          }
          if (upComingMarker.isNotEmpty) {
            isUpcoming.value = true;
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
