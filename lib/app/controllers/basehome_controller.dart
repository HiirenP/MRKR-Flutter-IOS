import 'dart:async';
import 'dart:convert';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/controllers/member_main/message/messages_controller.dart';
import 'package:marker/app/ui/pages/member_main/friend/friends_page.dart';
import 'package:marker/app/ui/pages/member_main/home/home_page.dart';
import 'package:marker/app/ui/pages/member_main/message/messages_page.dart';
import 'package:marker/app/ui/pages/member_main/notifications/notifications_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/bar_profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_home/owner_home_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_marker/marker_page.dart';
import 'package:marker/app/ui/pages/owner_main/owner_profile/owner_profile_page.dart';
import 'package:marker/app/ui/pages/owner_main/scan_redeem/scan_redeem_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@i.lazySingleton
@i.injectable
class BaseHomeController extends GetxController {
  List<String> baseList = [];
  RxInt selectedIndex = 0.obs;
  RxInt notificationCount = 0.obs;
  RxInt unreadChatThreadCount = 0.obs;
  RxBool hasUnreadChat = false.obs;
  bool isOnce = false;
  bool _socketConnecting = false;
  final List<VoidCallback> _onConnectedCallbacks = [];

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  List<Widget> pages = <Widget>[
    const HomePage(),
    const FriendsPage(),
    const MessagesPage(),
    const NotificationsPage(isBackShow: true),
    const ProfilePage(),
  ];

  List<Widget> pages1 = <Widget>[
    const OwnerHomePage(),
    const MarkerPage(),
    const ScanRedeemPage(),
    const BarProfilePage(),
    const OwnerProfilePage(),
  ];

  void onItemTapped(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
    }
    if (index == 2) {
      getIt<MessagesController>().refreshChatListIfNeeded();
    }
  }

  void applyUnreadChatThreadCount(dynamic count) {
    final parsed = int.tryParse('$count') ?? 0;
    unreadChatThreadCount.value = parsed;
    hasUnreadChat.value = parsed > 0;
  }

  void syncUnreadChatBadgeFromMessages() {
    applyUnreadChatThreadCount(getIt<MessagesController>().totalUnreadMessageCount);
  }

  void requestUnreadChatThreadCount() {
    final userId = getIt<SharedPreferences>().getUserId;
    if (userId == null || userId.isEmpty) return;
    AppConstant.instance.socket?.emit(
      AppConstant.instance.emitGetUnreadChatThreadCount,
      {'userId': userId},
    );
  }

  void whenSocketReady(VoidCallback callback) {
    if (AppConstant.instance.socket?.connected == true) {
      callback();
      return;
    }
    _onConnectedCallbacks.add(callback);
    socketConnectSetup();
  }

  void socketConnection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationCount.value = 0;
    });
    socketConnectSetup();
  }

  void socketConnectSetup() {
    if (AppConstant.instance.socket?.connected ?? false) {
      debugPrint('<<---socket already connected--->>');
      doSocketOn();
      _flushConnectedCallbacks();
      return;
    }
    if (_socketConnecting) {
      return;
    }
    _socketConnecting = true;

    final existing = AppConstant.instance.socket;
    existing?.clearListeners();
    existing?.dispose();

    debugPrint('<<---socketConnection--->>${AppConfig.socketUrl}');
    final socket = AppConstant.instance.socket = IO.io(AppConfig.socketUrl, <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 8,
      'reconnectionDelay': 1200,
    });

    socket
      ..onConnect((_) {
        _socketConnecting = false;
        _connectionHandler(null);
      })
      ..onConnectError((handler) {
        debugPrint('socket-handler-onConnectError->$handler');
        _socketConnecting = false;
      })
      ..onError((data) {
        debugPrint('socket-handler-onError->$data');
      });

    socket.connect();
  }

  void _flushConnectedCallbacks() {
    if (_onConnectedCallbacks.isEmpty) return;
    final pending = List<VoidCallback>.from(_onConnectedCallbacks);
    _onConnectedCallbacks.clear();
    for (final cb in pending) {
      cb();
    }
  }

  void socketDisconnection() {
    _onConnectedCallbacks.clear();
    AppConstant.instance.socket?.off(AppConstant.instance.onSetUnreadNotificationCount);
    AppConstant.instance.socket?.off(AppConstant.instance.onSetUnreadChatThreadCount);
    AppConstant.instance.socket?.off(AppConstant.instance.onCallRejected);
    final userId = getIt<SharedPreferences>().getUserId;
    if (userId != null) {
      AppConstant.instance.socket?.emit(AppConstant.instance.emitSocketLeave, {'userId': userId});
      AppConstant.instance.socket?.onDisconnect((_) => debugPrint('<<---socket disconnect successfully--->>'));
    }
  }

  void _connectionHandler(data) {
    final userId = getIt<SharedPreferences>().getUserId;
    if (userId != null && userId != 'null' && userId.trim().isNotEmpty) {
      debugPrint('<<--- Socket connected successfully --->>');
      AppConstant.instance.socket?.emit(AppConstant.instance.emitSocketJoin, {'userId': userId});
      if (AppConstant.instance.socket != null && !isOnce) {
        isOnce = true;
        doSocketOn();
      }
      _flushConnectedCallbacks();
    }
  }

  void doSocketOn() {
    final userData = getIt<SharedPreferences>().getUserData;
    AppConstant.instance.socket?.on(AppConstant.instance.onSetUnreadNotificationCount, _handlerNotificationCount);
    AppConstant.instance.socket?.on(
      AppConstant.instance.onSetUnreadChatThreadCount,
      _handlerUnreadChatThreadCount,
    );
    requestUnreadChatThreadCount();
    if (userData != null && userData.userType == 'member') {
      AppConstant.instance.socket?.off(AppConstant.instance.onCallRejected);
      AppConstant.instance.socket?.on(
        AppConstant.instance.onCallRejected,
        (data) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remote_user_declined', true);
          debugPrint('Remote user declined call. Set remote_user_declined flag to true.');
          final id = prefs.getString('uuid_call');
          if (id != null && id.isNotEmpty) {
            await prefs.setString('uuid_call', '');
            await FlutterCallkitIncoming.endAllCalls();
            await flutterLocalNotificationsPlugin.cancelAll();
          }
        },
      );
    }
  }

  void _handlerNotificationCount(userData) {
    debugPrint('handlerNotificationCount-->${jsonEncode(userData)}');
    if (userData is Map<String, dynamic>) {
      final resData = userData['resData'] as Map<String, dynamic>?;
      if (resData != null && resData.isNotEmpty) {
        final count = resData['count'];
        notificationCount.value = int.parse('$count');
      }
    }
  }

  void _handlerUnreadChatThreadCount(userData) {
    if (userData is! Map<String, dynamic>) return;
    final resData = userData['resData'] as Map<String, dynamic>?;
    if (resData != null) {
      applyUnreadChatThreadCount(resData['count']);
    }
  }
}
