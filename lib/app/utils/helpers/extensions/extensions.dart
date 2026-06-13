import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesX on SharedPreferences {
  String? get getToken {
    return getString('token');
  }

  set setToken(String? value) {
    if (value == null) {
      remove('token');
    } else {
      setString('token', value);
    }
  }

  bool get getStripTerminal {
    return getBool('terminal') ?? false;
  }

  set setStripTerminal(bool? value) {
    if (value == null) {
      remove('terminal');
    } else {
      setBool('terminal', value);
    }
  }

  void removeTerminal() {
    getIt<SharedPreferences>().remove('terminal');
  }

  String? get getDeviceToken {
    return getString('deviceToken');
  }

  String? get getVOIPToken {
    return getString('voipToken');
  }

  set setLatitude(double? value) {
    if (value == null) {
      remove('latitude'); // Remove the key if the value is null
    } else {
      setDouble('latitude', value); // Store the double value
    }
  }

  double? get getLatitude {
    return getDouble('latitude'); // Retrieve the double value
  }

  set setLongitude(double? value) {
    if (value == null) {
      remove('longitude');
    } else {
      setDouble('longitude', value);
    }
  }

  double? get getLongitude {
    return getDouble('longitude');
  }

  set setDeviceToken(String? value) {
    if (value == null) {
      remove('deviceToken');
    } else {
      setString('deviceToken', value);
    }
  }

  set setDisconnect(String? value) {
    if (value == null) {
      remove('disconnect');
    } else {
      setString('disconnect', value);
    }
  }

  String? get getDisconnect {
    return getString('disconnect');
  }

  set setVoipToken(String? value) {
    if (value == null) {
      remove('voipToken');
    } else {
      setString('voipToken', value);
    }
  }

  String? get getUserId {
    return getString('UserId');
  }

  set setUserId(String? value) {
    if (value == null) {
      remove('UserId');
    } else {
      setString('UserId', value);
    }
  }

  String? get getBarId {
    return getString('barId');
  }

  set setBarId(String? value) {
    if (value == null) {
      remove('barId');
    } else {
      setString('barId', value);
    }
  }

  AuthData? get getUserData {
    final jsonString = getString('UserData');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthData.fromJson(jsonMap);
    }
    return null;
  }

  set setUserData(AuthData? authData) {
    if (authData == null) {
      remove('UserData');
    } else {
      final value = jsonEncode(authData.toJson());
      setString('UserData', value);
    }
  }

  String? get getAppLocal {
    return getString('appLocal');
  }

  set setAppLocal(String? value) {
    if (value == null) {
      remove('appLocal');
    } else {
      setString('appLocal', value);
    }
  }

  bool get getTapToPayAwarenessShown {
    return getBool('tapToPayAwarenessShown') ?? false;
  }

  set setTapToPayAwarenessShown(bool value) {
    setBool('tapToPayAwarenessShown', value);
  }

  bool get getTapToPayEnabled {
    return getBool('tapToPayEnabled') ?? false;
  }

  set setTapToPayEnabled(bool value) {
    setBool('tapToPayEnabled', value);
  }

  bool get getTapToPayEducationShown {
    return getBool('tapToPayEducationShown') ?? false;
  }

  set setTapToPayEducationShown(bool value) {
    setBool('tapToPayEducationShown', value);
  }

  String? get getCallAccept {
    return getString('callAccept');
  }

  set setCallAccept(String? value) {
    if (value == null) {
      remove('callAccept');
    } else {
      setString('callAccept', value);
    }
  }

  Future<void> clearData() async {
    await getIt<SharedPreferences>().remove('token');
    await getIt<SharedPreferences>().remove('latitude');
    await getIt<SharedPreferences>().remove('longitude');
    await getIt<SharedPreferences>().remove('token');
    await getIt<SharedPreferences>().remove('UserId');
    await getIt<SharedPreferences>().remove('barId');
    await getIt<SharedPreferences>().remove('UserData');
    await getIt<SharedPreferences>().remove('tapToPayEnabled');
    await getIt<SharedPreferences>().remove('tapToPayAwarenessShown');
    await getIt<SharedPreferences>().remove('tapToPayEducationShown');
    await getIt<SharedPreferences>().remove('tapToPayEducationShown');

    await clear();
  }
}

extension StringX on String {
  String get convertMd5 => md5.convert(utf8.encode(this)).toString();
}

extension BuildContextX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
