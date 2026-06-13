import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/bar_profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/availability_page.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class BarProfileAboutPage extends GetItHook<BarProfileController> {
  const BarProfileAboutPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.barProfileAboutPage);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: controller.aboutList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CircularContainer(
                    imagePath: controller.aboutList[index].icon!,
                  ),
                ),
                title: Padding(
                  padding: const AppEdgeInsets.v5(),
                  child: AppText(
                    controller.aboutList[index].title!,
                    style: context.textTheme.displaySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                  ),
                ),
                subtitle: AppText(controller.aboutList[index].subTitle ?? '', style: context.textTheme.bodySmall),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: AvailabilityPage.route,
          child: Container(
            margin: const AppEdgeInsets.all16(),
            padding: const AppEdgeInsets.hv105(),
            decoration: BoxDecoration(color: context.colorScheme.secondary, borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ImageView(
                Assets.svg.calendar,
                color: context.colorScheme.primary,
              ),
              trailing: ImageView(Assets.svg.arrowRight),
              title: AppText(AppStrings.T.availability, style: context.textTheme.bodyMedium),
            ),
          ),
        ),
        const Gap(30),
      ],
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  Future<void> onInit() async {}

  @override
  void onDispose() {}
}
