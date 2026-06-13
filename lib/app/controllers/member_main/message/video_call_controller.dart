import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/call_token_model/call_token_model.dart';
import 'package:marker/app/ui/pages/member_main/main_page/main_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wakelock_plus/wakelock_plus.dart';

@i.lazySingleton
@i.injectable
class VideoCallController extends GetxController {
  VideoCallController() {
    onInit();
  }

  RxString userName = ''.obs;
  RxString profile = ''.obs;
  String userId = '';
  String otherUserId = '';
  String callChannel = '';
  String callToken = '';
  String appId = '';
  RxInt remoteUidCall = (-1).obs;
  RxBool localUserJoined = false.obs;
  RxBool isMute = false.obs;
  RxBool isStopVideo = false.obs;
  bool isJoinedUser = false;
  late RtcEngine engine;
  int uId = 0;
  final appConstant = AppConstant.instance;
  IO.Socket? socket;
  bool? isConnected;
  String? dataReceived;
  DateTime? _lastUserJoinedTime;
  Timer? _connectionTimer;
  bool goBack = false;
  bool isFromChat = false;

  Future<void> callInitialize() async {
    otherUserId = '';
    socket = appConstant.socket;
    isConnected = socket?.connected;
    isMute.value = false;
    isStopVideo.value = false;
    isFromChat = false;
    userId = getIt<SharedPreferences>().getUserId ?? '';

    if (socket != null && isConnected != null && isConnected!) {
      socket!.off(appConstant.onCallRejected);
      socket!.on(appConstant.onCallRejected, _handlerCallRejected);
    } else {
      unawaited(Future.delayed(const Duration(seconds: 3)).then(
        (value) {
          socket?.off(appConstant.onCallRejected);
          socket?.on(appConstant.onCallRejected, _handlerCallRejected);
        },
      ));
    }
    if (Get.arguments != null) {
      final friendData = Get.arguments as Map<String, dynamic>;
      userName.value = (friendData['name'] ?? '').toString();
      profile.value = (friendData['profile'] ?? '').toString();
      if (friendData.containsKey('otherUserId')) {
        otherUserId = (friendData['otherUserId'] ?? '').toString();
      } else if (friendData.containsKey('toUserId')) {
        otherUserId = (friendData['toUserId'] ?? '').toString();
      } else {
        otherUserId = (friendData['userId'] ?? '').toString();
      }
      if (friendData.containsKey('name')) {
        friendData.remove('name');
      }
      if (friendData.containsKey('profile')) {
        friendData.remove('profile');
      }
      if (friendData.containsKey('userId')) {
        friendData.remove('userId');
      }
      if (friendData.containsKey('fromChat')) {
        isFromChat = friendData['fromChat'] as bool;
        friendData.remove('fromChat');
      }
      dataReceived = jsonEncode(friendData);
      debugPrint('---friendData-->$dataReceived');
      TokenDataModel? tokenData;
      if (friendData.containsKey('EXTRA_CALLKIT_CALL_DATA')) {
        final data = friendData['EXTRA_CALLKIT_CALL_DATA']['EXTRA_CALLKIT_EXTRA'];
        if (data is String) {
          tokenData = TokenDataModel.fromJson(parseCallkitExtra(data));
        } else if (data is Map<String, dynamic>) {
          tokenData = TokenDataModel.fromJson(data);
        }
      } else {
        tokenData = TokenDataModel.fromJson(friendData);
      }
      callToken = tokenData?.token ?? '';
      callChannel = tokenData?.channel ?? '';
      uId = int.parse('${tokenData?.randomID ?? 9999}');
      appId = '590996a49d1f432cbfff4ba99fbcde2a';
      debugPrint('---randomID-->${tokenData?.randomID}');
    }
    debugPrint('---callToken-->$callToken');
    debugPrint('---callChannel-->$callChannel');
    debugPrint('---appId-->$appId');
    debugPrint('---otherUserId-->$otherUserId');
    debugPrint('---userId-->$userId');
    await initAgora();
    await WakelockPlus.enable();
  }

  Future<void> _handlerCallRejected(userData) async {
    debugPrint('_handlerCallRejected-->${jsonEncode(userData)}');

    if (userData is Map<String, dynamic>) {
      final resData = userData['resData'] as Map<String, dynamic>?;
      if (resData != null) {
        if (callChannel == resData['channelId']) {
          if (!goBack) {
            goBack = true;
            await disConnectCall();
          }
        }
      }
    }
  }

  Future<void> disposeRecords() async {
    _connectionTimer?.cancel();
    socket?.off(appConstant.onCallRejected);
    otherUserId = '';
    isJoinedUser = false;
    goBack = false;
    await WakelockPlus.disable();
    isMute.value = false;
    isStopVideo.value = false;
    userId = '';
    userName.value = '';
    callChannel = '';
    callToken = '';
    appId = '';
    remoteUidCall.value = -1;
    localUserJoined.value = false;
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    final reqStatus = await [Permission.microphone, Permission.camera].request();
    debugPrint('reqStatus[Permission.microphone]!.isGranted>>${reqStatus[Permission.microphone]!.isGranted}');
    debugPrint('reqStatus[Permission.camera]!.isGranted>>${reqStatus[Permission.camera]!.isGranted}');
    if (reqStatus[Permission.microphone]!.isGranted && reqStatus[Permission.camera]!.isGranted) {
      //create the engine
      engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));
      // await engine.setParameters('{"che.audio.keep.audiosession": true}'); // Keeps audio session alive
      // await engine.setAudioSessionOperationRestriction(AudioSessionOperationRestriction.audioSessionOperationRestrictionAll);
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            uId = connection.localUid ?? 0;
            localUserJoined.value = true;
            debugPrint('-----onJoinChannelSuccess----- user ${connection.localUid} joined');

            // Start a 30-second timer to wait for the remote user.
            _connectionTimer = Timer(const Duration(seconds: 28), () {
              // If the timer fires, it means the remote user has not joined in time.
              // We check if a remote user is already connected before disconnecting.
              if (remoteUidCall.value == -1) {
                debugPrint('Remote user did not join within 30 seconds. Disconnecting call.');
                disConnectCall();
              }
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('-----onUserJoined-----remote user $remoteUid joined');
            // A remote user has joined, so we cancel the timeout timer.
            _connectionTimer?.cancel();
            _lastUserJoinedTime = DateTime.now();
            remoteUidCall.value = remoteUid;
            isJoinedUser = true;
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) async {
            debugPrint('-----onUserOffline-----remote user $remoteUid left channel with reason: $reason');
            final now = DateTime.now();
            final joinedTime = _lastUserJoinedTime;

            // Check if offline triggered within 1 second of join
            if (joinedTime != null && now.difference(joinedTime).inMilliseconds <= 1000) {
              debugPrint(
                '-----onUserOffline-----ignored because it happened within 1 second of join ($remoteUid)',
              );
              return;
            }
            remoteUidCall.value = -1;

            if (reason == UserOfflineReasonType.userOfflineQuit) {
              debugPrint('Remote user quit. Starting a 30-second timer to allow for rejoin.');
              _connectionTimer?.cancel();
              _connectionTimer = Timer(const Duration(milliseconds: 1500), () {
                // If the timer fires, it means the remote user has not rejoined in time.
                if (remoteUidCall.value == -1) {
                  debugPrint('Remote user did not rejoin within 3 seconds. Disconnecting call.');
                  disConnectCall();
                }
              });
            } else {
              debugPrint('Remote user dropped due to network or other reason. Staying in call.');
            }
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint('-----[onTokenPrivilegeWillExpire]----- connection: ${connection.toJson()}, token: $token');
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('----AGORA-onError----- Error: ${err.name} - $msg');
            if (err == ErrorCodeType.errJoinChannelRejected) {
              debugPrint('User is already in the channel, treating as rejoin.');
              localUserJoined.value = true;
            }
          },
          onConnectionStateChanged: (RtcConnection connection, ConnectionStateType state, ConnectionChangedReasonType reason) {
            debugPrint('-----onConnectionStateChanged----- State: $state, Reason: $reason');
          },
        ),
      );
      await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine.enableAudio();
      await engine.enableVideo();
      await engine.startPreview();
      // await engine.setLogLevel(LogLevel.logLevelInfo);
      try {
        await engine.leaveChannel();
        await engine.joinChannel(
          token: callToken,
          channelId: callChannel,
          uid: uId,
          options: const ChannelMediaOptions(
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: ChannelProfileType.channelProfileCommunication,
          ),
        );
      } on AgoraRtcException catch (e) {
        debugPrint('Agora error: Code ${e.code}, Message: ${e.message}');
        if (e.code == -17) {
          debugPrint('Fix: User already in channel. Treating as rejoin.');
          localUserJoined.value = true;
        }
      } catch (e) {
        debugPrint('General error: $e');
      }
      if (Platform.isIOS) {
        await Future.delayed(const Duration(milliseconds: 500));
        await FlutterCallkitIncoming.endAllCalls();
        await flutterLocalNotificationsPlugin.cancelAll();
      }
      await startForegroundService();
    } else {
      showError(AppStrings.T.requiredPermissionNotGrant);
    }
  }

  Future<void> disConnectCall({bool isRemoteDeclined = false}) async {
    debugPrint('------disConnectCall------');
    _connectionTimer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key_sender_id', '');
    await prefs.remove('call_data');
    await prefs.remove('remote_user_declined');
    await prefs.remove('ongoing_call_data');
    final id = prefs.getString('uuid_call');
    if (id != null && id.isNotEmpty) {
      await prefs.setString('uuid_call', '');
      await FlutterCallkitIncoming.endAllCalls();
      await flutterLocalNotificationsPlugin.cancelAll();
    }
    await _stopForegroundService();
    // Only emit a reject event if this disconnect wasn't triggered by a remote decline.
    if (!isJoinedUser && !isRemoteDeclined) {
      debugPrint('-----REJECT_CALL_EMIT');
      socket?.emit(AppConstant.instance.emitRejectCall, {'userId': userId, 'receiverUserId': otherUserId, 'channelId': callChannel});
    } else if (isFromChat) {
      debugPrint('-----END_CALL_EMIT');
      socket?.emit(AppConstant.instance.emitEndCall, {
        'userId': userId,
        'channelId': callChannel,
        'receiverUserId': otherUserId,
      });
    }
    await handleBack();
  }

  Future<void> videoCallEnable() async {
    isStopVideo.value = false;
    await engine.muteLocalVideoStream(isStopVideo.value);
  }

  Future<void> audioCallEnable() async {
    await engine.muteLocalVideoStream(false);
    await engine.muteLocalAudioStream(isMute.value);
    isStopVideo.value = false;
  }

  Future<void> handleBack() async {
    await disposeRecords();

    if (Platform.isIOS && fromCallScreen == 'Splash') {
      await MainPage.route(from: 'Call');
    } else {
      Get.back();
    }
  }

  Future<void> startForegroundService() async {
    try {
      final callData = {
        'channel': callChannel,
        'token': callToken,
        'appId': appId,
        'userId': userId,
        'otherUserId': otherUserId,
        'userName': userName.value,
        'profile': profile.value,
        'randomID': uId
      };

      await startCallForegroundService(callData);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ongoing_call_data', jsonEncode(callData));
      debugPrint('Data loaded successfully');
    } catch (e) {
      debugPrint('Error starting foreground service: $e');
    }
  }

  Future<void> _stopForegroundService() async {
    try {
      await stopCallForegroundService();
    } catch (e) {
      debugPrint('Error stopping foreground service: $e');
    }
  }
}
