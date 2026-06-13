import 'package:dotted_line/dotted_line.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/message/chat_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/data/models/messages_model/messages_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/home/map_location_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ChatPage extends GetItHook<ChatController> {
  const ChatPage({super.key});

  static Future<T?>? route<T>(ChatDataModel? model, {Map<String, dynamic>? map, bool isSkipRoute = false}) {
    if (isSkipRoute) {
      return Get.offNamed(AppRoutes.chatPage, arguments: map != null ? [model, map] : model);
    }
    return Get.toNamed(AppRoutes.chatPage, arguments: map != null ? [model, map] : model);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.onUserBack();
      },
      child: FocusScope(
        child: Form(
          child: Scaffold(
            body: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const AppEdgeInsets.all16(),
                    child: Obx(
                      () => AppCustomAppbar(
                        appTitle: controller.userName.value,
                        isPadding: true,
                        isSecondaryIcon: true,
                        secondaryIconName: Padding(
                          padding: const EdgeInsets.all(1),
                          child: ImageView(Assets.svg.video),
                        ),
                        onTap: controller.onUserBack,
                        onSecondaryTap: () {
                          keyboardHide();
                          controller.callingTokenAPI();
                        },
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const AppEdgeInsets.h16(),
                      child: Column(
                        children: [
                          const Gap(5),
                          Expanded(
                            child: GestureDetector(
                              onTap: keyboardHide,
                              child: ColoredBox(
                                color: Colors.white,
                                child: Obx(
                                  () {
                                    debugPrint('controller.isMoreData.value--->${controller.isMoreData.value}');
                                    return controller.isLoading.value
                                        ? const Center(child: CircularProgressIndicator())
                                        : controller.listGroup.isEmpty
                                            ? const SizedBox.shrink()
                                            : NotificationListener<ScrollNotification>(
                                                onNotification: (notification) {
                                                  if (notification is UserScrollNotification) {
                                                    final direction = notification.direction;
                                                    if (direction == ScrollDirection.forward) {
                                                      controller.isUserScrolling = true;
                                                      debugPrint('User is scrolling on top: $direction');
                                                    } else if (direction == ScrollDirection.reverse) {
                                                      debugPrint('User is scrolling on bottom');
                                                    } else {
                                                      debugPrint('User stopped scrolling');
                                                    }
                                                  } else if (notification is ScrollUpdateNotification && !controller.isUserScrolling) {
                                                    debugPrint('System is scrolling programmatically');
                                                  }
                                                  return false;
                                                },
                                                child: ListView.builder(
                                                  controller: controller.scrollController,
                                                  itemCount: controller.listGroup.length,
                                                  reverse: true,
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final model = controller.listGroup[index] as Map<String, dynamic>;
                                                    final date = model['date'] as String?;
                                                    if (model.containsKey('list')) {
                                                      var list = model['list'] as List<MessagesDataModel>;
                                                      list = list.reversed.toList();
                                                      return Column(
                                                        children: [
                                                          Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: context.theme.colorScheme.secondaryFixedDim),
                                                              child: AppText(
                                                                DateUtil().changeDateFormat(date ?? '', format: DateUtil.instance.MMddyyyy),
                                                                style: context.textTheme.bodySmall?.copyWith(color: context.theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),
                                                              )),
                                                          ListView.separated(
                                                            padding: EdgeInsets.zero,
                                                            itemCount: list.length,
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemBuilder: (context, index) {
                                                              final messageModel = list[index];
                                                              final sender = messageModel.senderId?.sId == controller.userId;
                                                              final markerModel = list[index].markerId;
                                                              final msgType = markerModel != null;
                                                              return Column(
                                                                crossAxisAlignment: sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                                children: [
                                                                  Wrap(
                                                                    alignment: sender ? WrapAlignment.end : WrapAlignment.start,
                                                                    crossAxisAlignment: WrapCrossAlignment.end,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onLongPress: messageModel.sid != null && messageModel.sid!.isNotEmpty
                                                                            ? () => controller.confirmDeleteMessage(messageModel)
                                                                            : null,
                                                                        child: Container(
                                                                        margin: sender ? const EdgeInsets.fromLTRB(70, 5, 0, 0) : const EdgeInsets.fromLTRB(0, 5, 70, 0),
                                                                        padding: const EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                          color: sender ? context.colorScheme.secondary : context.colorScheme.primary,
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft: const Radius.circular(14),
                                                                            topRight: const Radius.circular(14),
                                                                            bottomRight: Radius.circular(sender ? 0 : 14),
                                                                            bottomLeft: Radius.circular(sender ? 14 : 0),
                                                                          ),
                                                                        ),
                                                                        child: msgType
                                                                            ? Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: context.colorScheme.secondary,
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    ImageView(
                                                                                      markerModel.drinkId?.image ?? '',
                                                                                      borderRadius: BorderRadius.circular(18),
                                                                                      inner: ImageSize(height: 200, width: Get.width * 0.55),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          const Gap(15),
                                                                                          Row(
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: AppText(
                                                                                                  markerModel.barId?.ownerId?.name ?? '',
                                                                                                  style: context.textTheme.titleSmall,
                                                                                                ),
                                                                                              ),
                                                                                              AppText(
                                                                                                hideText(markerModel.secretCode ?? ''),
                                                                                                style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.primary),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          const Gap(10),
                                                                                          DottedLine(
                                                                                            dashColor: context.colorScheme.primary.withAlpha(35),
                                                                                          ),
                                                                                          const Gap(10),
                                                                                          Align(
                                                                                            alignment: Alignment.centerLeft,
                                                                                            child: AppText(
                                                                                              markerModel.drinkId?.description ?? '',
                                                                                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                                                                            ),
                                                                                          ),
                                                                                          const Gap(10),
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                              color: context.colorScheme.onPrimary,
                                                                                            ),
                                                                                            child: ListTile(
                                                                                              onTap: () {
                                                                                                MapLocationPage.route(drink: markerModel);
                                                                                              },
                                                                                              contentPadding: const AppEdgeInsets.h8(),
                                                                                              leading: Assets.images.png.nearL.image(),
                                                                                              trailing: ImageView(
                                                                                                Assets.svg.location,
                                                                                                color: context.theme.primaryColor,
                                                                                              ),
                                                                                              title: AppText(
                                                                                                (markerModel.barId?.name ?? '').capitalize ?? '',
                                                                                                style: context.textTheme.bodyMedium,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : //Marker widget view set in chat list
                                                                            AppText(
                                                                                messageModel.message ?? '',
                                                                                style: context.textTheme.bodySmall
                                                                                    ?.copyWith(color: sender ? context.colorScheme.secondaryFixedDim : context.colorScheme.onSecondary),
                                                                              ),
                                                                      ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // Only show time if it's the last message or if next message has different time
                                                                  Builder(
                                                                    builder: (context) {
                                                                      final currentTime = DateUtil.instance.dateDFormat(messageModel.createdAt ?? '', format: DateUtil().hhMMA);
                                                                      final isLastMessage = index == list.length - 1;
                                                                      String? nextTime;
                                                                      if (!isLastMessage) {
                                                                        nextTime = DateUtil.instance.dateDFormat(list[index + 1].createdAt ?? '', format: DateUtil().hhMMA);
                                                                      }
                                                                      final shouldShowTime = isLastMessage || currentTime != nextTime;
                                                                      return shouldShowTime
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(top: 5),
                                                                              child: AppText(
                                                                                currentTime,
                                                                                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                                                              ),
                                                                            )
                                                                          : const SizedBox.shrink();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                            separatorBuilder: (BuildContext context, int index) {
                                                              return const SizedBox(height: 5);
                                                            },
                                                          ),
                                                          if (index == controller.listGroup.length - 1 && controller.isMoreData.value)
                                                            const Center(
                                                                child: Padding(
                                                              padding: EdgeInsets.all(8),
                                                              child: CircularProgressIndicator(),
                                                            )),
                                                        ],
                                                      );
                                                    }
                                                    return const SizedBox();
                                                  },
                                                ),
                                              );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const Gap(8),
                          Obx(
                            () => Container(
                              padding: controller.isSend.value == true ? EdgeInsets.zero : const AppEdgeInsets.all8(),
                              decoration: BoxDecoration(
                                color: context.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  Obx(
                                    () => controller.markerId.value.isNotEmpty
                                        ? Column(
                                            children: [
                                              Container(
                                                height: 140,
                                                margin: controller.marker != null ? EdgeInsets.zero : const AppEdgeInsets.oB10(),
                                                decoration: BoxDecoration(
                                                  color: context.colorScheme.onPrimary,
                                                  borderRadius: BorderRadius.circular(18),
                                                ),
                                                alignment: Alignment.bottomCenter,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const AppEdgeInsets.all8(),
                                                      child: ImageView(
                                                        controller.marker?.drinkId?.image ?? '',
                                                        borderRadius: BorderRadius.circular(18),
                                                        inner: ImageSize(width: 115, height: 140),
                                                      ),
                                                    ),
                                                    const Gap(5),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          AppText(controller.marker?.drinkId?.name?.capitalize ?? '', style: context.textTheme.titleSmall),
                                                          const Gap(10),
                                                          Row(
                                                            children: [
                                                              ImageView(
                                                                Assets.svg.owner,
                                                                color: context.colorScheme.primary,
                                                                inner: ImageSize(height: 20, width: 20),
                                                              ),
                                                              const Gap(5),
                                                              Expanded(
                                                                child: AppText(
                                                                  controller.marker?.barId?.name?.capitalize ?? '',
                                                                  style: context.textTheme.bodySmall?.copyWith(
                                                                    color: context.colorScheme.secondaryContainer,
                                                                  ),
                                                                ),
                                                              ),
                                                              const Gap(1),
                                                            ],
                                                          ),
                                                          const Gap(5),
                                                          Row(
                                                            children: [
                                                              ImageView(
                                                                Assets.svg.ticket,
                                                                inner: ImageSize(height: 20, width: 20),
                                                              ),
                                                              const Gap(5),
                                                              AppText(
                                                                hideText(controller.marker?.secretCode ?? ''),
                                                                style: context.textTheme.bodySmall?.copyWith(
                                                                  color: context.colorScheme.secondaryContainer,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Gap(5),
                                              SizedBox(
                                                height: 40,
                                                child: ListView.builder(
                                                  itemCount: controller.listDefaultMessage.length,
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final msg = controller.listDefaultMessage[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        controller.messageController.text = msg;
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        margin: const AppEdgeInsets.oL8(),
                                                        padding: const AppEdgeInsets.h12(),
                                                        decoration: BoxDecoration(
                                                          color: context.colorScheme.onPrimary,
                                                          borderRadius: BorderRadius.circular(30),
                                                          border: Border.all(
                                                            color: context.colorScheme.secondaryFixedDim.withAlpha(35),
                                                          ),
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: AppText(
                                                          msg,
                                                          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const Gap(5),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Obx(
                                        () => IconButton(
                                          onPressed: controller.toggleEmojiPicker,
                                          icon: Icon(
                                            controller.showEmojiPicker.value ? Icons.keyboard_outlined : Icons.emoji_emotions_outlined,
                                            color: context.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(
                                          () => TextInputField(
                                            type: InputType.text,
                                            controller: controller.messageController,
                                            focusNode: controller.messageFocusNode,
                                            hintLabel: AppStrings.T.typeMessage,
                                            context: context,
                                            minLines: 1,
                                            maxLines: 4,
                                            keyboardType: TextInputType.multiline,
                                            textInputAction: TextInputAction.newline,
                                            fillColor: controller.isSend.value
                                                ? context.colorScheme.secondary
                                                : context.colorScheme.onPrimary,
                                            onTap: () {
                                              if (controller.showEmojiPicker.value) {
                                                controller.showEmojiPicker.value = false;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const Gap(8),
                                      Obx(
                                        () {
                                          if (controller.isLoading.value) {
                                            return const SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              ),
                                            );
                                          }
                                          return GestureDetector(
                                            onTap: controller.emitNewMessage,
                                            child: Container(
                                              height: 48,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: context.colorScheme.primary,
                                              ),
                                              child: Padding(
                                                padding: const AppEdgeInsets.all8(),
                                                child: ImageView(Assets.svg.send),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => controller.showEmojiPicker.value
                                        ? SizedBox(
                                            height: 280,
                                            child: EmojiPicker(
                                              onEmojiSelected: (category, emoji) {
                                                controller.onEmojiSelected(emoji.emoji);
                                              },
                                              config: Config(
                                                height: 280,
                                                checkPlatformCompatibility: true,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.chatInitialize();
  }

  @override
  void onDispose() {
    controller.disposeRecords();
  }
}
