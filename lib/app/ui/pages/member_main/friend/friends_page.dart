import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/member_main/friend/friend_list_controller.dart';
import 'package:marker/app/data/models/chat_user_model/chat_user_model.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/member_main/friend/add_friends_page.dart';
import 'package:marker/app/ui/pages/member_main/home/map_near_by_bar_page.dart';
import 'package:marker/app/ui/pages/member_main/message/chat_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class FriendsPage extends GetItHook<FriendListController> {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppEdgeInsets.all16(),
      child: Column(
        children: [
          AppCustomAppbar(
            appTitle: AppStrings.T.friendList,
            isSecondaryIcon: true,
            isHideBackButton: true,
            enableKeyboardDismissButton: true,
            keyboardFocusNode: controller.searchFocusNode,
            isPadding: true,
            secondaryIconName: ImageView(Assets.svg.addProfile),
            onSecondaryTap: AddFriendsPage.route,
          ),
          const Gap(20),
          TextInputField(
            type: InputType.text,
            controller: controller.searchController,
            focusNode: controller.searchFocusNode,
            hintLabel: AppStrings.T.searchByNameMobile,
            context: context,
            circularValue: 30.0.obs,
            prefixIcon: ImageView(
              Assets.svg.searchNormal,
              color: context.colorScheme.secondaryFixedDim,
            ),
            textInputAction: TextInputAction.search,
            onChanged: controller.onSearchFriend,
          ),
          const Gap(20),
          Expanded(
            child: Obx(
              () {
                debugPrint('--->${controller.listFriends.length}');
                debugPrint('isFetch--->${controller.isFetch.value}');
                if (controller.listFriends.isEmpty && controller.isFetch.value) {
                  return EmptyScreen(
                    title: AppStrings.T.noFriendsFound,
                  );
                } else {
                  return ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.listFriends.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      final model = controller.listFriends[index];
                      return GestureDetector(
                        onTap: () {
                          final modelChat =
                              ChatDataModel.fromJson({'user_detail': jsonDecode(jsonEncode(model)), 'lastMessage': null});
                          ChatPage.route(modelChat)?.then((value) {
                            if (value != null) {
                              Future.microtask(() {
                                Get.back(result: value); // or whatever you're doing after navigation
                              });
                            }
                          });
                        },
                        child: Container(
                          margin: const AppEdgeInsets.oB15(),
                          padding: const AppEdgeInsets.v5(),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(18), color: context.colorScheme.secondary),
                          child: ListTile(
                            leading: ImageView(
                              model.profile ?? '',
                              shape: BoxShape.circle,
                              inner: ImageSize(height: 50, width: 50),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      if (model.location?.coordinates != null) {
                                        controller.selectedIndex.value = index;
                                        final latLng = LatLng(double.parse('${model.location?.coordinates?.last ?? 0}'),
                                            double.parse('${model.location?.coordinates?.first ?? 0}'));
                                        final map = {'latLng': latLng, 'isFriend': true};
                                        await MapNearByBarPage.route(map: map);
                                      } else {
                                        showError("Friend's location not found.");
                                      }
                                    },
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: ImageView(Assets.svg.send, color: context.colorScheme.primary))),
                                const Gap(10),
                                GestureDetector(
                                  onTap: () async {
                                    final value = await controller.deleteFriendBottomSheet();
                                    if (value != null && value is bool) {
                                      if (value) {
                                        await controller.deleteFriendAPI(index);
                                      }
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: AppColors.darkRed,
                                  ),
                                ),
                              ],
                            ),
                            title: AppText(model.name ?? '', style: context.textTheme.bodyMedium),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const CustomSizedBox()
        ],
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.onInitialize();
  }

  @override
  void onDispose() {}
}
