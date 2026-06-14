import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/notifications/notifications_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:readmore/readmore.dart';

class NotificationsPage extends GetItHook<NotificationsController> {
  const NotificationsPage({super.key, this.isBackShow = false});

  final bool isBackShow;

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.notificationsPage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppEdgeInsets.all16(),
      child: Column(
        children: [
          AppCustomAppbar(
            appTitle: AppStrings.T.notification,
            isHideBackButton: isBackShow,
            isPadding: true,
          ),
          const Gap(20),
          Obx(
            () => Expanded(
              child: controller.isDataEmpty.value
                  ? EmptyScreen(
                      title: AppStrings.T.notificationTitle,
                      subTitle: AppStrings.T.notificationSubtitle,
                    )
                  : ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: controller.notificationsList.length + (controller.hasMoreData.value ? 1 : 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index > controller.notificationsList.length - 1 && controller.hasMoreData.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final list = controller.notificationsList[index];
                        return Container(
                          margin: const AppEdgeInsets.oB15(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: context.colorScheme.secondary,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const AppEdgeInsets.hv1610(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const AppEdgeInsets.v10(),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: context.colorScheme.onPrimary,
                                        child: ImageView(Assets.svg.notification),
                                      ),
                                    ),
                                    const Gap(8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AppText(list.title ?? '', style: context.textTheme.bodyMedium),
                                          const Gap(2),
                                          ReadMoreText(
                                            formatNotificationBody(list.body),
                                            trimMode: TrimMode.Line,
                                            colorClickableText: context.theme.primaryColor,
                                            trimCollapsedText: ' ${AppStrings.T.showMore}',
                                            trimExpandedText: ' ${AppStrings.T.showLess}',
                                            lessStyle: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.primary,
                                            ),
                                            style: TextStyle(
                                                color: context.colorScheme.secondaryFixedDim,
                                                fontSize: 14,
                                                fontFamily: 'Hellix'),
                                            moreStyle: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.primary,
                                            ),
                                          ),
                                          /*AppText(
                                            list.body ?? '',
                                            style: context.textTheme.bodySmall?.copyWith(
                                              color: context.colorScheme.secondaryFixedDim,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),*/
                                          if (list.type == 'friend_request' ||
                                              (list.type == 'marker_redeem_request' &&
                                                  list.approvalRequestId != null) ||
                                              list.type == 'approval')
                                            Padding(
                                              padding: const AppEdgeInsets.v5(),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: AppSecondaryButton(
                                                        textStyle: context.textTheme.bodyMedium!.copyWith(
                                                          color: context.colorScheme.secondary,
                                                        ),
                                                        backgroundColor: context.colorScheme.onPrimary,
                                                        label: AppStrings.T.cancel,
                                                        onPressed: () {
                                                          if (list.type == 'friend_request') {
                                                            controller.acceptFriendRequest(list, status: 'cancel');
                                                          } else if (list.type == 'marker_redeem_request') {
                                                            controller.redeemRequest(list, status: 'rejected');
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 40,
                                                      child: AppButton(
                                                        textStyle: context.textTheme.bodyMedium,
                                                        label: list.type == 'friend_request'
                                                            ? AppStrings.T.accept
                                                            : list.type == 'marker_redeem_request'
                                                                ? AppStrings.T.approval
                                                                : AppStrings.T.accept,
                                                        onPressed: () {
                                                          if (list.type == 'friend_request') {
                                                            controller.acceptFriendRequest(list);
                                                          } else if (list.type == 'marker_redeem_request') {
                                                            controller.redeemRequest(list);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => controller.deleteNotification(list, index),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: context.colorScheme.primary,
                                      ),
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: context.colorScheme.secondaryContainer.withAlpha(25),
                                height: 1,
                              ),
                              Padding(
                                padding: const AppEdgeInsets.hv1610(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        DateUtil.instance.dateDFormat(list.createdAt ?? ''),
                                        style: context.textTheme.bodySmall?.copyWith(
                                          color: context.colorScheme.secondaryContainer,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    AppText(
                                      DateUtil.instance.dateDFormat(
                                        list.createdAt ?? '',
                                        format: DateUtil.instance.hhMMA,
                                      ),
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colorScheme.secondaryContainer,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.updateInitEntry();
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
