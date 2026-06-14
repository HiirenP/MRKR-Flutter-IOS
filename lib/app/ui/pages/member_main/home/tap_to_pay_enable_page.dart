import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:gap/gap.dart';
import 'package:marker/app/global/app_config.dart';
import 'package:marker/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart';
import 'package:marker/app/ui/pages/member_main/profile/privacy_policy_page.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_checkbox.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapToPayEnablePage extends StatefulWidget {
  const TapToPayEnablePage({super.key});

  static Future<T?> route<T>() {
    return Get.bottomSheet<T>(
      const TapToPayEnablePage(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20),
          topEnd: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  State<TapToPayEnablePage> createState() => _TapToPayEnablePageState();
}

class _TapToPayEnablePageState extends State<TapToPayEnablePage> {
  final RxBool _isChecked = false.obs;

  Future<void> _enableNow() async {
    final prefs = getIt<SharedPreferences>();
    final nextValue = !prefs.getTapToPayEnabled;
    try {
      final res = await getIt<AuthService>().setTapToPayEnabled(nextValue);
      if (res.isSuccess && res.statusCode == 200) {
        prefs.setTapToPayEnabled = nextValue;
        if (nextValue) {
          prefs.setTapToPayAwarenessShown = true;
        } else {
          prefs.setTapToPayAwarenessShown = false;
        }
        if (res.data != null) {
          getIt<SharedPreferences>().setUserData = res.data;
        }
        Get.back(result: true);
      } else {
        showError(res.message ?? 'Could not update Tap to Pay setting.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        showError('Tap to Pay setting could not be saved. Please update the app server and try again.');
      } else {
        showError(e.response?.data?['message']?.toString() ?? 'Could not update Tap to Pay setting.');
      }
    } catch (e) {
      showError('Could not update Tap to Pay setting.');
    }
  }

  Future<void> _learnMore() async {
    await TapToPayGuidePage.route();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.8,
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const AppEdgeInsets.all16(),
        child: Column(
          children: [
            const Gap(6),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const Gap(28),
            CenterText(
              AppStrings.T.acceptContactlessPaymentsWithOnlyIPhone,
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Gap(16),
            CenterText(
              AppStrings.T.tapToPayIphoneNowAvailable,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.secondaryContainer),
            ),
            const Gap(24),
            Expanded(
              child: Center(
                child: Assets.images.png.tapToPayImage.image(fit: BoxFit.fill),
              ),
            ),
            const Gap(24),
            if (!getIt<SharedPreferences>().getTapToPayEnabled)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => CustomCheckbox(
                      value: _isChecked.value,
                      color: context.colorScheme.secondaryContainer.withValues(alpha: 0.35),
                      onTap: () {
                        _isChecked.value = !_isChecked.value;
                      },
                    ),
                  ),
                  const Gap(5),
                  Expanded(
                    child: AppRichText(
                      textAlign: TextAlign.start,
                      spans: [
                        AppSpan(
                          text: AppStrings.T.iAgreeTo,
                          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.secondaryFixedDim, fontWeight: FontWeight.normal),
                        ),
                        AppSpan(
                          text: '${AppStrings.T.tapToPayOnIPhone} ${AppStrings.T.termsConditions}',
                          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.normal),
                          recognizer:  TapGestureRecognizer()
                            ..onTap = () {
                              PrivacyPolicyPage.route(AppStrings.T.termsConditions, url: AppConfig.tapToPayTerms);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            if (!getIt<SharedPreferences>().getTapToPayEnabled) const Gap(5),
            if (getIt<SharedPreferences>().getTapToPayEnabled)
              AppButton(
                label: AppStrings.T.disableNow,
                onPressed: _enableNow,
              )
            else
              Obx(
                () => Opacity(
                  opacity: _isChecked.value ? 1 : 0.5,
                  child: AbsorbPointer(
                    absorbing: !_isChecked.value,
                    child: AppButton(
                      label: AppStrings.T.enableNow,
                      onPressed: _enableNow,
                    ),
                  ),
                ),
              ),
            const Gap(12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _learnMore,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppText(
                  AppStrings.T.learnMore,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
