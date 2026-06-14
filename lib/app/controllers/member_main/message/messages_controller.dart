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
    socket!.on(appConstant.onSetChatUserlist, _handlerUserChat);
    socket!.on(appConstant.onIncomingCall, _handlerUpdateCall);
    socket!.on(appConstant.onSetUnreadChatThreadCount, _handlerUnreadChatBadge);
    socket!.on(appConstant.onUpdateChatList, _handlerChatListUpdate);
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

  void _handlerChatListUpdate(userData) {
    if (userData is! Map<String, dynamic>) return;
    final map = userData['resData'] as Map<String, dynamic>?;
    if (map == null || map.isEmpty) return;
    final friendId = map['friendId']?.toString() ?? '';
    if (friendId.isEmpty) return;
    final index = chatList.indexWhere((c) => c.userDetail?.friendId == friendId);
    if (index < 0) {
      page = 1;
      emitUserList();
      return;
    }
    final item = chatList[index];
    final lastMsg = map['message']?.toString() ?? map['lastMessage']?.toString() ?? '';
    if (lastMsg.isEmpty) {
      item.lastMessage = null;
    } else {
      item.lastMessage = MessagesDataModel(
        message: lastMsg,
        createdAt: map['createdAt']?.toString(),
        messageType: map['messageType']?.toString(),
      );
    }

    final currentUserId = getIt<SharedPreferences>().getUserId ?? '';
    final receiverId = _resolveSocketUserId(map['receiverId']);
    if (receiverId == currentUserId && map['unreadCount'] != null) {
      item.unreadCount = num.tryParse('${map['unreadCount']}') ?? item.unreadCount;
    }

    chatList[index] = item;
    sortingList();
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
    final tempList = response.data ?? [];
    if (page == 1) {
      chatList.value = tempList;
      isEmptyData.value = tempList.isEmpty;
    } else if (tempList.isNotEmpty) {
      chatList.addAll(tempList);
    }
    if (chatList.length != count) page++;
    sortingList();
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
    searchFocusNode.unfocus();
    socket?.off(appConstant.onSetChatUserlist);
    socket?.off(appConstant.onIncomingCall);
    socket?.off(appConstant.onSetUnreadChatThreadCount);
    socket?.off(appConstant.onUpdateChatList);
    searchController.clear();
    mapCall = <String, dynamic>{};
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
  }

  void sortingList() {
    chatList.sort((a, b) {
      final aUnread = (a.unreadCount ?? 0) > 0;
      final bUnread = (b.unreadCount ?? 0) > 0;
      if (aUnread != bUnread) {
        return aUnread ? -1 : 1;
      }
      final adate = a.lastMessage?.createdAt ?? '';
      final bdate = b.lastMessage?.createdAt ?? '';
      return bdate.compareTo(adate);
    });
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
