import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/service/location_service.dart';

@i.lazySingleton
@i.injectable
class LocationMarkerController extends GetxController {
  LocationMarkerController() {
    onInit();
  }

  final barDetailsState = ApiState.initial().obs;
  late GoogleMapController googleMapController;
  RxList<Marker> markers = <Marker>[].obs; // Observable list
  RxList<Polyline> polyLines = <Polyline>[].obs;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  LatLng origin = const LatLng(0, 0); // San Francisco as origin
  LatLng destination = const LatLng(0, 0);
  LocationService locationService = LocationService();
  RxBool isData = false.obs;
  String? barName;
  String? averageRating;
  String distance = '';
  String? image;
  String? time;

  void distanceAll() {
    googleMapController.dispose();
    locationService.stopListening();
    barName = '';
    averageRating = '';
    image = '';
    time = '';
    distance = '';
    destination = const LatLng(0, 0);
    isData.value = false;
    markers.clear();
  }

  Future<void> barDetails({required String barId}) async {
    await getIt<MemberService>().details(barId).handler(
      barDetailsState,
      onSuccess: (value) async {
        if (value.isSuccess && value.data != null) {
          final barDetails = value.data;
          if (barDetails != null) {
            barName = barDetails.name?.capitalize ?? '';
            averageRating = '${barDetails.averageRating ?? 0}';
            image = '${barDetails.logo ?? 0}';
            time =
                '${utcToLocalTime(barDetails.openingHours?.open ?? '')}-${utcToLocalTime(barDetails.openingHours?.close ?? '')}';
            final customIcon = await AssetMapBitmap.create(
              const ImageConfiguration(size: Size(40, 40)),
              Assets.images.png.mapIcon.path,
            );
            final latLong = barDetails.location?.coordinates;
            if (latLong != null && latLong.isNotEmpty) {
              final destinationLocation = LatLng(latLong[1], latLong[0]);
              markers.add(Marker(
                markerId: MarkerId(barId),
                position: destinationLocation,
                infoWindow: InfoWindow(title: 'Destination', snippet: barDetails.address ?? ''),
                icon: customIcon,
              ));
              final distanceInMeters = Geolocator.distanceBetween(
                origin.latitude,
                origin.longitude,
                destinationLocation.latitude,
                destinationLocation.longitude,
              );
              final distanceInMi = distanceInMeters / 1609.344;
              /*final distanceDouble = FlutterMapMath.distanceBetween(origin.latitude, origin.longitude,
                  destinationLocation.latitude, destinationLocation.longitude, 'kilometers');*/
              distance = '$distanceInMi';
              await _getPolyline(destinationLocation);
            }
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> _getPolyline(LatLng destinationLocation) async {
    try {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: 'AIzaSyAgpe7Vg3ktzj4x1cLgy1wVqVs00rvctKw',
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (final point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLine();
      debugPrint('polylineCoordinates getting polyline: $polylineCoordinates');
      debugPrint('polylineCoordinates getting markers: $markers');
    } catch (e) {
      debugPrint('Error getting polyline: $e');
    }
  }

  void _addPolyLine() {
    final polyline = Polyline(
      polylineId: const PolylineId('polyline'),
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polyLines.add(polyline);
    isData.value = true;
  }

  Future<void> findCurrentLocation(String barId) async {
    final customIcon1 = await AssetMapBitmap.create(
      const ImageConfiguration(size: Size(40, 40)),
      Assets.images.png.currentLocation.path,
    );
    final started = await locationService.startListening();
    if (started) {
      final position = await locationService.getCurrentPosition();
      if (position != null) {
        origin = LatLng(position.latitude, position.longitude);
        markers.add(Marker(
          markerId: const MarkerId('origin'),
          position: origin,
          infoWindow: const InfoWindow(title: 'Origin', snippet: 'Current Location'),
          icon: customIcon1,
        ));
        debugPrint('origin-->$origin');
        await barDetails(barId: barId);
      }
    }
  }
}
