import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/member_main/home/drink_review_controller.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class MarkerRedeemedPage extends GetItHook<DrinkReviewController> {
  const MarkerRedeemedPage({super.key});

  static Future<T?>? route<T>({RedeemedUpcomingListData? drink}) {
    return Get.toNamed(AppRoutes.markerRedeemedPage, arguments: drink);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: GestureDetector(
            onTap: keyboardHide,
            child: Stack(
              children: [
                ImageView(
                  Assets.images.png.redeemBg.path,
                  inner: ImageSize(height: Get.height, width: Get.width),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 42),
                  child: Column(
                    children: [
                      const AppCustomAppbar(),
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: context.colorScheme.primary.withValues(alpha: 0.1),
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: context.colorScheme.primary,
                                  child: Assets.images.png.rightArrow.image(),
                                ),
                              ),
                              Padding(
                                padding: const AppEdgeInsets.all16(),
                                child: Column(
                                  children: [
                                    Obx(
                                      () => AppText(
                                          controller.isBarReview.value
                                              ? AppStrings.T.barReview
                                              : AppStrings.T.markerRedeemed,
                                          style: context.textTheme.titleLarge),
                                    ),
                                    const Gap(35),
                                    Obx(
                                      () => Padding(
                                        padding: const AppEdgeInsets.h16(),
                                        child: CenterText(
                                          controller.isBarReview.value
                                              ? AppStrings.T.barRate(controller.barName.value)
                                              : 'Was ${controller.drinkName.value} good? Share your feedback!',
                                          style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    Obx(
                                      () => KeyedSubtree(
                                        key: ValueKey('${controller.isBarReview.value}-${controller.stars.value}'),
                                        child: RatingBar.builder(
                                          initialRating: controller.stars.value,
                                          minRating: 1,
                                          maxRating: 5,
                                          allowHalfRating: true,
                                          unratedColor: context.colorScheme.primaryContainer,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                                          itemBuilder: (context, _) => ImageView(Assets.images.png.bigStar.path),
                                          onRatingUpdate: (rating) {
                                            controller.stars.value = rating;
                                          },
                                        ),
                                      ),
                                    ),
                                    const Gap(20),
                                    TextInputField(
                                      type: InputType.multiline,
                                      controller: controller.writeReviewController,
                                      hintLabel: AppStrings.T.writeReview,
                                      context: context,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      minLines: 4,
                                      maxLines: 4,
                                      validator: AppValidations.reviewValidation,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 60),
                                        child: ImageView(
                                          Assets.svg.documentText,
                                          color: context.colorScheme.onSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const AppEdgeInsets.h16(),
                        child: Column(
                          children: [
                            const Gap(25),
                            AppButton(
                              label: controller.isBarReview.value
                                  ? (controller.hasExistingReview.value ? 'Update Review' : AppStrings.T.submit)
                                  : (controller.hasExistingReview.value ? 'Update Review' : AppStrings.T.submit),
                              onPressed: () => controller.drinkReview(),
                            ),
                            const Gap(15),
                            GestureDetector(
                              onTap: () {
                                if (controller.isBarReview.value) {
                                  controller.writeReviewController.clear();
                                  Get.back(result: true);
                                } else {
                                  controller.isBarReview.value = true;
                                  controller.writeReviewController.clear();
                                }
                              },
                              child: AppText(AppStrings.T.skip,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: context.colorScheme.secondaryFixedDim,
                                    color: context.colorScheme.secondaryFixedDim,
                                  )),
                            ),
                            const Gap(15),
                          ],
                        ),
                      ),
                      const CustomSizedBox()
                    ],
                  ),
                ),
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
    if (Get.arguments != null) {
      controller.barName.value = '';
      controller.drinkName.value = '';
      controller.fromMarkerRedeemed = true;
      controller.isBarReview.value = false;
      final data = Get.arguments as RedeemedUpcomingListData;
      controller.drinkId = data.drinkId?.sId ?? '';
      controller.drinkName.value = data.drinkId?.name ?? '';
      controller.barId = data.barId?.sId ?? '';
      controller.barName.value = data.barId?.name ?? '';
      controller.transactionId = data.transactionId ?? '';
      controller.loadMyDrinkReview();
    }
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
