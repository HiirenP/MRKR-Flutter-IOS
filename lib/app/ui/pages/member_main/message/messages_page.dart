import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/message/messages_controller.dart';
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
          AppCustomAppbar(
            appTitle: AppStrings.T.messages,
            isHideBackButton: true,
            enableKeyboardDismissButton: true,
            isPadding: true,
          ),
          const Gap(20),
          TextInputField(
            type: InputType.text,
            controller: controller.searchController,
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
                            final model = controller.chatList[index];
                            return GestureDetector(
                              onTap: () {
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
                              child: Container(
                                margin: const AppEdgeInsets.oB15(),
                                padding: const AppEdgeInsets.v10(),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15), color: context.colorScheme.secondary),
                                child: ListTile(
                                  contentPadding: const AppEdgeInsets.h10(),
                                  leading: ImageView(
                                    model.userDetail?.profile ?? '',
                                    shape: BoxShape.circle,
                                    inner: ImageSize(height: 50, width: 50),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PopupMenuButton<String>(
                                        onSelected: (String result) {
                                          if (result == 'block') {
                                            controller.blockUserData(
                                                blockId: model.userDetail?.sId ?? '', index: index);
                                          } else if (result == 'report') {
                                            controller.reportBottomSheet(
                                                blockId: model.userDetail?.sId ?? '', index: index);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                                          DateUtil.instance
                                              .chatDaysLabelManage(date: model.lastMessage?.createdAt ?? ''),
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                        ),
                                    ],
                                  ),
                                  title: AppText(
                                    model.userDetail?.name ?? '',
                                    style: context.textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: model.lastMessage != null &&
                                          model.lastMessage?.message != null &&
                                          model.lastMessage!.message!.trim().isNotEmpty
                                      ? Padding(
                                          padding: const AppEdgeInsets.v5(),
                                          child: AppText(
                                            model.lastMessage?.message ?? '',
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            );
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
