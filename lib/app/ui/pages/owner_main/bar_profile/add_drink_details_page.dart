import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/add_drink_controller.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/edit_drink_page.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/drink_category_label.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class AddDrinkDetailsPage extends GetItHook<AddDrinkController> {
  const AddDrinkDetailsPage({super.key});

  static Future<T?>? route<T>(String? drinkId, {String barName = ''}) {
    return Get.toNamed(AppRoutes.addDrinkDetailsPage, arguments: {'drinkId': drinkId, 'barName': barName});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Padding(
            padding: const AppEdgeInsets.all16(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCustomAppbar(
                  isPadding: true,
                  widget: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            final message = AppStrings.T.shareDrinkBarMessage(controller.drinkNameController.text.trim(), controller.barName);
                            shareMessage(message: message);
                          },
                          child: CircularContainer(imagePath: Assets.svg.export, isColor: true)),
                      const Gap(5),
                      AppConstant.isOwnerLogin(
                          child: GestureDetector(
                        onTap: () =>
                            EditDrinkPage.route(drinkDetailsData: controller.getDrink.value, drinkId: controller.drinksId.value)!.then((value) {
                          if (value != null) {
                            if (value is BarDrinkData) {
                              Get.back(result: value);
                            }
                          }
                        }),
                        child: CircularContainer(imagePath: Assets.svg.edit, isColor: true),
                      )),
                      const Gap(5),
                      AppConstant.isOwnerLogin(
                        child: GestureDetector(
                          onTap: () {
                            controller.deleteAccountBottomSheet().then((value) {
                              if (value != null && value is bool) {
                                if (value) {
                                  Get.back(result: true);
                                }
                              }
                            });
                          },
                          child: CircularContainer(imagePath: Assets.svg.trash, color: context.colorScheme.onSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: Obx(() {
                    if (!controller.isFetch.value) {
                      return const SizedBox.shrink();
                    }
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          padding: const AppEdgeInsets.all10(),
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Obx(() {
                            if (!controller.isFetch.value) {
                              return const SizedBox.shrink();
                            } else {
                              return Column(
                                children: [
                                  ImageView(
                                    controller.getDrink.value.image ?? '',
                                    borderRadius: BorderRadius.circular(18),
                                    inner: ImageSize(height: 200, width: double.infinity),
                                  ),
                                  const Gap(15),
                                  ListTile(
                                    trailing: AppText(
                                      AppValidations.getFormattedPrice(controller.getDrink.value.price ?? ''),
                                      style: context.textTheme.titleMedium,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    title: AppText(
                                      controller.getDrink.value.name ?? '',
                                      style: context.textTheme.titleSmall,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if ((controller.getDrink.value.category?.name ?? '').isNotEmpty) ...[
                                            DrinkCategoryLabel(
                                              categoryName: controller.getDrink.value.category!.name!,
                                            ),
                                            const Gap(6),
                                          ],
                                          Row(
                                            children: [
                                              ImageView(Assets.svg.sStar),
                                              const Gap(5),
                                              AppText(
                                                '${controller.getDrink.value.reviewStats?.avgRating ?? "0"}',
                                                style: context.textTheme.bodySmall,
                                              ),
                                              const Gap(5),
                                              SingleLineText(
                                                AppStrings.T.reviews('${controller.getDrink.value.reviewStats?.total ?? "0"}'),
                                                style: context.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DottedLine(
                                    dashColor: context.colorScheme.secondaryContainer.withValues(alpha: 0.1),
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      CircularContainer(
                                        imagePath: Assets.svg.documentText,
                                        bgColor: context.colorScheme.onPrimary,
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: AppText(
                                          controller.getDrink.value.description ?? '',
                                          maxLines: 3,
                                          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }
                          }),
                        ),
                        const Gap(10),
                        AppText(
                          AppStrings.T.review,
                          style: context.textTheme.bodyMedium,
                        ),
                        const Gap(10),
                        Obx(() {
                          if (controller.getDrink.value.latestReviews == null || controller.getDrink.value.latestReviews!.isEmpty) {
                            return EmptyScreen(
                              subTitle: AppStrings.T.drinkReviewSubtitle,
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: controller.getDrink.value.latestReviews?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final model = controller.getDrink.value.latestReviews?[index];
                                return Container(
                                  margin: const AppEdgeInsets.oB15(),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: ImageView(
                                            model?.userId?.profile ?? '',
                                            shape: BoxShape.circle,
                                            inner: ImageSize(height: 45, width: 45),
                                          ),
                                        ),
                                        trailing: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: AppText(
                                            DateUtil.instance.dateDFormat(model?.createdAt ?? ''),
                                            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: AppText(model?.userId?.name ?? '', style: context.textTheme.bodyMedium),
                                        ),
                                        subtitle: RatingBar.builder(
                                          initialRating: double.parse('${model?.stars ?? 1}'),
                                          minRating: 1,
                                          itemSize: 20,
                                          allowHalfRating: true,
                                          unratedColor: context.colorScheme.primaryContainer,
                                          itemBuilder: (context, _) => ImageView(Assets.images.png.bigStar.path),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ),
                                      Divider(color: context.colorScheme.secondaryContainer.withValues(alpha: 0.1)),
                                      Padding(
                                        padding: const AppEdgeInsets.h16(),
                                        child: AppText(
                                          model?.review ?? '',
                                          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryFixedDim),
                                        ),
                                      ),
                                      const Gap(8)
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }),
                        const Gap(30),
                      ],
                    );
                  }),
                ),
                const CustomSizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.isFetch.value = false;
    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
        final map = Get.arguments as Map<String, dynamic>;
        controller.drinksId.value = map['drinkId'].toString();
        controller.barName = map['barName'].toString();
        controller.getDrinkDetailsData();
      }
    }
  }

  @override
  void onDispose() {
    controller.getDrink.value = DrinkDetailsData();
  }
}
