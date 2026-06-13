import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/send_to_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/message/chat_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class SendToPage extends GetItHook<SendToController> {
  const SendToPage({super.key});

  static Future<T?>? route<T>({required RedeemedUpcomingListData model}) {
    return Get.offNamed(AppRoutes.sendToPage, arguments: model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const AppEdgeInsets.all16(),
          child: Column(
            children: [
              AppCustomAppbar(
                appTitle: AppStrings.T.sendTo,
                isPadding: true,
              ),
              Obx(() {
                if (controller.isSuccess.value) {
                  return Expanded(
                    child: Column(
                      children: [
                        const Gap(20),
                        TextInputField(
                          type: InputType.text,
                          controller: controller.searchController,
                          hintLabel: AppStrings.T.searchName,
                          context: context,
                          circularValue: 30.0.obs,
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
                            () => controller.listFriends.isEmpty
                                ? EmptyScreen(title: AppStrings.T.noFriendsFound)
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    controller: controller.scrollController,
                                    itemCount: controller.listFriends.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final model = controller.listFriends[index];
                                      return Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            controller.selectedIndex.value = index;
                                          },
                                          child: Container(
                                            margin: const AppEdgeInsets.oB15(),
                                            decoration: BoxDecoration(
                                              color: context.colorScheme.secondary,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              contentPadding: const AppEdgeInsets.all10(),
                                              leading: ImageView(
                                                model.profile ?? '',
                                                shape: BoxShape.circle,
                                                inner: ImageSize(height: 50, width: 50),
                                              ),
                                              trailing: CircleAvatar(
                                                backgroundColor: controller.selectedIndex.value == index
                                                    ? context.colorScheme.primary
                                                    : context.colorScheme.primaryContainer,
                                                radius: 13,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: context.colorScheme.onPrimary,
                                                  child: CircleAvatar(
                                                    radius: 8,
                                                    backgroundColor: controller.selectedIndex.value == index
                                                        ? context.colorScheme.primary
                                                        : context.colorScheme.primaryContainer,
                                                  ),
                                                ),
                                              ),
                                              title: AppText(model.name ?? '', style: context.textTheme.bodyMedium),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: AppText(model.email ?? '', style: context.textTheme.bodySmall),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const Gap(20),
                        Obx(
                          () => controller.selectedIndex.value == -1
                              ? const SizedBox()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppButton(
                                      label: AppStrings.T.send,
                                      onPressed: () {
                                        final modelFriend = controller.listFriends[controller.selectedIndex.value];

                                        final model = ChatDataModel.fromJson({
                                          'user_detail': jsonDecode(jsonEncode(modelFriend)),
                                          'lastMessage': {'markerId': jsonDecode(jsonEncode(controller.modelMarker))},
                                          'sendMarker': true
                                        });
                                        debugPrint('modelFriend-->${jsonEncode(controller.modelMarker)}');
                                        ChatPage.route(model,isSkipRoute: true);
                                      },
                                    ),
                                    const CustomSizedBox()
                                  ],
                                ),
                        ),
                      ],
                    ),
                  );
                }
                return Visibility(visible: controller.isSuccess.value, child: const SizedBox.shrink());
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.onInitialize();
  }

  @override
  void onDispose() {
    controller.onDismiss();
  }
}
