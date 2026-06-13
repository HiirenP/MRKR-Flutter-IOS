/*
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/location_permmission.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  factory LocationService() => _instance;

  LocationService._internal();

  static final LocationService _instance = LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  Position? currentPosition;

  Future<void> startListening() async {
    debugPrint('---------------startListening------------');

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled. Please enable them in settings.');
      // Optionally, show a dialog to the user
      await Get.toNamed(AppRoutes.locationPermission);
      return; // Exit if services are not enabled
    } else {
      await Get.offAllNamed(AppRoutes.mainPage);
    }
    // Check and request location permission
    var permission = await Geolocator.checkPermission();
    debugPrint('Current permission status: $permission');

    if (permission == LocationPermission.denied) {
      debugPrint('Requesting permission...');
      permission = await Geolocator.requestPermission();
      debugPrint('New permission status: $permission');
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      debugPrint('Location permission denied. Cannot proceed.');
      return; // Exit if permission is denied
    }
    if (_positionStream != null) {
      debugPrint('Stopping existing location listener.');
      await stopListening();
    }

    // Start listening to location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 2),
      ),
    ).listen((Position position) {
      debugPrint('Position updated: ${position.latitude}, ${position.longitude}');
      getIt<SharedPreferences>().setLatitude = position.latitude;
      getIt<SharedPreferences>().setLongitude = position.longitude;
    }, onError: (error) {
      debugPrint('Error while listening to location updates: $error');
    });
  }

  Future<void> stopListening() async {
    if (_positionStream != null) {
      await _positionStream!.cancel();
      _positionStream = null;
      debugPrint('Stopped listening to location updates.');
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }
}
*/
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  factory LocationService() => _instance;

  LocationService._internal();

  static final LocationService _instance = LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  Position? currentPosition;

  Future<bool> startListening() async {
    debugPrint('---------------startListening------------');

    // 1. Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled. Redirecting to permission page...');
      await Get.toNamed(AppRoutes.locationPermission);
      return false;
    }

    // 2. Check location permission status
    var permission = await Geolocator.checkPermission();
    debugPrint('Current permission status: $permission');

    if (permission == LocationPermission.denied) {
      debugPrint('Requesting permission...');
      permission = await Geolocator.requestPermission();
      debugPrint('New permission status: $permission');
    }

    // 3. Handle permission denial
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      debugPrint('Permission denied permanently or not granted. Cannot continue.');
      return false;
    }

    // 4. Get and save current position once
    try {
      final position = await Geolocator.getCurrentPosition();
      debugPrint('Initial position: ${position.latitude}, ${position.longitude}');
      getIt<SharedPreferences>().setLatitude = position.latitude;
      getIt<SharedPreferences>().setLongitude = position.longitude;
    } catch (e) {
      debugPrint('Error getting initial position: $e');
    }

    // 5. Start streaming updates
    await stopListening(); // Stop any existing stream
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
          (Position position) {
        debugPrint('Position updated: ${position.latitude}, ${position.longitude}');
        getIt<SharedPreferences>().setLatitude = position.latitude;
        getIt<SharedPreferences>().setLongitude = position.longitude;
      },
      onError: (error) {
        debugPrint('Location stream error: $error');
      },
    );

    return true;
  }


  Future<void> stopListening() async {
    if (_positionStream != null) {
      await _positionStream!.cancel();
      _positionStream = null;
      debugPrint('Stopped listening to location updates.');
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }
}
