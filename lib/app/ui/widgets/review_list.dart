
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key, required this.reviews});

  final List<LatestReviews> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppStrings.T.review,
          style: context.textTheme.bodyMedium,
        ),
        const Gap(15),
        ListView.builder(
          itemCount: reviews.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final review = reviews[index];
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
      ],
    );
  }
}
