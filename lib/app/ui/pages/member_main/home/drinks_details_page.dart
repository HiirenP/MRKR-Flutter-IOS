import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/drink_details_controller.dart';
import 'package:marker/app/data/models/search_drinks_model/search_drinks_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/drink_category_label.dart';
import 'package:marker/app/ui/widgets/marker_price_breakdown_section.dart';
import 'package:marker/app/ui/widgets/platform_fee_breakdown.dart';
import 'package:marker/app/ui/widgets/review_list.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class DrinkDetailsView extends GetItHook<DrinkDetailsController> {
  const DrinkDetailsView({super.key});

  static Future<T?>? route<T>({String? barId, bool isShow = false, SearchDrinksList? drink, bool isFriend = false}) {
    return Get.toNamed(AppRoutes.drinkDetails, arguments: [barId, isShow, drink, isFriend]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Obx(() {
            final drink = controller.drink;
            final showPlatformFees = controller.platformFeeBreakdown.isNotEmpty ||
                controller.platformFeesTotal.value > 0;
            return Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomAppbar(
                    appTitle: controller.isShow.value ? controller.drinkData.value.name : AppStrings.T.beerSummary,
                    isPadding: true,
                    isSecondaryIcon: controller.isShow.value,
                    secondaryIconName: ImageView(Assets.svg.export),
                    onSecondaryTap: controller.onShareTap,
                  ),
                  const Gap(15),
                  if (!controller.isDataFound.value)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Container(
                                  padding: const AppEdgeInsets.all14(),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(
                                    children: [
                                      ImageView(
                                        drink?.image ?? '',
                                        borderRadius: BorderRadius.circular(18),
                                        inner: ImageSize(height: 220, width: Get.width - 60),
                                      ),
                                      const Gap(15),
                                      ListTile(
                                        trailing: AppText(AppValidations.getFormattedPrice(drink?.price ?? ''), style: context.textTheme.titleMedium),
                                        contentPadding: EdgeInsets.zero,
                                        title: AppText(drink?.name?.capitalize ?? '', style: context.textTheme.titleSmall),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if ((drink?.category?.name ?? '').isNotEmpty) ...[
                                                DrinkCategoryLabel(categoryName: drink!.category!.name!),
                                                const Gap(6),
                                              ],
                                              Row(
                                                children: [
                                                  ImageView(Assets.svg.sStar),
                                                  const Gap(5),
                                                  AppText(
                                                    drink?.reviewStats?.avgRating.toString() ?? '',
                                                    style: context.textTheme.bodySmall,
                                                  ),
                                                  const Gap(5),
                                                  SingleLineText(
                                                    AppStrings.T.reviews(drink?.reviewStats?.total?.toString() ?? ''),
                                                    style: context.textTheme.bodySmall,
                                                  ),
                                                  if (controller.isShow.value) ...[
                                                    const Gap(12),
                                                    GestureDetector(
                                                      behavior: HitTestBehavior.opaque,
                                                      onTap: () async {
                                                        final myReview = controller.drinkData.value.myReview;
                                                        final updated = await Get.toNamed(
                                                          AppRoutes.drinkReviewSubmitPage,
                                                          arguments: {
                                                            'drinkId': controller.drinkId,
                                                            'drinkName': drink?.name ?? '',
                                                            'barId': controller.drinkData.value.barId ?? '',
                                                            'barName': controller.barName.value,
                                                            'reviewId': myReview?.sId,
                                                            'review': myReview?.review,
                                                            'reviewStars': myReview?.stars,
                                                          },
                                                        );
                                                        if (updated == true) {
                                                          await controller.getDrinkDetailsData();
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                                        child: Obx(
                                                          () => AppText(
                                                            controller.hasMyDrinkReview.value
                                                                ? 'Edit Review'
                                                                : AppStrings.T.writeReview,
                                                            style: context.textTheme.bodySmall?.copyWith(
                                                              color: context.colorScheme.primary,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DottedLine(dashColor: context.colorScheme.secondaryFixedDim.withAlpha(35)),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          CircularContainer(
                                            imagePath: Assets.svg.documentText,
                                            bgColor: context.colorScheme.onPrimary,
                                          ),
                                          const Gap(8),
                                          Expanded(
                                            child: AppText(
                                              drink?.description ?? '',
                                              maxLines: 10,
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.secondaryFixedDim,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      if (controller.isShow.value)
                                        const SizedBox.shrink()
                                      else
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Container(
                                            padding: const AppEdgeInsets.all16(),
                                            decoration: BoxDecoration(
                                              color: context.colorScheme.onPrimary,
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppText(AppStrings.T.barProfile, style: context.textTheme.bodySmall),
                                                Row(
                                                  children: [
                                                    ImageView(
                                                      controller.barImage.value,
                                                      shape: BoxShape.circle,
                                                      inner: ImageSize(height: 40, width: 40),
                                                    ),
                                                    const Gap(5),
                                                    AppText(controller.barName.value.capitalize ?? '', style: context.textTheme.titleSmall),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                if (showPlatformFees) ...[
                                  const Gap(12),
                                  MarkerPriceBreakdownSection(
                                    child: PlatformFeeBreakdownView(
                                      basePrice: num.tryParse('${drink?.price ?? 0}') ?? 0,
                                      tip: 0,
                                      breakdown: controller.platformFeeBreakdown,
                                      platformFeesTotal: controller.platformFeesTotal.value,
                                    ),
                                  ),
                                ],
                                const Gap(15),
                                if ((drink?.latestReviews?.isNotEmpty ?? false) && controller.isShow.value)
                                  ReviewList(reviews: drink!.latestReviews!),
                              ],
                            ),
                          ),
                          const Gap(10),
                          AppButton(
                            label: controller.isShow.value ? AppStrings.T.buyNow : AppStrings.T.makePayment,
                            onPressed: controller.onButtonTap,
                          ),
                          const CustomSizedBox(),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.initData();
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
