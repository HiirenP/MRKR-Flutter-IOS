import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/message/messages_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/data/models/messages_model/messages_model.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/message/chat_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class MessagesPage extends GetItHook<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppEdgeInsets.all16(),
      child: Column(
        children: [
          Obx(
            () => AppCustomAppbar(
              appTitle: controller.isSelectionMode.value
                  ? '${controller.selectedFriendIds.length} selected'
                  : AppStrings.T.messages,
              isHideBackButton: true,
              enableKeyboardDismissButton: true,
              keyboardFocusNode: controller.searchFocusNode,
              isPadding: true,
              widget: controller.isEmptyData.value || controller.isLoading.value
                  ? null
                  : IconButton(
                      onPressed: controller.toggleSelectionMode,
                      icon: Icon(
                        controller.isSelectionMode.value ? Icons.close : Icons.checklist,
                        color: context.colorScheme.primary,
                      ),
                      tooltip: controller.isSelectionMode.value
                          ? AppStrings.T.cancel
                          : AppStrings.T.select,
                    ),
            ),
          ),
          Obx(() {
            if (!controller.isSelectionMode.value ||
                controller.isEmptyData.value ||
                controller.isLoading.value) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: controller.selectAllChats,
                    child: AppText(
                      AppStrings.T.selectAll,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (controller.selectedFriendIds.isNotEmpty)
                    TextButton(
                      onPressed: controller.isClearingChat.value
                          ? null
                          : () => controller.clearSelectedChats(),
                      child: AppText(
                        AppStrings.T.clearSelectedChats,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: controller.isClearingChat.value
                        ? null
                        : () => controller.clearSelectedChats(clearAll: true),
                    child: AppText(
                      AppStrings.T.clearAllChats,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const Gap(12),
          TextInputField(
            type: InputType.text,
            controller: controller.searchController,
            focusNode: controller.searchFocusNode,
            hintLabel: AppStrings.T.searchName,
            context: context,
            circularValue: 30.0.obs,
            textInputAction: TextInputAction.done,
            prefixIcon: ImageView(
              Assets.svg.searchNormal,
              color: context.colorScheme.secondaryFixedDim,
            ),
            onChanged: (value) {
              controller.onSearchFriend(value);
            },
          ),
          const Gap(20),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.isEmptyData.value
                      ? EmptyScreen(
                          title: AppStrings.T.noChatFoundTitle,
                        )
                      : ListView.builder(
                          itemCount: controller.chatList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() {
                              final model = controller.chatList[index];
                              final friendId = model.userDetail?.friendId;
                              final unreadCount = (model.unreadCount ?? 0).toInt();
                              final hasUnread = unreadCount > 0;
                              final isSelectionMode = controller.isSelectionMode.value;
                              final isSelected = controller.isChatSelected(friendId);
                              return GestureDetector(
                                  onTap: () {
                                    if (isSelectionMode) {
                                      controller.toggleChatSelection(friendId);
                                      return;
                                    }
                                    Map<String, dynamic>? mapTemp;
                                    if (controller.mapCall.isNotEmpty) {
                                      if (controller.mapCall['userId'].toString() ==
                                          (model.lastMessage?.senderId?.sId ?? '')) {
                                        mapTemp = controller.mapCall;
                                      }
                                    }
                                    ChatPage.route(model, map: mapTemp)?.then(
                                      (value) {
                                        controller.mapCall.clear();
                                        if (value != null && value is MessagesDataModel) {
                                          controller.updateChatMessage(model: value, index: index);
                                        }
                                      },
                                    );
                                  },
                                  onLongPress: () {
                                    if (!isSelectionMode) {
                                      controller.toggleSelectionMode();
                                    }
                                    controller.toggleChatSelection(friendId);
                                  },
                                  child: Container(
                                    margin: const AppEdgeInsets.oB15(),
                                    padding: const AppEdgeInsets.v10(),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: context.colorScheme.secondary,
                                      border: isSelected
                                          ? Border.all(color: context.colorScheme.primary, width: 2)
                                          : null,
                                    ),
                                    child: ListTile(
                                      contentPadding: const AppEdgeInsets.h10(),
                                      leading: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelectionMode)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Checkbox(
                                                value: isSelected,
                                                activeColor: context.colorScheme.primary,
                                                onChanged: (_) {
                                                  controller.toggleChatSelection(friendId);
                                                },
                                              ),
                                            ),
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ImageView(
                                                model.userDetail?.profile ?? '',
                                                shape: BoxShape.circle,
                                                inner: ImageSize(height: 50, width: 50),
                                              ),
                                              if (!isSelectionMode && hasUnread)
                                                Positioned(
                                                  right: -2,
                                                  top: -2,
                                                  child: _UnreadBadge(count: unreadCount),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: isSelectionMode
                                          ? null
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                PopupMenuButton<String>(
                                                  onSelected: (String result) {
                                                        if (result == 'block') {
                                                          controller.blockUserData(
                                                            blockId: model.userDetail?.sId ?? '',
                                                            index: index,
                                                          );
                                                        } else if (result == 'report') {
                                                          controller.reportBottomSheet(
                                                            blockId: model.userDetail?.sId ?? '',
                                                            index: index,
                                                          );
                                                        } else if (result == 'clear') {
                                                          controller.toggleSelectionMode();
                                                          controller.toggleChatSelection(friendId);
                                                          controller.clearSelectedChats();
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext context) =>
                                                          <PopupMenuEntry<String>>[
                                                        PopupMenuItem<String>(
                                                          value: 'clear',
                                                          child: AppText(
                                                            AppStrings.T.clearSelectedChats,
                                                            style: context.textTheme.bodyMedium,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'block',
                                                          child: AppText(
                                                            'Block',
                                                            style: context.textTheme.bodyMedium,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'report',
                                                          child: AppText(
                                                            'Report',
                                                            style: context.textTheme.bodyMedium,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                      child: const Icon(Icons.more_vert),
                                                    ),
                                                if (model.lastMessage?.createdAt != null)
                                                  AppText(
                                                    DateUtil.instance.chatDaysLabelManage(
                                                      date: model.lastMessage?.createdAt ?? '',
                                                    ),
                                                    style: context.textTheme.bodySmall?.copyWith(
                                                      color: context.colorScheme.secondaryFixedDim,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                      title: AppText(
                                        model.userDetail?.name ?? '',
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: model.lastMessage != null
                                          ? Padding(
                                              padding: const AppEdgeInsets.v5(),
                                              child: AppText(
                                                _lastMessagePreview(model),
                                                style: context.textTheme.bodySmall?.copyWith(
                                                  color: hasUnread
                                                      ? context.colorScheme.onSecondary
                                                      : context.colorScheme.secondaryFixedDim,
                                                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                );
                            });
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.onInitial();
  }

  @override
  void onDispose() {
    controller.disposeRecords();
  }
}

String _lastMessagePreview(ChatDataModel model) {
  final last = model.lastMessage;
  if (last == null) return '';
  final text = last.message?.trim() ?? '';
  if (text.isNotEmpty) return text;
  if (last.messageType == 'marker') return 'Sent a marker';
  return '';
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : count > 9 ? '9+' : '$count';
    final minWidth = count > 9 ? 22.0 : 18.0;

    return Container(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.secondary, width: 2),
      ),
      child: Center(
        child: AppText(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
