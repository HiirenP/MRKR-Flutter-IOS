import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_details_model/bar_details_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/pages/member_main/home/near_by_details_page.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';

@i.lazySingleton
@i.injectable
class MapNearByBarController extends GetxController {
  MapNearByBarController() {
    onInit();
  }

  final upcomingState = ApiState.initial().obs;
  RxList<Marker> markers = <Marker>[].obs;
  StreamSubscription<Position>? stream;
  GoogleMapController? googleMapController;
  List<BarDetailsData> listBar = [];
  Rx<LatLng> latLong = Rx<LatLng>(const LatLng(0, 0));
  RxBool isLoaded = false.obs;
  bool isFriend = false;

  void initData() {
    resetData();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final map = Get.arguments as Map<String, dynamic>;

      if (map.containsKey('isFriend')) {
        isFriend = map['isFriend'] as bool;
      }
      if (map.containsKey('latLng')) {
        // Friends location
        latLong.value = map['latLng'] as LatLng;
        isLoaded.value = true;
        debugPrint('===========wwwww=');
        fetchNearByListData();
      }
    } else {
      // Find current location
      debugPrint('============');
      checkLocationPermission();
    }
  }

  void resetData() {
    markers.value = [];
    googleMapController = null;
    listBar = [];
    latLong.value = const LatLng(0, 0);
    isLoaded.value = false;
    isFriend = false;
  }

  Future<void> checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showError('Location permission denial');
        return; // Handle permission denied
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showError('Location permission forever denial');
      return; // Handle permission denied forever
    }
    startLocationUpdates();
  }

  void startLocationUpdates() {
    stream = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 100, timeLimit: Duration(seconds: 10)))
        .listen((Position position) {
      latLong.value = LatLng(position.latitude, position.longitude);
      isLoaded.value = true;
      fetchNearByListData();
    });
  }

  Future<void> fetchNearByListData() async {
    upcomingState.value = LoadingState();

    final requestData = <String, dynamic>{
      'latitude': latLong.value.latitude,
      'longitude': latLong.value.longitude,
      'page': '1',
      'limit': 50,
    };

    await getIt<MemberService>().nearByList(requestData).handler(
      upcomingState,
      isLoading: true,
      onSuccess: (value) async {
        if (value.statusCode == 200 && value.data != null) {
          final newItems = value.data?.data ?? [];
          listBar = newItems;
          await addMarkers();
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> addMarkers() async {
    final customIcon = await AssetMapBitmap.create(
      const ImageConfiguration(size: Size(35, 35)),
      Assets.images.png.mapIcon.path,
    );
    final markerList = <Marker>[];
    for (var i = 0; i < listBar.length; i++) {
      final model = listBar[i];
      final listLocation = model.location?.coordinates ?? [];
      var latLng = const LatLng(0, 0);
      if (listLocation.length > 1) {
        latLng = LatLng(double.parse('${listLocation.last}'), double.parse('${listLocation.first}'));
      }
      markerList.add(Marker(
        markerId: MarkerId(model.barId ?? '$i'),
        position: latLng,
        infoWindow: InfoWindow(
          title: (model.name ?? '').capitalize,
          onTap: () {
            NearByDetailsPage.route(barId: model.barId ?? '', isFriend: isFriend);
          },
        ),
        icon: customIcon,
      ));
    }
    markers.value = markerList;
    debugPrint('markers-->${markers.length}');
  }
}
