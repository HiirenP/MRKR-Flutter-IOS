import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum UserType { member, manager, owner }

extension UserTypeExtension on UserType {
  static UserType fromString(String? value) {
    if (value == null) return UserType.member;
    switch (value) {
      case 'member':
        return UserType.member;
      case 'staff':
        return UserType.manager;
      case 'barOwner':
        return UserType.owner;
      default:
        return UserType.member;
    }
  }

  String get backendValue {
    switch (this) {
      case UserType.member:
        return 'member';
      case UserType.manager:
        return 'staff';
      case UserType.owner:
        return 'barOwner';
    }
  }
}

enum ChannelType { sms, email }

extension ChannelTypeExtension on ChannelType {
  static ChannelType fromString(String? value) {
    if (value == null) return ChannelType.email;
    switch (value.toLowerCase()) {
      case 'sms':
        return ChannelType.sms;
      case 'email':
        return ChannelType.email;
      default:
        return ChannelType.email;
    }
  }

  String get backendValue {
    switch (this) {
      case ChannelType.sms:
        return 'sms';
      case ChannelType.email:
        return 'email';
    }
  }
}

class AppConstant {
  factory AppConstant() {
    return _singleton;
  }

  AppConstant._internal();

  static final AppConstant _singleton = AppConstant._internal();

  static AppConstant get instance => _singleton;
  bool isRejected = false;
  bool isAccepted = false;
  bool isAlreadyIn = false;

  static UserType userType = UserType.member;

  static Widget isOwnerLogin({Widget? child}) {
    return userType == UserType.owner ? (child ?? const SizedBox()) : const SizedBox();
  }

  bool isAndroid = Platform.isAndroid;
  IO.Socket? socket;
  static const kGoogleApiKey = 'AIzaSyDOXWtPoDiHvpbrAMKffhIAWmjkp4HPAJ8';

  String emitSocketJoin = 'socketJoin';
  String emitSocketLeave = 'socketLeave';
  String emitGetChatUserList = 'getChatUserlist';
  String onSetChatUserlist = 'setChatUserlist';
  String emitGetMessageList = 'getMessageList';
  String onSetMessageList = 'setMessageList';
  String onSetUnreadChatThreadCount = 'setUnreadChatThreadCount';
  String emitSendMessage = 'sendMessage';
  String onSetNewMessage = 'setNewMessage';
  String onUpdateChatList = 'updateChatList';
  String emitChatScreenLeft = 'chatScreenLeft';
  String emitGetUnreadChatThreadCount = 'getUnreadChatThreadCount';
  String emitDeleteMessage = 'deleteMessage';
  String onMessageDeleted = 'messageDeleted';
  String onSetMessageDeleted = 'setMessageDeleted';
  String emitClearChat = 'clearChat';
  String onSetChatCleared = 'setChatCleared';
  String emitReactMessage = 'reactMessage';
  String onMessageReactionUpdated = 'messageReactionUpdated';
  String onSetMessageReaction = 'setMessageReaction';
  String onPaymentDone = 'paymentDone';
  String onIncomingCall = 'incomingCall';
  String onSetUnreadNotificationCount = 'setUnreadNotificationCount';
  String emitCreateApprovalRequest = 'createApprovalRequest';
  String onMarkerRedeemed = 'markerRedeemed';
  String onMarkerApproved = 'markerApproved';
  String onMarkerRejected = 'markerRejected';
  String onCallRejected = 'callRejected';
  String emitRejectCall = 'rejectCall';
  String emitEndCall = 'endCall';
}
