import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/friend/friend_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
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

class AddFriendsPage extends GetItHook<FriendController> {
  const AddFriendsPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.addFriendsPage);
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
                appTitle: AppStrings.T.addFriend,
                isPadding: true,
              ),
              const Gap(20),
              TextInputField(
                type: InputType.text,
                controller: controller.searchController,
                hintLabel: AppStrings.T.searchByNameMobile,
                context: context,
                circularValue: 30.0.obs,
                prefixIcon: ImageView(
                  Assets.svg.searchNormal,
                  color: context.colorScheme.secondaryFixedDim,
                ),
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  controller.setSearchValue(value);
                },
              ),
              const Gap(20),
              Expanded(
                child: Obx(() => controller.searchFriendData.isEmpty && controller.isFetch.value
                    ? EmptyScreen(title: AppStrings.T.noFriendsFound)
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: controller.searchFriendData.length + (controller.hasMoreData.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (controller.hasMoreData.value && index > controller.searchFriendData.length - 1) {
                            return const Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final friendData = controller.searchFriendData[index];
                          var mobile='';
                          if(friendData.mobile!=null&&friendData.mobile!.trim().isNotEmpty ){
                            mobile= '*' * (friendData.mobile!.length - 4) +
                                friendData.mobile!.substring(friendData.mobile!.length - 4);
                          }
                          return Obx(
                            () {
                              final isSelected = controller.isFriendSelected(friendData.sId);
                              return GestureDetector(
                                onTap: () => controller.toggleFriendSelection(friendData.sId),
                                child: Container(
                                  margin: const AppEdgeInsets.oB15(),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const AppEdgeInsets.all8(),
                                    leading: ImageView(
                                      friendData.profile ?? '',
                                      shape: BoxShape.circle,
                                      inner: ImageSize(height: 50, width: 50),
                                    ),
                                    trailing: ImageView(
                                      isSelected ? Assets.svg.tickCircle : Assets.svg.addCircle,
                                    ),
                                    title: AppText(friendData.name ?? '', style: context.textTheme.bodyMedium),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: AppText(
                                        mobile,
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(color: context.theme.colorScheme.secondaryFixedDim)),
                                  ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
              ),
              const Gap(20),
              Obx(
                () => controller.selectedFriendIds.isNotEmpty
                    ? AppButton(
                        label: controller.selectedFriendIds.length == 1
                            ? AppStrings.T.add
                            : '${AppStrings.T.add} (${controller.selectedFriendIds.length})',
                        onPressed: controller.sendFriendRequests,
                      )
                    : const SizedBox.shrink(),
              ),
              const CustomSizedBox()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.initialLoad();
  }

  @override
  void onDispose() {
    controller.disposeComponent();
  }
}
