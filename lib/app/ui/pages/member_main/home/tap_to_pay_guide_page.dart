import 'package:gap/gap.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapToPayGuidePage extends StatefulWidget {
  const TapToPayGuidePage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.tapToPayGuidePage);
  }

  @override
  State<TapToPayGuidePage> createState() => _TapToPayGuidePageState();
}

class _TapToPayGuidePageState extends State<TapToPayGuidePage> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final guideItems = [
      (
        title: AppStrings.T.howToAcceptCards,
        description: AppStrings.T.howToAcceptCardsDesc,
        image: Assets.images.png.tapTpPayGuide1,
      ),
      (
        title: AppStrings.T.acceptApplePayAndWallets,
        description: AppStrings.T.acceptApplePayAndWalletsDesc,
        image: Assets.images.png.tapTpPayGuide2,
      ),
      (
        title: AppStrings.T.holdCardNearIPhone,
        description: AppStrings.T.holdCardNearIPhoneDesc,
        image: Assets.images.png.tapTpPayGuide3,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const AppEdgeInsets.all16(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCustomAppbar(appTitle: AppStrings.T.tapToPayGuide, isPadding: true),
            const Gap(10),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: guideItems.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  final item = guideItems[index];
                  return _GuideTile(
                    title: item.title,
                    image: item.image,
                    description: item.description,
                    isExpanded: _expandedIndex == index,
                    onTap: () {
                      setState(() {
                        _expandedIndex = _expandedIndex == index ? -1 : index;
                      });
                    },
                  );
                },
              ),
            ),
            const Gap(18),
            AppText(
              '${AppStrings.T.tapToPayOnIPhone}: Card • Apple Pay • Google Pay',
              style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryContainer),
            ),
            const Gap(16),
            AppButton(
              label: AppStrings.T.ok,
              onPressed: () {
                getIt<SharedPreferences>().setTapToPayEducationShown = true;
                Get.back(result: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideTile extends StatelessWidget {
  const _GuideTile({required this.title, required this.image, required this.description, required this.isExpanded, required this.onTap});

  final String title;
  final AssetGenImage image;
  final String description;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const AppEdgeInsets.all14(),
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: AppText(title, style: context.textTheme.bodyMedium)),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: context.colorScheme.secondaryContainer,
                ),
              ],
            ),
            if (isExpanded) ...[
              const Gap(10),
              AppText(
                description,
                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.secondaryContainer),
              ),
              const Gap(12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image.image(
                  width: double.infinity,
                  // height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
