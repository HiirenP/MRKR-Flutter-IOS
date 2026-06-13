import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/pages/authentication/member/member_register_page.dart';
import 'package:marker/app/ui/pages/authentication/owner/owner_register_page.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProfileType = ValueNotifier(0);
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ImageView(
                Assets.images.png.mainScreen.path,
                inner: ImageSize(height: double.infinity, width: double.infinity),
              ),
              //Gradient overlay
              ValueListenableBuilder(
                valueListenable: selectedProfileType,
                builder: (context, value, child) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.onSecondary.withAlpha(30),
                          context.colorScheme.onSecondary.withAlpha(30),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter, // End at the bottom
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SingleLineText(
                          AppStrings.T.profileType,
                          style: context.textTheme.titleLarge!.copyWith(color: context.colorScheme.onPrimary),
                        ),
                        const Gap(8),
                        SingleLineText(
                          AppStrings.T.selectAProfile,
                          style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.onPrimary),
                        ),
                        const Gap(8),
                        GestureDetector(
                          onTap: () {
                            if (selectedProfileType.value != 0) {
                              selectedProfileType.value = 0;
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 75,
                            margin: const AppEdgeInsets.all16(),
                            padding: const AppEdgeInsets.all8(),
                            decoration: BoxDecoration(color: context.colorScheme.onPrimary, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      selectedProfileType.value == 0 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                  radius: 28,
                                  child: ImageView(
                                    Assets.svg.profileCircle,
                                    color: selectedProfileType.value == 0 ? context.colorScheme.onSecondary : context.colorScheme.secondaryFixedDim,
                                  ),
                                ),
                                const Gap(10),
                                SingleLineText(
                                  AppStrings.T.member,
                                  style: context.textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor:
                                      selectedProfileType.value == 0 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                  radius: 13,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: context.colorScheme.onPrimary,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor:
                                          selectedProfileType.value == 0 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selectedProfileType.value != 1) {
                              selectedProfileType.value = 1;
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 75,
                            margin: const AppEdgeInsets.h16(),
                            padding: const AppEdgeInsets.all8(),
                            decoration: BoxDecoration(color: context.colorScheme.onPrimary, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      selectedProfileType.value == 1 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                  radius: 28,
                                  child: Padding(
                                    padding: const AppEdgeInsets.all16(),
                                    child: ImageView(
                                      Assets.svg.menuPeople,
                                      color: selectedProfileType.value == 1 ? context.colorScheme.onSecondary : context.colorScheme.secondaryFixedDim,
                                      inner: ImageSize(height: 26, width: 26),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                SingleLineText(
                                  AppStrings.T.bartender,
                                  style: context.textTheme.bodyMedium!.copyWith(),
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor:
                                      selectedProfileType.value == 1 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                  radius: 13,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: context.colorScheme.onPrimary,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor:
                                          selectedProfileType.value == 1 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        GestureDetector(
                          onTap: () {
                            if (selectedProfileType.value != 2) {
                              selectedProfileType.value = 2;
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 75,
                            margin: const AppEdgeInsets.h16(),
                            padding: const AppEdgeInsets.all8(),
                            decoration: BoxDecoration(color: context.colorScheme.onPrimary, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      selectedProfileType.value == 2 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                  radius: 28,
                                  child: Padding(
                                    padding: const AppEdgeInsets.all16(),
                                    child: ImageView(
                                      Assets.svg.owner,
                                      color: selectedProfileType.value == 2 ? context.colorScheme.onSecondary : context.colorScheme.secondaryFixedDim,
                                      inner: ImageSize(height: 26, width: 26),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                SingleLineText(
                                  AppStrings.T.barOwner,
                                  style: context.textTheme.bodyMedium!.copyWith(),
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  backgroundColor:
                                      selectedProfileType.value == 2 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                  radius: 13,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: context.colorScheme.onPrimary,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor:
                                          selectedProfileType.value == 2 ? context.colorScheme.primary : context.colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(35),
                        Padding(
                          padding: const AppEdgeInsets.h16(),
                          child: AppButton(
                            label: AppStrings.T.continueW,
                            onPressed: () {
                              if (selectedProfileType.value == 0) {
                                MemberRegisterPage.route()?.then(
                                  (value) {
                                    if (value != null && value is bool) {
                                      if (value) {
                                        Get.back(result: {'user_type': UserType.member});
                                      }
                                    }
                                  },
                                );
                              } else if (selectedProfileType.value == 1) {
                                Get.back(result: {'user_type': UserType.manager});
                              } else {
                                OwnerRegisterPage.route()?.then(
                                  (value) {
                                    if (value != null && value is bool) {
                                      if (value) {
                                        Get.back(result: {'user_type': UserType.owner});
                                      }
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const Gap(20),
                        const CustomSizedBox()
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
