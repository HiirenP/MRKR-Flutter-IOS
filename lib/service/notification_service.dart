import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/controllers/member_main/message/video_call_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/ui/pages/member_main/main_page/main_page.dart';
import 'package:marker/app/ui/pages/member_main/message/chat_page.dart';
import 'package:marker/app/ui/pages/member_main/message/video_call_page.dart';
import 'package:marker/app/ui/pages/member_main/notifications/notifications_page.dart';
import 'package:marker/app/ui/pages/splash_screen.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.config.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

bool isVideoNavigate = false;
String? fromCallScreen;

final StreamController<NotificationResponse> selectNotificationStream = StreamController<NotificationResponse>.broadcast();

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');
const MethodChannel callkitPlatform = MethodChannel('com.marker.app/call_kit');
const String portName = 'notification_send_port';
String? selectedNotificationPayload;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse notificationResponse) async {
  debugPrint('Notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint('Notification action tapped with input: ${notificationResponse.input}');
  }
  if (AppConstant.userType == UserType.member) {
    final jsonString = notificationResponse.data as String;
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    if (data['type'].toString() == 'new_message') {
      final modelChat = ChatDataModel.fromJson({
        'user_detail': {
          '_id': data['data']['user_detail']['_id'].toString(),
          'name': data['data']['user_detail']['name'].toString(),
          'friendId': data['data']['friendId'].toString(),
          'profile': data['data']['user_detail']['profile'].toString()
        },
        'lastMessage': null
      });
      log("data['type']--0000000<<>>${jsonEncode(modelChat)}");
      await ChatPage.route(modelChat);
    } else {
      await MainPage.route(selectedIndex: 3, from: 'Noti1');
    }
  } else {
    await NotificationsPage.route();
  }
}

@pragma('vm:entry-point') // Required for background execution
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('payloadData check Background check${message.messageId}');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await getIt.reset();
  await getIt.init();
  try {
    setupCallKitListeners();
    debugPrint('payloadData check Background ${message.messageId}');
    final prefs = await SharedPreferences.getInstance();
    final keyMessageId = prefs.getString('key_sender_id');
    String? date;
    if (message.data.containsKey('date')) {
      if (message.data['date'] is int?) {
        date = '${message.data['date']}';
      } else {
        date = message.data['date'] as String?;
      }
    }
    // Only prevent duplicates if it's the same message within a short time window
    if (keyMessageId != null && keyMessageId == date) {
      debugPrint('Duplicate message detected, skipping...');
      return;
    }
    await prefs.setString('key_sender_id', date ?? '');
    // Store the message ID to prevent duplicates
    debugPrint('message.data------------: ${message.data}');
    if (message.data['data'] == null || message.data['data'] is Map && (message.data['data'] as Map).isEmpty) {
      return;
    }
    // Extract and decode the inner JSON string
    final jsonString = message.data['data'] as String;
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    if (data['type'] == 'call_ended') {
      await flutterLocalNotificationsPlugin.cancelAll();
      await FlutterCallkitIncoming.endAllCalls();
    } else {
      final isVoiceType = data['type'] == 'voice';
      debugPrint('🔥 Is voice type? ---> $isVoiceType');
      debugPrint('🔥 data? ---> $data');
      if (isVoiceType) {
        // Clean up any existing call state
        await flutterLocalNotificationsPlugin.cancelAll();
        // await FlutterCallkitIncoming.endAllCalls();
        debugPrint('Incoming voice call detected');
        try {
          getIt<BaseHomeController>().socketConnectSetup();
        } catch (e) {
          debugPrint('Base controller not found');
        }
        final callerName = data['name'] as String;
        final callerProfile = data['profile'] as String;
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('call_data', jsonEncode(data));
        await showCallkitIncoming(callId, callerName, callerProfile, map: message.data, from: 'on-background');
      } else {
        if (message.notification != null) {
          debugPrint('Handling a background message: ${message.data}');
          debugPrint('title: ${jsonEncode(message.notification?.title)}');
          debugPrint('body: ${jsonEncode(message.notification?.body)}');
          final userData = getIt<SharedPreferences>().getUserData;
          if (userData != null) {
            AppConstant.userType = UserTypeExtension.fromString(userData.userType);
          }
          if (AppConstant.userType == UserType.member) {
            log("firebase_background_data['type']--<<>>${data['type']}");
            if (data['type'].toString() == 'new_message') {
              final modelChat = ChatDataModel.fromJson({
                'user_detail': {
                  '_id': data['data']['user_detail']['_id'].toString(),
                  'name': data['data']['user_detail']['name'].toString(),
                  'friendId': data['data']['friendId'].toString(),
                  'profile': data['data']['user_detail']['profile'].toString()
                },
                'lastMessage': null
              });
              await ChatPage.route(modelChat);
            } else if (data['type'].toString() == 'call_rejected') {
            } else {
              await MainPage.route(selectedIndex: 3, from: 'Noti2');
            }
          } else {
            await NotificationsPage.route();
          }
        }
      }
    }
  } catch (e) {
    debugPrint('Background Exception while handling message: $e');
  }
}

void setupCallKitListeners() {
  FlutterCallkitIncoming.onEvent.listen((event) async {
    // debugPrint('📞 CallKit event-->: $event');
    final eventName = event!.event;
    final body = event.body;
    debugPrint('📞 CallKit event: $eventName');
    debugPrint('📞 Event body: $body');
    var extra = <String, dynamic>{};
    final rawExtra = body['extra'];

    if (rawExtra is Map) {
      extra = Map<String, dynamic>.from(rawExtra);
    } else if (rawExtra is String) {
      try {
        extra = Map<String, dynamic>.from(json.decode(rawExtra) as Map<String, dynamic>);
      } catch (e) {
        debugPrint('❌ Failed to parse "extra": $e');
      }
    } else {
      debugPrint('⚠️ "extra" is not a Map or JSON string.>>$extra');
    }
    // Get call ID from extra data
    final prefs = await SharedPreferences.getInstance();

    switch (eventName) {
      case Event.actionCallAccept:
        // Store new call state
        Map<String, dynamic>? data;
        if (extra.containsKey('data') && extra['data'] is String) {
          final temp = extra['data'] as String?;
          if (temp != null) {
            data = jsonDecode(temp) as Map<String, dynamic>?;
          }
        } else if (extra.containsKey('data') && extra['data'] is Map<String, dynamic>) {
          data = extra['data'] as Map<String, dynamic>?;
        } else {
          data = extra;
        }
        final uuid = event.body?['id'].toString();
        if (Platform.isAndroid) {
          await prefs.setString('call_data', jsonEncode(data));
        }
        getIt<SharedPreferences>().setCallAccept = '1';
        debugPrint('✅ Call accepted--');
        await prefs.setString('key_sender_id', '');
        if (Platform.isAndroid) await prefs.setBool('remote_user_declined', false);
        getIt<SharedPreferences>().setDisconnect = 'false';

        if (data != null) {
          await VideoCallPage.route(model: data);
          await FlutterCallkitIncoming.endAllCalls();
          await flutterLocalNotificationsPlugin.cancelAll();
        }

        return;
      case Event.actionCallDecline:
        // --- Aggressive, Unconditional Cleanup ---
        await prefs.remove('call_data');
        await prefs.setString('uuid_call', '');
        await prefs.setString('key_sender_id', '');

        debugPrint('❌ Call declined event received. Cleaning up immediately.');
        Map<String, dynamic>? data;
        if (extra.containsKey('data') && extra['data'] is String) {
          final temp = extra['data'] as String?;
          if (temp != null) {
            data = jsonDecode(temp) as Map<String, dynamic>?;
          }
        } else if (extra.containsKey('data') && extra['data'] is Map<String, dynamic>) {
          data = extra['data'] as Map<String, dynamic>?;
        } else {
          data = extra;
        }
        callId = null; // Reset global call ID.

        if (Platform.isIOS) {
          await MainPage.route(from: 'iOS-Declined', data: data);
        } else {
          await callDeclined(data);
        }
        return;
      case Event.actionCallEnded:
        await prefs.setString('uuid_call', '');
        await prefs.setString('key_sender_id', '');
        // await Future.delayed(const Duration(seconds: 5));
        // await prefs.setString('call_data', '');
        callId = null; // Reset global callId
        debugPrint('📴 Call ended');
        return;
      case Event.actionCallTimeout:
        await prefs.remove('call_data');
        await prefs.setString('uuid_call', '');
        await prefs.setString('key_sender_id', '');
        callId = null; // Reset global callId
        debugPrint('⌛ Call timed out');
        return;
      default:
        debugPrint('ℹ️ Unhandled CallKit event: $eventName');
    }
  });
  // Handle cold-start: check if app was opened via CallKit action
  _handleInitialCallEvent();
  if (Platform.isAndroid) {
    // Also subscribe for immediate native push when app already running
    callkitPlatform.setMethodCallHandler((call) async {
      if (call.method == 'onCallkitEvent') {
        final args = call.arguments;
        if (args is Map) {
          final action = args['action'] as String?;
          final extras = (args['extras'] is Map) ? Map<String, dynamic>.from(args['extras'] as Map) : null;
          if (action != null && action.contains('ACTION_CALL_ACCEPT')) {
            await PushNotifications._handleCallkitAcceptFromExtras(extras);
          }
        }
      }
    });
  }
}

Future<void> callDeclined(Map<String, dynamic>? data) async {
// --- THE FIX: START ---
  // When the app is killed, the main socket isn't connected.
  // We must create a temporary, one-off socket connection just to emit the
  // 'reject call' event to the server.
  final userId = getIt<SharedPreferences>().getUserId;
  debugPrint('Temporary socket callDeclined to reject call.>>$userId');

  if (userId != null) {
    try {
      final socket = AppConstant.instance.socket;
      final isConnected = socket?.connected ?? false;
      if (isConnected) {
        debugPrint('--------NO NEED TO AGAIN CREATE SOCKET--------');
        socket!.emit(AppConstant.instance.emitRejectCall, {'userId': userId, 'receiverUserId': data?['userId'], 'channelId': data?['channel']});
      } else {
        final socket = IO.io(AppConfig.socketUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
          'forceNew': true, // Important to ensure a new connection
        });
        socket.onConnect((_) {
          debugPrint('✅ Temporary socket connected to reject call.($userId)[${data?['userId']}]{${data?['channel']}');
          socket.emit(AppConstant.instance.emitSocketJoin, {'userId': userId});
          socket.emit(AppConstant.instance.emitRejectCall, {'userId': userId, 'receiverUserId': data?['userId'], 'channelId': data?['channel']});
          // Disconnect after a short delay to ensure the message is sent.
          Future.delayed(const Duration(seconds: 2), () {
            socket.disconnect();
            debugPrint('✅ Temporary socket disconnected.');
          });
        });
        socket.onConnectError((error) {
          debugPrint('❌ Temporary socket connection error: $error');
        });
        socket.onError((error) {
          debugPrint('❌ Temporary socket error: $error');
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to create temporary socket: $e');
    }
  }
  // --- THE FIX: END ---

  // The original cleanup logic remains crucial to clean the local device state.
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('call_data');
  // Clean up call state completely
  await FlutterCallkitIncoming.endAllCalls();
  await flutterLocalNotificationsPlugin.cancelAll();
  // Reset all call-related state aggressively
  await prefs.setString('uuid_call', '');
  await prefs.setString('key_sender_id', '');
}

String? callId;
String? dateCheck;

Future<void> showCallkitIncoming(String? messageId, String callerName, String callerProfile, {Map<String, dynamic>? map, String from = ''}) async {
  debugPrint('date------------: ${map?['date']}');
  debugPrint('dateCheck------------: $dateCheck');
  if (Platform.isAndroid) {
    await FlutterCallkitIncoming.endAllCalls();
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('uuid_call');
    debugPrint('id------------: $id');
    debugPrint('from------------: $from');
    debugPrint('userId-callId------------: $callId');

    // Reset callId to null to ensure fresh state for each call
    if (callId != null && callId == id && from != 'on-message') {
      debugPrint('Call already handled');
      await prefs.setString('uuid_call', '');
      callId = null;
      return;
    }
    // Generate new UUID for each incoming call
    callId = const Uuid().v4();
    await prefs.setString('uuid_call', callId ?? '');
  }

  final params = CallKitParams(
    id: callId,
    nameCaller: callerName,
    appName: 'Marker',
    avatar: callerProfile,
    handle: '0123456789',
    type: 1,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Cancel',
    missedCallNotification: const NotificationParams(
      showNotification: false,
      isShowCallback: false,
      subtitle: 'Missed call',
      // callbackText: 'Call back',
    ),
    callingNotification: const NotificationParams(
      showNotification: false,
      isShowCallback: false,
      subtitle: '',
      // callbackText: 'Call back',
    ),
    extra: map ?? <String, dynamic>{'messageId': messageId},
    headers: <String, dynamic>{'from': from},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: true,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      actionColor: '#4CAF50',
      textColor: '#ffffff',
    ),
    ios: const IOSParams(
      iconName: 'CallKitIcon',
      handleType: 'number',
      supportsVideo: true,
      maximumCallGroups: 1,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );

  // Show the incoming call UI
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // Get the FCM device token
  static Future<String?> getDeviceToken({int maxRetries = 2}) async {
    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('For Firebase device token: $token');
      getIt<SharedPreferences>().setDeviceToken = token;
      return token;
    } catch (e) {
      debugPrint('Error device token: $e');
      if (maxRetries > 0) {
        await Future.delayed(const Duration(seconds: 10));
        return getDeviceToken(maxRetries: maxRetries - 1);
      } else {
        return null;
      }
    }
  }

  static Future<void> localNotiInit() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Only create channel on Android
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }
    AppConstant.instance.isRejected = false;
    AppConstant.instance.isAccepted = false;
    callId = null;
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
    // await FlutterCallkitIncoming.requestFullIntentPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('CALL--->${message.data}');
      if (message.data.isEmpty) {
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      final keyMessageId = prefs.getString('key_sender_id');

      if (message.data.containsKey('date')) {
        if (message.data['date'] is int?) {
          dateCheck = '${message.data['date']}';
        } else {
          dateCheck = message.data['date'] as String?;
        }
      }
      if (keyMessageId != null && keyMessageId == dateCheck) {
        debugPrint('======');
        return;
      }
      await prefs.setString('key_sender_id', dateCheck ?? '');
      final payloadData = jsonEncode(message.data);
      debugPrint('Got a message in foreground ${message.notification?.body}');
      debugPrint('Got a message in foreground ${message.notification?.title}');
      if (message.notification?.body?.contains('rejected your marker') ?? false) {
        AppConstant.instance.isRejected = true;
      } else if (message.notification?.body?.contains('redeemed') ?? false) {
        AppConstant.instance.isAccepted = true;
      }
      try {
        // Extract and decode the inner JSON string
        final jsonString = message.data['data'];
        if (jsonString == null) {
          debugPrint('empty.message.data---no move---------: ${message.data}');
          return;
        }
        Map<String, dynamic>? data;
        if (jsonString is String) {
          final temp = jsonString;
          if (temp.isNotEmpty) {
            data = jsonDecode(temp) as Map<String, dynamic>?;
          }
        } else {
          data = jsonString as Map<String, dynamic>;
        }

        if (data != null) {
          if (data['type'] == 'call_ended') {
            await flutterLocalNotificationsPlugin.cancelAll();
            await FlutterCallkitIncoming.endAllCalls();
          } else if (data['type'].toString() == 'call_rejected') {
            await flutterLocalNotificationsPlugin.cancelAll();
            await FlutterCallkitIncoming.endAllCalls();
            Get.back();
          } else {
            final isVoiceType = data['type'] == 'voice';
            debugPrint('🔥 type ---> ${data['type']}');
            debugPrint('🔥 Is voice type? ---> $isVoiceType');
            if (isVoiceType) {
              // Clean up any existing call state
              await flutterLocalNotificationsPlugin.cancelAll();
              await FlutterCallkitIncoming.endAllCalls();
              debugPrint('Incoming voice call detected-->$data');

              final callerName = data['name'] as String;
              final callerProfile = data['profile'] as String;

              await showCallkitIncoming(message.messageId, callerName, callerProfile,
                  map: {
                    ...data,
                    'fromChat': false,
                  },
                  from: 'on-message');
            } else if (message.notification != null) {
              final notificationBody = message.notification!.body;
              await PushNotifications.showSimpleNotification(
                  title: message.notification!.title ?? 'No Title',
                  body: notificationBody == null || notificationBody.isEmpty
                      ? 'No Body'
                      : formatNotificationBody(notificationBody),
                  payload: payloadData);
            }
          }
        }
      } catch (e) {
        debugPrint('Exception while handling message: $e');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('🔥 onMessageOpenedApp called--->${message.data}');

      // Extract and decode the inner JSON string
      final jsonString = message.data['data'] as String;
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final isVoiceType = data['type'] == 'voice';
      debugPrint('🔥 Is voice type? ---> $isVoiceType');

      if (message.notification != null) {
        debugPrint('Notification opened: $data');

        if (isVoiceType) {
          debugPrint('<<<<Incoming voice call detected>>>>');

          if (data.isNotEmpty) {
            debugPrint('<<<<Incoming voice call detected>>>>data found');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('call_data', jsonEncode(data));
            await prefs.setBool('remote_user_declined', false);
            getIt<SharedPreferences>().setDisconnect = 'false';
            await VideoCallPage.route(model: data);
            return;
          }
        } else {
          if (AppConstant.userType == UserType.member) {
            log("data['type']--<<>>${data['type']}");
            if (data['type'].toString() == 'new_message') {
              final modelChat = ChatDataModel.fromJson({
                'user_detail': {
                  '_id': data['data']['user_detail']['_id'].toString(),
                  'name': data['data']['user_detail']['name'].toString(),
                  'friendId': data['data']['friendId'].toString(),
                  'profile': data['data']['user_detail']['profile'].toString()
                },
                'lastMessage': null
              });
              log("data['type']--5656565<<>>${jsonEncode(modelChat)}");
              await ChatPage.route(modelChat);
            } else {
              await MainPage.route(selectedIndex: 3, from: 'Noti5');
            }
          } else {
            await NotificationsPage.route();
          }
        }
      }
    });

    const initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/ic_notification.png'),
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotificationStream.add,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final notificationAppLaunchDetails = !kIsWeb && Platform.isLinux ? null : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    }
  }

  // Show a simple notification
  static Future<void> showSimpleNotification({required String title, required String body, String? payload}) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'Used for call or message notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'ic_notification',
    );
    const notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'default_channel_id',
      'Default Channel',
      description: 'Used for call or message notifications',
      importance: Importance.high,
    );

    final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future<void> _handleCallkitAcceptFromExtras(Map<String, dynamic>? extras) async {
    try {
      Map<String, dynamic>? data;
      if (extras != null) {
        // Some plugin paths include nested 'extra' which is our original CallKitParams.extra
        final rawExtra = extras['extra'];
        debugPrint('rawExtra: $rawExtra');
        if (rawExtra != null) {
          if (rawExtra is String) {
            try {
              final parsed = jsonDecode(rawExtra) as Map<String, dynamic>;
              data = parsed['data'] is String ? Map<String, dynamic>.from(jsonDecode(parsed['data'] as String) as Map) : parsed;
            } catch (_) {
              // ignore, fallback below
            }
          } else if (rawExtra is Map) {
            final parsed = Map<String, dynamic>.from(rawExtra);
            data = parsed['data'] is String ? Map<String, dynamic>.from(jsonDecode(parsed['data'] as String) as Map) : parsed;
          }
        }
        // Direct 'data' on the extras
        if (data == null) {
          if (extras.containsKey('data') && extras['data'] is String) {
            final temp = extras['data'] as String;
            if (temp.isNotEmpty) data = jsonDecode(temp) as Map<String, dynamic>;
          } else if (extras.containsKey('data') && extras['data'] is Map) {
            data = Map<String, dynamic>.from(extras['data'] as Map);
          } else {
            data ??= extras;
          }
        }
      }

      // If we still don't have a solid payload, try the saved one from when the push arrived
      if (data == null || data.isEmpty || (data['type'] == null)) {
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getString('call_data');
        if (saved != null && saved.isNotEmpty) {
          try {
            data = jsonDecode(saved) as Map<String, dynamic>;
          } catch (_) {}
        }
      }

      if (data != null) {
        getIt<SharedPreferences>().setDisconnect = 'false';
        await VideoCallPage.route(model: data);
      }
    } catch (e) {
      debugPrint('Error handling initial callkit accept: $e');
    }
  }
}

// Add this method to handle the complete data structure
Future<void> _handleInitialCallEvent() async {
  try {
    if (Platform.isIOS) {
      const channel = MethodChannel('com.marker.flutter.voip/token');
      final activeCall = await channel.invokeMethod<Map<dynamic, dynamic>>('checkActiveCall');
      debugPrint('Active call check: $activeCall');

      if (activeCall != null && (activeCall['hasActiveCall']) == true) {
        final callData = await channel.invokeMethod<Map<dynamic, dynamic>>('getReturnToCallData');

        if (callData != null && callData.isNotEmpty) {
          debugPrint('Returning to call from notification: $callData');
          // Clear the return flag
          await channel.invokeMethod('clearReturnToCall');
          // Navigate to video call screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            VideoCallPage.route(model: callData);
          });
        }
      }
    } else {
      const channel = MethodChannel('com.marker.app/call_kit');
      final initialEvent = await channel.invokeMethod('getInitialCallEvent');
      debugPrint('Initial call event: $initialEvent');

      if (initialEvent != null && (initialEvent['action'] == 'call_resume')) {
        final extras = initialEvent['extras'];
        final appState = extras['app_state'] as String?;
        if (extras != null && extras['data'] != null) {
          // Get the complete call data
          final callDataString = extras['data'] as String;

          // Use GetX to navigate to call screen with complete data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (appState == 'background') {
              VideoCallPage.route(model: jsonDecode(callDataString));
            } else {
              final prefs = getIt<SharedPreferences>();
              prefs.setString('call_data', callDataString);
              SplashScreen.route();
            }
          });
        }
      }
    }
  } catch (e) {
    print('Error handling initial call event: $e');
  }
}

Future<void> startCallForegroundService(Map<String, dynamic> callData) async {
  try {
    if (Platform.isAndroid) {
      const channel = MethodChannel('com.marker.app/call_kit');
      await channel.invokeMethod('startForegroundService', {
        'callData': jsonEncode(callData),
      });
    }
  } catch (e) {
    debugPrint('Error starting foreground service: $e');
  }
}

Future<bool> isForegroundService() async {
  const channel = MethodChannel('com.marker.app/call_kit');
  final running = await channel.invokeMethod('isServiceRunning') is bool;
  return running;
}

Future<void> stopCallForegroundService() async {
  try {
    if (Platform.isAndroid) {
      const channel = MethodChannel('com.marker.app/call_kit');
      await channel.invokeMethod('stopForegroundService');
    }
  } catch (e) {
    debugPrint('Error stopping foreground service: $e');
  }
}

// Add this class for app lifecycle detection
class AppLifecycleHandler with WidgetsBindingObserver {
  factory AppLifecycleHandler() => _instance;

  AppLifecycleHandler._internal();

  static final AppLifecycleHandler _instance = AppLifecycleHandler._internal();

  bool _isInBackground = false;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (!_isInBackground) {
          _isInBackground = true;
          final prefs = getIt<SharedPreferences>();
          prefs.remove('call_data');
          _onAppBackgrounded();
        }
        break;
      case AppLifecycleState.resumed:
        if (_isInBackground) {
          _isInBackground = false;
          _onAppForegrounded();
        }
        break;
      case AppLifecycleState.detached:
        // App is being destroyed
        break;
      case AppLifecycleState.hidden:
        // App is hidden (new in Flutter 3.19+)
        _isInBackground = true;
        _onAppBackgrounded();
        break;
    }
  }

  Future<void> _onAppBackgrounded() async {
    // Check if there's an ongoing call
    final prefs = await SharedPreferences.getInstance();
    final ongoingCallData = prefs.getString('ongoing_call_data');
    // final running = await isForegroundService();
    // debugPrint('($running)ongoingCallData--->$ongoingCallData');
    if (ongoingCallData != null && ongoingCallData.startsWith('{')) {
      if (Platform.isAndroid) await getIt<VideoCallController>().videoCallEnable();
      // Start foreground service to keep call alive
      final callData = jsonDecode(ongoingCallData) as Map<String, dynamic>;
      await startCallForegroundService(callData);
      /*const channel = MethodChannel('com.marker.app/call_kit');
      final running = await channel.invokeMethod('isServiceRunning') is bool;
      debugPrint('running-check-->$running');
      if (!running) {
        await startCallForegroundService(callData);
      }*/
    }
  }

  Future<void> _onAppForegrounded() async {
    // Stop foreground service if app comes back to foreground
    final prefs = await SharedPreferences.getInstance();
    final ongoingCallData = prefs.getString('ongoing_call_data');
    debugPrint('ongoingCallData--_onAppForegrounded->$ongoingCallData');

    if (ongoingCallData != null) {
      if (Platform.isAndroid) await getIt<VideoCallController>().audioCallEnable();
    }
    await stopCallForegroundService();
  }
}
