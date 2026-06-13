import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.selectedCallback,
    required this.currentIndex,
    required this.counter,
    this.chatUnreadBadge,
  });

  final Function(int) selectedCallback;
  final int currentIndex;
  final RxInt counter;
  final RxBool? chatUnreadBadge;

  List<String> ownerIconsAll() {
    return [
      Assets.svg.menuHome,
      Assets.svg.menuPeople,
      Assets.svg.menuMessages,
      Assets.svg.menuNotification,
      Assets.svg.menuProfile,
    ];
  }

  List<String> iconsAll() {
    return [
      Assets.svg.barMainActivity,
      Assets.svg.barMainReceipt,
      Assets.svg.barMainScan,
      Assets.svg.barMainBuilding,
      Assets.svg.profileCircle,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isMember = AppConstant.userType == UserType.member;
    final icons = isMember ? ownerIconsAll() : iconsAll();

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 16, top: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: Container(
          height: 65,
          color: context.theme.colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: icons.asMap().entries.map((entry) {
              final index = entry.key;
              final icon = entry.value;

              return GestureDetector(
                onTap: () {
                  selectedCallback(index);
                  if (isMember && index == 3) {
                    counter.value = 0;
                  }
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const AppEdgeInsets.h12(),
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: currentIndex == index ? context.colorScheme.primary : context.colorScheme.secondary,
                        child: Padding(
                          padding: const AppEdgeInsets.all10(),
                          child: ImageView(
                            icon,
                            color: currentIndex == index ? context.colorScheme.onSecondary : context.colorScheme.secondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    if (isMember && index == 2)
                      Obx(
                        () {
                          if (chatUnreadBadge?.value ?? false) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: context.theme.colorScheme.onPrimary,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      )
                    else if (isMember && index == 3)
                      Obx(
                        () {
                          if (counter.value > 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: context.theme.colorScheme.onPrimary,
                                child: Center(
                                  child: AppText(
                                    counter.value > 9 ? '9+' : counter.value.toString(),
                                    style: context.textTheme.bodySmall?.copyWith(fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
