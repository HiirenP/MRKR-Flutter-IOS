// connectivity_service.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityService {

  ConnectivityService() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_controller.add as void Function(List<ConnectivityResult> event)?)
            as StreamSubscription<ConnectivityResult>;
  }
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final StreamController<ConnectivityResult> _controller = StreamController<ConnectivityResult>.broadcast();

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = (await _connectivity.checkConnectivity()) as ConnectivityResult;
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
      return;
    }

    _controller.add(result);
  }

  Stream<ConnectivityResult> get connectivityStream => _controller.stream;

  void dispose() {
    _connectivitySubscription.cancel();
    _controller.close();
  }
}
