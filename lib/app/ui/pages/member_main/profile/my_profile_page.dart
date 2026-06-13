import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/member_main/profile/edit_my_profile_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class MyProfilePage extends GetItHook<ProfileController> {
  const MyProfilePage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.myProfilePage);
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
                  appTitle: AppStrings.T.myProfile,
                  isPadding: true,
                  isSecondaryIcon: true,
                  secondaryIconName: ImageView(Assets.svg.userEdit),
                  onSecondaryTap: () {
                    EditMyProfilePage.route()!.then((value) {
                      if (value is bool && value) {
                        controller.onBack();
                      }
                    });
                  }),
              const Gap(20),
              Obx(
                () => ImageView(
                  controller.profileImage.value,
                  shape: BoxShape.circle,
                  inner: ImageSize(height: 120, width: 120),
                ),
              ),
              const Gap(10),
              Obx(
                () => Expanded(
                    child: ListView.builder(
                  itemCount: controller.myProfileList.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor: context.colorScheme.secondary,
                            child: ImageView(
                              controller.myProfileList[index].icon!,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          title: Padding(
                            padding: const AppEdgeInsets.v5(),
                            child: AppText(
                              controller.myProfileList[index].title!,
                              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                            ),
                          ),
                          subtitle: AppText(controller.myProfileList[index].subTitle!, style: context.textTheme.labelMedium),
                        ),
                        if (index == 5)
                          const SizedBox()
                        else
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Divider(
                              height: 1,
                              color: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.1),
                            ),
                          ),
                      ],
                    );
                  },
                )),
              ),
              const CustomSizedBox(),
              FutureBuilder(
                  future: getAppVersion(),
                  builder: (context, asyncSnapshot) {
                    String? info = '';
                    if (asyncSnapshot.hasData) {
                      info = asyncSnapshot.data;
                    }
                    if (info == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppText(
                        'Version: $info',
                        style: context.textTheme.bodySmall?.copyWith(fontSize: 14),
                      ),
                    );
                  })
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
    controller.fetchProfileAPI();
  }

  @override
  void onDispose() {}
}
