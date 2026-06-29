import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/controllers/member_main/message/messages_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/data/models/messages_model/messages_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/pages/member_main/main_page/main_page.dart';
import 'package:marker/app/ui/pages/member_main/message/video_call_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@i.lazySingleton
@i.injectable
class ChatController extends GetxController {
  ChatController() {
    onInit();
  }

  final callingState = ApiState.initial().obs;
  final ScrollController scrollController = ScrollController();
  final FocusNode messageFocusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  RxBool showEmojiPicker = false.obs;
  RxBool isSend = false.obs;
  ChatDataModel? friendData;
  final appConstant = AppConstant.instance;
  IO.Socket? socket;
  bool? isConnected;
  RxList<MessagesDataModel> messageList = <MessagesDataModel>[].obs;
  RxList<dynamic> listGroup = [].obs;
  double? beforeLoadMaxExtent;
  RxString userName = ''.obs;
  String userId = '';
  String callChannel = '';
  RxString markerId = ''.obs;
  RxBool isLoading = false.obs;
  int count = 0;
  int page = 1;
  bool onces = false;
  RxBool isMoreData = false.obs;
  bool isUserScrolling = false;
  bool isBackOnce = false;
  bool fromSendMarker = false;
  RedeemedUpcomingListData? marker;
  List<String> listDefaultMessage = ['Let me treat you', 'Your drink is on me', 'My treat, don’t ask why', 'I paid. You sip.'];
  RxBool isVideoCall = false.obs;
  final RxDouble messageFontSize = SharedPreferencesX.chatFontSizeMedium.obs;

  static void applyChatFontSize(double size) {
    getIt<SharedPreferences>().setChatFontSize = size;
    try {
      getIt<ChatController>().messageFontSize.value = size;
    } catch (_) {}
  }

  void loadMessageFontSize() {
    messageFontSize.value = getIt<SharedPreferences>().getChatFontSize;
  }

  TextStyle messageTextStyle(BuildContext context, {required bool isSender}) {
    return (context.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: messageFontSize.value,
      color: isSender ? context.colorScheme.secondaryFixedDim : context.colorScheme.onSecondary,
    );
  }

  void chatInitialize() {
    loadMessageFontSize();
    page = 1;
    messageList.clear();
    listGroup.value = [];
    isMoreData.value = false;
    isBackOnce = false;
    fromSendMarker = false;
    userId = getIt<SharedPreferences>().getUserId ?? '';
    isSend.value = false;
    isLoading.value = true;
    messageController = TextEditingController();
    if (Get.arguments != null) {
      if (Get.arguments is ChatDataModel) {
        friendData = Get.arguments as ChatDataModel;
      } else if (Get.arguments is List) {
        friendData = Get.arguments[0] as ChatDataModel;
        if (Get.arguments[1] is Map<String, dynamic>) {
          final map = Get.arguments[1] as Map<String, dynamic>;
          callChannel = map['channel'].toString();
        }
      }

      userName.value = friendData?.userDetail?.name ?? '';
      if (friendData?.sendMarker != null) {
        fromSendMarker = true;
        marker = friendData?.lastMessage?.markerId;
        markerId.value = marker?.sId ?? '';
        Future.delayed(Duration(seconds: 1), () {
          getIt<BaseHomeController>().selectedIndex.value = 2;
        });
      }
      _setupSocketForChat();
    }

    scrollController.addListener(() {
      if (count == messageList.length) {
        return;
      }
      if (!isUserScrolling) {
        return;
      }
      /*
      * This pagination reverse work when user
      * scroll to up then older messages will show
      * */
      if (!onces && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (count == messageList.length) {
          return;
        }
        // beforeLoadMaxExtent = scrollController.position.maxScrollExtent;
        onces = true;
        isMoreData.value = true;
        page++;
        emitMessageList();
      }
    });
  }

  void _setupSocketForChat() {
    getIt<BaseHomeController>().whenSocketReady(() {
      socket = appConstant.socket;
      _registerChatSocketListeners();
      isConnected = socket?.connected ?? false;
      emitMessageList();
    });
  }

  void _registerChatSocketListeners() {
    if (socket == null) return;
    socket!.off(appConstant.onSetMessageList);
    socket!.off(appConstant.onSetNewMessage);
    socket!.off(appConstant.onSetUnreadChatThreadCount);
    socket!.off(appConstant.onUpdateChatList);
    socket!.off(appConstant.onIncomingCall);
    socket!.off(appConstant.onMessageDeleted);
    socket!.off(appConstant.onSetMessageDeleted);
    socket!.off(appConstant.onMessageReactionUpdated);
    socket!.off(appConstant.onSetMessageReaction);
    socket!.on(appConstant.onSetMessageList, _handlerMessageChat);
    socket!.on(appConstant.onSetNewMessage, _handlerNewMessage);
    socket!.on(appConstant.onSetUnreadChatThreadCount, _handlerUnreadCount);
    socket!.on(appConstant.onUpdateChatList, _handlerUpdateMessage);
    socket!.on(appConstant.onIncomingCall, _handlerUpdateCall);
    socket!.on(appConstant.onMessageDeleted, _handlerMessageDeleted);
    socket!.on(appConstant.onSetMessageDeleted, _handlerMessageDeleted);
    socket!.on(appConstant.onMessageReactionUpdated, _handlerReactionUpdated);
    socket!.on(appConstant.onSetMessageReaction, _handlerReactionUpdated);
    socket!.onConnect((_) {
      isConnected = true;
      emitMessageList();
    });
  }

  String _resolveUserId() {
    if (userId.isNotEmpty) return userId;
    userId = getIt<SharedPreferences>().getUserId ?? '';
    return userId;
  }

  void emitReactMessage(String messageId, String emoji) {
    socket = appConstant.socket;
    final friendId = friendData?.userDetail?.friendId ?? '';
    final currentUserId = _resolveUserId();
    if (messageId.isEmpty || emoji.isEmpty) return;
    if (socket?.connected == true && currentUserId.isNotEmpty) {
      socket!.emit(appConstant.emitReactMessage, {
        'messageId': messageId,
        'userId': currentUserId,
        'emoji': emoji,
        if (friendId.isNotEmpty) 'friendId': friendId,
      });
    }
  }

  void _handlerReactionUpdated(userData) {
    if (userData is! Map<String, dynamic>) return;
    final success = userData['success'];
    if (success != null && success.toString() == '0') {
      showError(userData['Message']?.toString() ?? 'Could not update reaction.');
      return;
    }
    final resData = userData['resData'];
    if (resData is! Map<String, dynamic>) return;
    final msgId = resData['messageId']?.toString() ?? '';
    if (msgId.isEmpty) return;

    final raw = resData['reactions'];
    final reactions = <MessageReaction>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          reactions.add(MessageReaction.fromJson(item));
        } else if (item is Map) {
          reactions.add(MessageReaction.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    void applyTo(List<MessagesDataModel> list) {
      for (final m in list) {
        if (m.sid == msgId) {
          m.reactions = reactions;
        }
      }
    }

    applyTo(messageList);
    for (var i = 0; i < listGroup.length; i++) {
      final group = listGroup[i] as Map<String, dynamic>;
      final list = group['list'] as List<MessagesDataModel>;
      applyTo(list);
      group['list'] = list;
      listGroup[i] = group;
    }
    messageList.refresh();
    listGroup.refresh();
  }

  void emitMessageList() {
    socket = appConstant.socket;
    if (socket == null || socket!.connected != true) {
      return;
    }
    isConnected = true;
    debugPrint('<<---emitMessageList--->>');
    final friendId = friendData?.userDetail?.friendId ?? '';
    final currentUserId = _resolveUserId();
    if (friendId.isEmpty) {
      isLoading.value = false;
      showError('Unable to open chat. Missing friend id.');
      return;
    }
    if (currentUserId.isEmpty) {
      isLoading.value = false;
      showError('Unable to open chat. Please sign in again.');
      return;
    }
    final userData = <String, dynamic>{'viewerUserId': currentUserId, 'friendId': friendId, 'page': page, 'limit': '30'};
    socket!.emit(appConstant.emitGetMessageList, userData);
  }

  void emitNewMessage() {
    final message = messageController.text.trim();
    if (message.isEmpty && markerId.value.isEmpty) {
      return;
    }
    var type = 'text';
    if (markerId.value.isNotEmpty) {
      type = 'marker';
    }
    socket = appConstant.socket;
    if (socket?.connected != true) {
      showError('Connecting to chat server. Please try again.');
      getIt<BaseHomeController>().socketConnectSetup();
      return;
    }
    isConnected = true;
    final date = DateUtil.instance.currentDDateFormat();
    final currentUserId = _resolveUserId();
    final receiverId = friendData?.userDetail?.sId ?? '';
    final friendId = friendData?.userDetail?.friendId ?? '';
    if (currentUserId.isEmpty || receiverId.isEmpty || friendId.isEmpty) {
      showError('Unable to send message. Chat session is invalid.');
      return;
    }

    final userData = <String, dynamic>{
      'message': message,
      'senderId': currentUserId,
      'receiverId': receiverId,
      'friendId': friendId,
      'messageType': type,
      'createdAt': date,
      'markerId': markerId.value.isNotEmpty ? markerId.value : null,
    };
    debugPrint('userData-send->$userData');

    messageController.clear();
    socket!.emit(appConstant.emitSendMessage, userData);
    isSend.value = true;
    messageList.add(MessagesDataModel.fromJson({
      'senderId': {'_id': userId},
      'message': message,
      'messageType': type,
      'markerId': marker != null ? jsonDecode(jsonEncode(marker)) : null,
      'isRead': true,
      'isDeleted': false,
      'createdAt': date,
    }));
    markerId.value = '';
    marker = null;
    insertMessageIntoGroup(messageList.last);
  }

  void _handlerNewMessage(userData) {
    if (userData is! Map<String, dynamic>) return;
    final success = userData['success'];
    if (success != null && success.toString() == '0') {
      if (isSend.value && messageList.isNotEmpty) {
        messageList.removeLast();
        if (listGroup.isNotEmpty) {
          final group = listGroup.first as Map<String, dynamic>;
          final list = group['list'] as List<MessagesDataModel>;
          if (list.isNotEmpty) {
            list.removeAt(0);
          }
          listGroup.refresh();
        }
      }
      isSend.value = false;
      showError(userData['Message']?.toString() ?? 'Failed to send message');
      return;
    }

    final resDataRaw = userData['resData'];
    if (resDataRaw is! Map<String, dynamic>) return;

    final friendId = friendData?.userDetail?.friendId ?? '';
    final msgFriendId = resDataRaw['friendId']?.toString() ?? '';
    if (friendId.isNotEmpty && msgFriendId.isNotEmpty && msgFriendId != friendId) {
      return;
    }

    final message = _parseSocketMessage(resDataRaw);
    if (message == null) return;

    final senderId = message.senderId?.sId ?? '';
    if (senderId == userId) {
      _confirmSentMessage(message);
      return;
    }

    if (!_messageAlreadyInList(message)) {
      messageList.add(message);
      insertMessageIntoGroup(message);
    }
  }

  MessagesDataModel? _parseSocketMessage(Map<String, dynamic> raw) {
    final normalized = Map<String, dynamic>.from(raw);
    if (normalized['senderId'] == null && normalized['user_detail'] != null) {
      normalized['senderId'] = normalized['user_detail'];
    }
    final senderVal = normalized['senderId'];
    if (senderVal is String) {
      normalized['senderId'] = {'_id': senderVal};
    }
    try {
      return MessagesDataModel.fromJson(normalized);
    } catch (e) {
      debugPrint('_parseSocketMessage error: $e');
      return null;
    }
  }

  bool _messageAlreadyInList(MessagesDataModel message) {
    final messageId = message.sid;
    if (messageId != null && messageId.isNotEmpty) {
      return messageList.any((m) => m.sid == messageId);
    }
    return messageList.any(
      (m) =>
          m.message == message.message &&
          m.createdAt == message.createdAt &&
          m.senderId?.sId == message.senderId?.sId,
    );
  }

  void _confirmSentMessage(MessagesDataModel message) {
    isSend.value = false;
    if (messageList.isEmpty) return;
    final lastIndex = messageList.length - 1;
    final last = messageList[lastIndex];
    if (last.sid == null || last.sid!.isEmpty) {
      messageList[lastIndex] = message;
      _replaceLastGroupedMessage(message);
    } else if (!_messageAlreadyInList(message)) {
      messageList.add(message);
      insertMessageIntoGroup(message);
    }
  }

  void _replaceLastGroupedMessage(MessagesDataModel message) {
    if (listGroup.isEmpty) return;
    final group = listGroup.first as Map<String, dynamic>;
    final list = group['list'] as List<MessagesDataModel>;
    if (list.isEmpty) return;
    list[0] = message;
    group['list'] = list;
    listGroup[0] = group;
    listGroup.refresh();
  }

  void _handlerMessageChat(userData) {
    isLoading.value = false;
    log('handlerMessageChat-->${jsonEncode(userData)}');
    if (userData is! Map<String, dynamic>) return;
    final success = userData['success'];
    if (success != null && success.toString() == '0') {
      showError(userData['Message']?.toString() ?? 'Failed to load messages');
      return;
    }
    final resDataRaw = userData['resData'];
    if (resDataRaw == null) {
      if (page == 1) {
        messageList.clear();
        listGroup.clear();
      }
      return;
    }
    if (resDataRaw is! Map<String, dynamic>) return;
    final model = MessagesModel.fromJson(resDataRaw);
    final tempList = model.data ?? [];
    count = model.totalRecord ?? 0;
    if (tempList.isNotEmpty) {
      if (page == 1) {
        messageList.value = tempList;
        allMessagesGroupByDate();
      } else {
        final margeList = tempList;
        messageList.value = [...margeList, ...messageList];
        onces = false;
        insertPaginatedMessages(tempList);
      }
    } else if (page == 1) {
      messageList.clear();
      listGroup.clear();
    }
    if (page == 1) {
      _markCurrentChatReadInList();
    }
  }

  void _markCurrentChatReadInList() {
    final friendId = friendData?.userDetail?.friendId ?? '';
    if (friendId.isEmpty) return;

    try {
      final messagesController = getIt<MessagesController>();
      final index = messagesController.chatList.indexWhere((c) => c.userDetail?.friendId == friendId);
      if (index >= 0) {
        messagesController.chatList[index].unreadCount = 0;
        messagesController.chatList.refresh();
      }
      getIt<BaseHomeController>().syncUnreadChatBadgeFromMessages();
    } catch (_) {}
    getIt<BaseHomeController>().requestUnreadChatThreadCount();
  }

  void _handlerUnreadCount(userData) {
    if (userData is Map<String, dynamic>) {
      final resData = userData['resData'] as Map<String, dynamic>?;
      if (resData != null) {
        getIt<BaseHomeController>().applyUnreadChatThreadCount(resData['count']);
      }
    }
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
    if (showEmojiPicker.value) {
      messageFocusNode.unfocus();
      keyboardHide();
    } else {
      messageFocusNode.requestFocus();
    }
  }

  void onEmojiSelected(String emoji) {
    messageController
      ..text += emoji
      ..selection = TextSelection.collapsed(offset: messageController.text.length);
    isSend.value = messageController.text.trim().isNotEmpty || markerId.value.isNotEmpty;
  }

  Future<void> confirmDeleteMessage(MessagesDataModel messageModel) async {
    final messageId = messageModel.sid;
    if (messageId == null || messageId.isEmpty) {
      return;
    }
    final isSender = messageModel.senderId?.sId == userId;
    final context = Get.context!;
    final action = await Get.bottomSheet<String>(
      Container(
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isSender) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const ['👍', '❤️', '😂', '😮', '😢', '🙏', '👎', '🔥', '🎉', '🤔']
                    .map(
                      (e) => InkWell(
                        onTap: () => Get.back(result: 'react:$e'),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: context.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(e, style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Gap(12),
            ],
            Divider(color: context.colorScheme.secondaryContainer.withAlpha(40), height: 1),
            const Gap(8),
            if (isSender)
              ListTile(
                onTap: () => Get.back(result: 'everyone'),
                title: AppText(
                  'Delete for everyone',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ListTile(
              onTap: () => Get.back(result: 'me'),
              title: AppText(
                'Delete for me',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () => Get.back(),
              title: AppText(
                'Cancel',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );

    if (!isSender && action != null && action.startsWith('react:')) {
      emitReactMessage(messageId, action.substring('react:'.length));
      return;
    }

    if (action == 'everyone') {
      emitDeleteMessage(messageId, scope: 'everyone');
    } else if (action == 'me') {
      removeMessageById(messageId);
      emitDeleteMessage(messageId, scope: 'me');
    }
  }

  void emitDeleteMessage(String messageId, {String scope = 'everyone'}) {
    socket = appConstant.socket;
    final currentUserId = _resolveUserId();
    if (messageId.isEmpty) return;
    if (socket?.connected == true && currentUserId.isNotEmpty) {
      socket!.emit(appConstant.emitDeleteMessage, {
        'messageId': messageId,
        'userId': currentUserId,
        'scope': scope,
      });
    }
  }

  void _handlerMessageDeleted(userData) {
    if (userData is! Map<String, dynamic>) return;

    final success = userData['success'];
    if (success == 0 || success == '0') {
      showError(userData['Message']?.toString() ?? 'Could not delete message.');
      return;
    }

    final resData = userData['resData'] as Map<String, dynamic>?;
    if (resData == null) return;
    final friendId = resData['friendId']?.toString() ?? '';
    if (friendId != (friendData?.userDetail?.friendId ?? '')) return;
    final messageId = resData['messageId']?.toString() ?? '';
    if (messageId.isNotEmpty) {
      removeMessageById(messageId);
    }
  }

  void removeMessageById(String messageId) {
    messageList.removeWhere((m) => m.sid == messageId);
    for (var i = listGroup.length - 1; i >= 0; i--) {
      final group = listGroup[i] as Map<String, dynamic>;
      final list = group['list'] as List<MessagesDataModel>;
      list.removeWhere((m) => m.sid == messageId);
      if (list.isEmpty) {
        listGroup.removeAt(i);
      } else {
        group['list'] = list;
        listGroup[i] = group;
      }
    }
    listGroup.refresh();
  }

  void _handlerUpdateMessage(userData) {
    // updateChatList is for the messages thread list screen, not the open chat.
    // Adding here duplicated sent messages on the wrong side (payload has user_detail, not senderId).
    debugPrint('handlerUpdateMessage-->${jsonEncode(userData)}');
  }

  void _handlerUpdateCall(userData) {
    debugPrint('_handlerUpdateCall-->${jsonEncode(userData)}');
    if (userData is Map<String, dynamic>) {
      final success = userData['success'];
      if (success != null) {
        if (success.toString() == '0') {
          // error in emit
        }
      } else {
        final map = userData['resData'] as Map<String, dynamic>;
        if (map.isNotEmpty) {
          if ('${map['userId'] ?? ''}' == (friendData?.userDetail?.friendId ?? '')) {
            callChannel = '${map['channel'] ?? ''}';
          }
        }
      }
    }
  }

  void disposeRecords() {
    listGroup.value = [];
    isUserScrolling = false;
    isBackOnce = false;
    if (socket != null && userId.isNotEmpty) {
      socket!.emit(appConstant.emitChatScreenLeft, {'userId': userId});
    }
    socket?.off(appConstant.onSetMessageList);
    socket?.off(appConstant.onSetNewMessage);
    socket?.off(appConstant.onSetUnreadChatThreadCount);
    socket?.off(appConstant.onUpdateChatList);
    socket?.off(appConstant.onIncomingCall);
    socket?.off(appConstant.onMessageDeleted);
    socket?.off(appConstant.onSetMessageDeleted);
    messageFocusNode.unfocus();
    showEmojiPicker.value = false;
    messageController.clear();
    userId = '';
    userName.value = '';
    onces = false;
    isLoading.value = false;
    callingState.value = ApiState.initial();
    callChannel = '';
    marker = null;
    fromSendMarker = false;
    page = 1;
  }

  Future<void> onUserBack() async {
    if (isBackOnce) {
      return;
    }
    isBackOnce = true;
    keyboardHide();
    if (fromSendMarker) {
      fromSendMarker = false;
      await MainPage.route(selectedIndex: 2);
      return;
    }
    if (messageList.isNotEmpty) {
      final model = messageList.last;
      Get.back(result: model);
    } else {
      Get.back();
    }
  }

  // void _scrollDown() {
  //   debugPrint('-----------scrollDown-----------');
  //
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (!scrollController.hasClients) return;
  //     if (scrollController.hasClients) {
  //       debugPrint('-----------scrollDown---------ININ--');
  //       scrollController.animateTo(
  //         scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  Future<void> callingTokenAPI() async {
    final requestData = <String, dynamic>{
      'toUserId': friendData?.userDetail?.sId ?? '',
      'isPublisher': true,
      'channel': callChannel,
    };

    callingState.value = LoadingState();
    await getIt<MemberService>().callingToken(requestData).handler(
      callingState,
      isLoading: true,
      onSuccess: (value) async {
        final model = value.data;
        if (value.statusCode == 200 && value.isSuccess && model != null) {
          callChannel = model.channel ?? '';
          final temp = model.toJson();
          temp.putIfAbsent('name', () => userName.value);
          temp.putIfAbsent('profile', () => friendData?.userDetail?.profile ?? '');
          temp.putIfAbsent('otherUserId', () => friendData?.userDetail?.sId ?? '');
          temp.putIfAbsent('fromChat', () => true);
          getIt<SharedPreferences>().setDisconnect = 'false';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remote_user_declined', false);
          await VideoCallPage.route(model: temp);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void allMessagesGroupByDate() {
    final listTempGroup = <Map<String, dynamic>>[];
    final groupByDate = groupBy(messageList, (obj) => _messageDateLabel(obj));
    groupByDate.forEach((date, list) {
      debugPrint('$date:');
      listTempGroup.add({'date': date, 'list': list});
    });
    if (listTempGroup.isNotEmpty) {
      listGroup.value = [];
      listGroup.addAll(listTempGroup);
    }
    isMoreData.value = false;
  }

  String _messageDateLabel(MessagesDataModel message) {
    final created = message.createdAt;
    if (created != null && created.length >= 10) {
      return created.substring(0, 10);
    }
    return 'unknown';
  }

  void insertMessageIntoGroup(MessagesDataModel message) {
    isUserScrolling = false;
    final groupLabel = _messageDateLabel(message);
    final groupIndex = listGroup.indexWhere((group) {
      debugPrint('date------>${group['date']}');
      return group['date'] == groupLabel;
    });
    debugPrint('groupLabel--->$groupLabel--->$groupIndex');

    if (groupIndex >= 0) {
      final group = listGroup[groupIndex];
      final list = group['list'];
      list.insert(0, message);
      group['list'] = list;
      listGroup[groupIndex] = group;
    } else {
      listGroup.insert(0, {
        'date': groupLabel,
        'list': [message]
      });
    }
  }

  void insertPaginatedMessages(List<MessagesDataModel> newMessages) {
    for (final msg in newMessages) {
      final label = _messageDateLabel(msg);
      final groupIndex = listGroup.indexWhere((group) => group['date'] == label);
      if (groupIndex != -1) {
        // Group exists, insert message in correct position
        final group = listGroup[groupIndex];
        final list = group['list'];
        list.add(msg);
        group['list'] = list;
        listGroup[groupIndex] = group;
      } else {
        // Create new group with this message
        listGroup.add({
          'date': label,
          'list': [msg]
        });
      }
    }
    isMoreData.value = false;
    Future.delayed(const Duration(milliseconds: 100), () {
      isUserScrolling = false;
      // final afterLoadMaxExtent = scrollController.position.maxScrollExtent;
      // final a = afterLoadMaxExtent - (beforeLoadMaxExtent ?? 0);
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   scrollController.jumpTo(a / 4);
      // });
    });
  }
}
