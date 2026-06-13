import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/home/review_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class ReviewPage extends GetItHook<ReviewController> {
  const ReviewPage({super.key});

  static Future<T?>? route<T>({String? barId}) {
    return Get.toNamed(AppRoutes.reviewPage, arguments: barId);
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
              children: [
                AppCustomAppbar(
                  appTitle: AppStrings.T.barReview,
                  isPadding: true,
                ),
                const Gap(20),
                Obx(
                  () => Expanded(
                    child: controller.isDataEmpty.value
                        ? EmptyScreen(title: AppStrings.T.drinkReviewSubtitle)
                        : ListView.builder(
                            controller: controller.scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: controller.reviewList.length + (controller.hasMoreData.value ? 1 : 0),
                            itemBuilder: (BuildContext context, int index) {
                              if (index > controller.reviewList.length - 1 && controller.hasMoreData.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              final review = controller.reviewList[index];

                              return Container(
                                margin: const AppEdgeInsets.oB15(),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: ImageView(
                                          review.userId?.profile ?? '',
                                          shape: BoxShape.circle,
                                          inner: ImageSize(height: 45, width: 45),
                                        ),
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: AppText(
                                          DateUtil.instance.dateDFormat(review.createdAt ?? ''),
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: context.colorScheme.secondaryFixedDim,
                                          ),
                                        ),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: AppText(
                                          review.userId?.name ?? '',
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ),
                                      subtitle: RatingBar.builder(
                                        initialRating: review.stars?.toDouble() ?? 1,
                                        itemSize: 20,
                                        ignoreGestures: true,
                                        unratedColor: context.colorScheme.primaryContainer,
                                        itemBuilder: (context, _) => ImageView(Assets.images.png.bigStar.path),
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const AppEdgeInsets.h16(),
                                      child: Divider(
                                        color: context.colorScheme.secondaryContainer.withAlpha(25),
                                        height: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const AppEdgeInsets.all16(),
                                      child: AppText(
                                        maxLines: 3,
                                        review.review ?? '',
                                        style: context.textTheme.bodySmall?.copyWith(
                                          color: context.colorScheme.secondaryFixedDim,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
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
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        controller.barId = Get.arguments as String;
        controller.updateInitEntry();
      }
    }
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
