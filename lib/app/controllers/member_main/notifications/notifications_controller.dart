import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/notifications_model/notifications_model.dart';
import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@i.lazySingleton
@i.injectable
class NotificationsController extends GetxController {
  NotificationsController() {
    onInit();
  }

  final ScrollController scrollController = ScrollController();

  int page = 1;
  RxBool hasMoreData = true.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isOnceS = false;
  final notificationState = ApiState.initial().obs;
  final respondFriendState = ApiState.initial().obs;
  final respondMarkerState = ApiState.initial().obs;
  RxList<NotificationsListData> notificationsList =
      <NotificationsListData>[].obs;
  RxBool isSelectionMode = false.obs;
  final RxSet<String> selectedNotificationIds = <String>{}.obs;
  int totalRecord = 0;
  final appConstant = AppConstant.instance;
  IO.Socket? socket;
  bool? isConnected;

  Future<void> fetchNotifications() async {
    if (page == 1) {
      hasMoreData.value = false;
      notificationState.value = LoadingState();
    } else {
      hasMoreData.value = true;
    }

    final requestData = <String, dynamic>{
      'page': page,
      'limit': 10,
    };

    await getIt<BarOwnerService>().notifications(requestData).handler(
      notificationState,
      isLoading: page == 1,
      onSuccess: (value) {
        isOnceS = false;
        if (value.statusCode == 200 && value.data != null) {
          final newItems = value.data?.data ?? [];
          if (newItems.isEmpty && page == 1) {
            isDataEmpty.value = true;
          }
          if (page != 1) {
            hasMoreData.value = false;
          }
          final totalRecord = value.data?.totalRecord ?? 0;
          if (page == 1) {
            notificationsList.value = [];
            notificationsList.addAll(newItems);
          } else {
            if (newItems.isNotEmpty) {
              notificationsList.value = [...notificationsList, ...newItems];
            }
          }
          if (notificationsList.length < (value.data?.totalRecord ?? 0)) {
            page++;
          }
          if (totalRecord == notificationsList.length) {
            isEndPage.value = true;
          }
        }
      },
      onFailed: (value) {
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  void updateInitEntry() {
    isEndPage.value = false;
    notificationsList.value = [];
    page = 1;
    socket = appConstant.socket;
    isConnected = socket?.connected;
    fetchNotifications();
    scrollController.addListener(() {
      if (!isOnceS &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        fetchNotifications();
      }
    });
  }

  void disposeAll() {
    page = 1;
    hasMoreData = false.obs;
    isDataEmpty = false.obs;
    isEndPage = false.obs;
    isSelectionMode.value = false;
    selectedNotificationIds.clear();
    notificationsList.value = [];
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
    selectedNotificationIds.clear();
  }

  void toggleNotificationSelection(String? notificationId) {
    if (notificationId == null || notificationId.isEmpty) {
      return;
    }
    if (selectedNotificationIds.contains(notificationId)) {
      selectedNotificationIds.remove(notificationId);
    } else {
      selectedNotificationIds.add(notificationId);
    }
  }

  void selectAllNotifications() {
    selectedNotificationIds
      ..clear()
      ..addAll(
        notificationsList.map((item) => item.sId).whereType<String>(),
      );
  }

  bool isNotificationSelected(String? notificationId) {
    return notificationId != null && selectedNotificationIds.contains(notificationId);
  }

  Future<void> deleteSelectedNotifications({bool deleteAll = false}) async {
    if (!deleteAll && selectedNotificationIds.isEmpty) {
      return;
    }

    notificationState.value = LoadingState();

    final payload = deleteAll
        ? {'deleteAll': true}
        : {'notificationIds': selectedNotificationIds.toList()};

    await getIt<BarOwnerService>().deleteNotification(payload).handler(
      notificationState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && value.isSuccess) {
          if (deleteAll) {
            notificationsList.clear();
            isDataEmpty.value = true;
          } else {
            notificationsList.removeWhere(
              (item) => selectedNotificationIds.contains(item.sId),
            );
            if (notificationsList.isEmpty) {
              isDataEmpty.value = true;
            }
          }
          exitSelectionMode();
          getIt<BaseHomeController>().notificationCount.value = 0;
          if (value.message.isNotEmpty) {
            showSuccess(value.message);
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> acceptFriendRequest(NotificationsListData list,
      {String status = 'accepted'}) async {
    final requestId = list.friendId?.sid ?? '';
    if (requestId.isEmpty) {
      return;
    }
    final requestData = <String, dynamic>{
      'requestId': requestId,
      'status': status
    };

    respondFriendState.value = LoadingState();
    await getIt<MemberService>().respondRequest(requestData).handler(
      respondFriendState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && (value.isSuccess ?? false)) {
          notificationsList.remove(list);
          final message = value.message ?? '';
          if (message.isNotEmpty) {
            showSuccess(message);
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<void> deleteNotification(NotificationsListData list, int index) async {
    final notificationId = list.sId;
    if (notificationId == null || notificationId.isEmpty) {
      return;
    }
    notificationState.value = LoadingState();

    void onDeleteSuccess(NotificationsModel value) {
      if (value.statusCode == 200 && value.isSuccess) {
        notificationsList.removeAt(index);
        if (notificationsList.isEmpty) {
          isDataEmpty.value = true;
        }
        getIt<BaseHomeController>().notificationCount.value = 0;
        if (value.message.isNotEmpty) {
          showSuccess(value.message);
        }
      }
    }

    await getIt<BarOwnerService>().deleteNotification({'notificationId': notificationId}).handler(
      notificationState,
      isLoading: true,
      onSuccess: onDeleteSuccess,
      onFailed: (value) async {
        if (value.statusCode == 404) {
          await getIt<BarOwnerService>().notifications({
            'notificationId': notificationId,
            'action': 'delete',
          }).handler(
            notificationState,
            isLoading: true,
            onSuccess: onDeleteSuccess,
            onFailed: (fallback) {
              showError(fallback.error.description);
            },
          );
          return;
        }
        showError(value.error.description);
      },
    );
  }

  Future<void> redeemRequest(NotificationsListData list,
      {String status = 'approved'}) async {
    final requestId = list.approvalRequestId as Map<String, dynamic>;
    if (requestId.isEmpty) {
      return;
    }
    final id = requestId['_id'];
    final requestData = <String, dynamic>{
      'approvalRequestId': id,
      'status': status
    };

    respondMarkerState.value = LoadingState();
    await getIt<MemberService>().markerRespondRequest(requestData).handler(
      respondMarkerState,
      isLoading: true,
      onSuccess: (value) {
        if (value.statusCode == 200 && (value.isSuccess ?? false)) {
          notificationsList.remove(list);
          final message = value.message ?? '';
          if (message.isNotEmpty) {
            showSuccess(message);
          }
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
