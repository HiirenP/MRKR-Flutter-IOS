import 'dart:convert';
import 'dart:developer';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/data/models/messages_model/messages_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/debouncer.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@i.lazySingleton
@i.injectable
class MessagesController extends GetxController {
  MessagesController() {
    onInit();
  }

  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final appConstant = AppConstant.instance;
  IO.Socket? socket;
  bool? isConnected;
  int count = 0;
  int page = 1;
  Debouncer debouncer = Debouncer(milliseconds: 700);
  RxList<ChatDataModel> chatList = <ChatDataModel>[].obs;
  RxBool isEmptyData = false.obs;
  RxBool isLoading = false.obs;
  RxBool isSelectionMode = false.obs;
  RxBool isClearingChat = false.obs;
  final RxSet<String> selectedFriendIds = <String>{}.obs;
  Map<String, dynamic> mapCall = <String, dynamic>{}.obs;
  final searchState = ApiState.initial().obs;

  void onInitial() {
    mapCall = <String, dynamic>{};
    searchController = TextEditingController();
    isEmptyData.value = false;
    chatList = <ChatDataModel>[].obs;
    count = 0;
    page = 1;

    _setupSocketForMessages();
  }

  void _setupSocketForMessages() {
    isLoading.value = true;
    getIt<BaseHomeController>().whenSocketReady(() {
      socket = appConstant.socket;
      _registerMessagesSocketListeners();
      isConnected = socket?.connected ?? false;
      emitUserList();
      getIt<BaseHomeController>().requestUnreadChatThreadCount();
    });
  }

  void _registerMessagesSocketListeners() {
    if (socket == null) return;
    socket!.off(appConstant.onSetChatUserlist);
    socket!.off(appConstant.onIncomingCall);
    socket!.off(appConstant.onSetUnreadChatThreadCount);
    socket!.off(appConstant.onUpdateChatList);
    socket!.off(appConstant.onSetChatCleared);
    socket!.on(appConstant.onSetChatUserlist, _handlerUserChat);
    socket!.on(appConstant.onIncomingCall, _handlerUpdateCall);
    socket!.on(appConstant.onSetUnreadChatThreadCount, _handlerUnreadChatBadge);
    socket!.on(appConstant.onUpdateChatList, _handlerChatListUpdate);
    socket!.on(appConstant.onSetChatCleared, _handlerChatCleared);
    socket!.onConnect((_) {
      isConnected = true;
      if (chatList.isEmpty) {
        isLoading.value = true;
        emitUserList();
      }
    });
  }

  void _handlerUnreadChatBadge(userData) {
    if (userData is Map<String, dynamic>) {
      final resData = userData['resData'] as Map<String, dynamic>?;
      if (resData != null) {
        getIt<BaseHomeController>().applyUnreadChatThreadCount(resData['count']);
      }
    }
  }

  int get totalUnreadMessageCount =>
      chatList.fold<int>(0, (sum, chat) => sum + (chat.unreadCount ?? 0).toInt());

  void refreshChatListIfNeeded() {
    page = 1;
    emitUserList();
  }

  bool _hasChatHistory(ChatDataModel chat) {
    final last = chat.lastMessage;
    if (last == null) return false;
    if (last.createdAt != null && last.createdAt!.isNotEmpty) return true;
    if (last.messageType == 'marker') return true;
    return (last.message ?? '').trim().isNotEmpty;
  }

  void _removeChatByFriendId(String friendId) {
    chatList.removeWhere((chat) => chat.userDetail?.friendId == friendId);
    isEmptyData.value = chatList.isEmpty;
    chatList.refresh();
    getIt<BaseHomeController>().syncUnreadChatBadgeFromMessages();
  }

  void _handlerChatListUpdate(userData) {
    if (userData is! Map<String, dynamic>) return;
    final map = userData['resData'] as Map<String, dynamic>?;
    if (map == null || map.isEmpty) return;
    final friendId = map['friendId']?.toString() ?? '';
    if (friendId.isEmpty) return;

    final lastMsg = map['message']?.toString() ?? map['lastMessage']?.toString() ?? '';
    final createdAt = map['createdAt']?.toString();
    final messageType = map['messageType']?.toString();
    final hasVisibleMessage =
        lastMsg.trim().isNotEmpty || messageType == 'marker' || (createdAt != null && createdAt.isNotEmpty);

    if (!hasVisibleMessage) {
      _removeChatByFriendId(friendId);
      return;
    }

    final index = chatList.indexWhere((c) => c.userDetail?.friendId == friendId);
    if (index < 0) {
      page = 1;
      emitUserList();
      return;
    }
    final item = chatList[index];
    item.lastMessage = MessagesDataModel(
      message: lastMsg,
      createdAt: createdAt,
      messageType: messageType,
    );

    final currentUserId = getIt<SharedPreferences>().getUserId ?? '';
    final receiverId = _resolveSocketUserId(map['receiverId']);
    final senderId = _resolveSocketUserId(map['senderId']);
    if (receiverId == currentUserId) {
      if (map['unreadCount'] != null) {
        item.unreadCount = num.tryParse('${map['unreadCount']}') ?? item.unreadCount;
      } else if (senderId != null && senderId != currentUserId) {
        item.unreadCount = (item.unreadCount ?? 0) + 1;
      }
    } else if (senderId == currentUserId) {
      item.unreadCount = 0;
    }

    chatList[index] = item;
    sortingList();
    getIt<BaseHomeController>().syncUnreadChatBadgeFromMessages();
  }

  String? _resolveSocketUserId(dynamic ref) {
    if (ref == null) return null;
    if (ref is String) return ref;
    if (ref is Map<String, dynamic>) {
      return ref['_id']?.toString();
    }
    return ref.toString();
  }

  void _handlerUserChat(userData) {
    isLoading.value = false;

    if (userData is! Map<String, dynamic>) return;
    final success = userData['success'];
    if (success != null) {
      if (success.toString() == '0') {
        if (page == 1 && chatList.isEmpty) {
          isEmptyData.value = true;
        }
        showError(userData['Message']?.toString() ?? 'Failed to load chats');
      }
      return;
    }
    final mapRaw = userData['resData'];
    if (mapRaw == null) {
      if (page == 1) {
        chatList.clear();
        isEmptyData.value = true;
      }
      return;
    }
    if (mapRaw is! Map<String, dynamic>) return;
    if (mapRaw.isEmpty) {
      if (page == 1) {
        chatList.clear();
        isEmptyData.value = true;
      }
      return;
    }
    log('map-->$mapRaw');
    final response = ChatUserModel.fromJson(mapRaw);
    count = response.totalRecord ?? 0;
    final tempList = (response.data ?? []).where(_hasChatHistory).toList();
    if (page == 1) {
      chatList.value = tempList;
      isEmptyData.value = tempList.isEmpty;
    } else if (tempList.isNotEmpty) {
      chatList.addAll(tempList);
    }
    if (chatList.length != count) page++;
    sortingList();
    getIt<BaseHomeController>().syncUnreadChatBadgeFromMessages();
  }

  void _handlerUpdateCall(userData) {
    debugPrint('handlerUpdateCall-Recent->${jsonEncode(userData)}');
    if (userData is Map<String, dynamic>) {
      final success = userData['success'];
      if (success != null) {
        if (success.toString() == '0') {
          // error in emit
        }
      } else {
        final map = userData['resData'] as Map<String, dynamic>;
        if (map.isNotEmpty) {
          mapCall = map;
        }
      }
    }
  }

  void emitUserList() {
    socket = appConstant.socket;
    if (socket == null || socket!.connected != true) {
      return;
    }
    isConnected = true;
    debugPrint('<<---emitUserList--->>');
    final userData = <String, dynamic>{
      'userId': getIt<SharedPreferences>().getUserId,
      'searchText': searchController.text.trim(),
      'page': page,
      'limit': '30'
    };
    socket!.emit(appConstant.emitGetChatUserList, userData);
  }

  void disposeRecords() {
    isLoading.value = false;
    isSelectionMode.value = false;
    isClearingChat.value = false;
    selectedFriendIds.clear();
    searchFocusNode.unfocus();
    socket?.off(appConstant.onSetChatUserlist);
    socket?.off(appConstant.onIncomingCall);
    socket?.off(appConstant.onSetUnreadChatThreadCount);
    socket?.off(appConstant.onUpdateChatList);
    socket?.off(appConstant.onSetChatCleared);
    searchController.clear();
    mapCall = <String, dynamic>{};
  }

  void toggleSelectionMode() {
    if (isSelectionMode.value) {
      exitSelectionMode();
      return;
    }
    isSelectionMode.value = true;
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedFriendIds.clear();
  }

  void toggleChatSelection(String? friendId) {
    if (friendId == null || friendId.isEmpty) {
      return;
    }
    if (selectedFriendIds.contains(friendId)) {
      selectedFriendIds.remove(friendId);
    } else {
      selectedFriendIds.add(friendId);
    }
  }

  void selectAllChats() {
    selectedFriendIds
      ..clear()
      ..addAll(
        chatList.map((chat) => chat.userDetail?.friendId).whereType<String>(),
      );
  }

  bool isChatSelected(String? friendId) {
    return friendId != null && selectedFriendIds.contains(friendId);
  }

  void _applyClearedChats(List<String> clearedFriendIds) {
    if (clearedFriendIds.isEmpty) {
      chatList.clear();
    } else {
      chatList.removeWhere(
        (chat) => clearedFriendIds.contains(chat.userDetail?.friendId),
      );
    }
    isEmptyData.value = chatList.isEmpty;
    chatList.refresh();
    getIt<BaseHomeController>().syncUnreadChatBadgeFromMessages();
  }

  void _handlerChatCleared(userData) {
    isClearingChat.value = false;
    Loading.dismiss();
    if (userData is! Map<String, dynamic>) return;

    final success = userData['success'];
    if (success == 0 || success == '0') {
      showError(userData['Message']?.toString() ?? 'Could not clear chat.');
      return;
    }

    final resData = userData['resData'] as Map<String, dynamic>?;
    final clearedRaw = resData?['clearedFriendIds'];
    final clearedFriendIds = clearedRaw is List
        ? clearedRaw.map((id) => id.toString()).toList()
        : <String>[];

    _applyClearedChats(clearedFriendIds);
    exitSelectionMode();
    getIt<BaseHomeController>().requestUnreadChatThreadCount();

    final message = userData['Message']?.toString() ?? '';
    if (message.isNotEmpty) {
      showSuccess(message);
    }
  }

  Future<void> clearSelectedChats({bool clearAll = false}) async {
    if (!clearAll && selectedFriendIds.isEmpty) {
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(clearAll ? AppStrings.T.clearAllChats : AppStrings.T.clearSelectedChats),
        content: Text(
          clearAll ? AppStrings.T.clearAllChatsConfirm : AppStrings.T.clearChatConfirm,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text(AppStrings.T.cancel)),
          TextButton(onPressed: () => Get.back(result: true), child: Text(AppStrings.T.yes)),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    socket = appConstant.socket;
    if (socket == null || socket!.connected != true) {
      showError('Unable to clear chats. Please check your connection.');
      return;
    }

    isClearingChat.value = true;
    Loading.show();
    socket!.emit(appConstant.emitClearChat, {
      'userId': getIt<SharedPreferences>().getUserId,
      'friendIds': clearAll ? <String>[] : selectedFriendIds.toList(),
      'clearAll': clearAll,
    });
  }

  void updateChatMessage({required MessagesDataModel model, required int index}) {
    final tempModel = chatList[index];
    tempModel.lastMessage = MessagesDataModel(message: model.message, createdAt: model.createdAt ?? '');
    chatList[index] = tempModel;
    sortingList();
  }

  void clearUnreadForChat(int index) {
    if (index < 0 || index >= chatList.length) return;
    chatList[index].unreadCount = 0;
    sortingList();
    getIt<BaseHomeController>().syncUnreadChatBadgeFromMessages();
    getIt<BaseHomeController>().requestUnreadChatThreadCount();
  }

  void sortingList() {
    chatList.removeWhere((chat) => !_hasChatHistory(chat));
    chatList.sort((a, b) {
      final adate = a.lastMessage?.createdAt ?? '';
      final bdate = b.lastMessage?.createdAt ?? '';
      return bdate.compareTo(adate);
    });
    isEmptyData.value = chatList.isEmpty;
    chatList.refresh();
  }

  void onSearchFriend(String value) {
    page = 1;
    isEmptyData.value = false;
    debouncer.run(emitUserList);
  }

  Future<void> blockUserData({required String blockId, required int index}) async {
    final requestData = <String, dynamic>{'blockedId': blockId};

    searchState.value = LoadingState();
    await getIt<MemberService>().blockUser(requestData).handler(
      searchState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && (value.isSuccess ?? false)) {
          showSuccess(value.message ?? '');
          chatList.removeAt(index);
          if (chatList.isEmpty) {
            isEmptyData.value = true;
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> reportBottomSheet({required String blockId, required int index}) async {
    final enterDescriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Get.bottomSheet(
      Form(
        key: formKey,
        child: AppBottomSheet(
          title: 'Report',
          isDivider: true,
          content: TextInputField(
            type: InputType.text,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            controller: enterDescriptionController,
            hintLabel: 'Description',
            context: Get.context!,
            validator: AppValidations.descriptionValidation,
            maxLines: 4,
          ),
          positiveButtonTitle: 'Submit',
          onPositivePressed: () async {
            if (formKey.currentState!.validate()) {
              Get.back();
              await reportUserData(blockId: blockId, description: enterDescriptionController.text.trim(), index: index);
            }
          },
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<void> reportUserData({required String blockId, required String description, required int index}) async {
    final requestData = <String, dynamic>{'reportedUserId': blockId, 'reason': 'spam', 'description': description};

    searchState.value = LoadingState();
    await getIt<MemberService>().userReports(requestData).handler(
      searchState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && (value.isSuccess ?? false)) {
          showSuccess(value.message ?? '');
          chatList.removeAt(index);
          if (chatList.isEmpty) {
            isEmptyData.value = true;
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
