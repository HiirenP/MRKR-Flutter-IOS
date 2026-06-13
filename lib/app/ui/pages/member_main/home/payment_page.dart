import 'dart:io';

import 'package:gap/gap.dart';
import 'package:marker/app/controllers/member_main/home/payments_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';

class PaymentPage extends GetItHook<PaymentsController> {
  const PaymentPage({super.key});

  static Future<T?>? route<T>({Map<String, dynamic>? tip}) {
    return Get.offNamed(AppRoutes.paymentPage, arguments: tip);
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
                appTitle: AppStrings.T.payment,
                isPadding: true,
              ),
              const Gap(25),
              GestureDetector(
                onTap: () => controller.infoSheet(context: context),
                child: Container(
                  padding: const AppEdgeInsets.v10(),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: context.colorScheme.secondary),
                  child: ListTile(
                    leading: CircularContainer(
                      imagePath: Assets.svg.cardPos,
                      bgColor: context.colorScheme.onPrimary,
                    ),
                    trailing: ImageView(Assets.svg.arrowRight),
                    title: AppText(
                      AppStrings.T.card,
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              const Gap(25),
              GestureDetector(
                onTap: () => controller.infoSheet(context: context, nfcPayment: true),
                child: Container(
                  padding: const AppEdgeInsets.v10(),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: context.colorScheme.secondary),
                  child: ListTile(
                    leading: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                        child: ImageView(
                          Assets.svg.contactless,
                          color: context.colorScheme.primary,
                        )),
                    trailing: ImageView(Assets.svg.arrowRight),
                    title: AppText(
                      (Platform.isIOS) ? AppStrings.T.tapToPayOnIPhone : AppStrings.T.tapToPayOnAndroid,
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              /*
              * Removed because of backend developer confirm with PM
              * */
              /*const Gap(20),
              Container(
                padding: const AppEdgeInsets.v10(),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: context.colorScheme.secondary),
                child: ListTile(
                  leading: CircularContainer(
                    imagePath: Assets.svg.paypal,
                    bgColor: context.colorScheme.onPrimary,
                  ),
                  trailing: ImageView(Assets.svg.arrowRight),
                  title: AppText(
                    AppStrings.T.payPal,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.paymentInit();
  }

  @override
  void onDispose() {
    controller.paymentDismiss();
  }
}
