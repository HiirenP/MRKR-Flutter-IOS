import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/controllers/member_main/home/drink_review_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class BarReviewSubmitPage extends GetItHook<DrinkReviewController> {
  const BarReviewSubmitPage({super.key});

  static Future<T?>? route<T>({required String barId, required String barName}) {
    return Get.toNamed(AppRoutes.barReviewSubmitPage, arguments: {'barId': barId, 'barName': barName});
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
            child: Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                children: [
                  const AppCustomAppbar(),
                  const Gap(20),
                  CenterText(
                    AppStrings.T.barReview,
                    style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Gap(12),
                  Obx(
                    () => CenterText(
                      AppStrings.T.barRate(controller.barName.value),
                      style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Gap(10),
                  Obx(
                    () => controller.isLoadingReview.value
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          )
                        : KeyedSubtree(
                            key: ValueKey(controller.stars.value),
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
                  const Spacer(),
                  Obx(
                    () => AppButton(
                      label: controller.hasExistingReview.value ? 'Update Review' : AppStrings.T.submit,
                      onPressed: () async {
                        controller.isBarReview.value = true;
                        await controller.drinkReview();
                      },
                    ),
                  ),
                  const CustomSizedBox(),
                ],
              ),
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
    controller.isBarReview.value = true;
    controller.transactionId = '';
    String? existingReviewId;
    String? existingReviewText;
    num? existingReviewStars;
    if (Get.arguments is Map) {
      final args = Get.arguments as Map;
      controller.barId = (args['barId'] ?? '') as String;
      controller.barName.value = (args['barName'] ?? '') as String;
      existingReviewId = args['reviewId']?.toString();
      existingReviewText = args['review']?.toString();
      existingReviewStars = args['reviewStars'] as num?;
    }
    controller.loadMyBarReview(
      reviewId: existingReviewId,
      review: existingReviewText,
      reviewStars: existingReviewStars,
    );
  }

  @override
  void onDispose() {
    controller.clearFormOnly();
  }
}

