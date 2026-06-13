import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/add_drink_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_drink_bar_profile_widget.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class AddDrinkPage extends GetItHook<AddDrinkController> {
  const AddDrinkPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.addDrinkPage);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        child: Scaffold(
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
                      appTitle: AppStrings.T.addDrink,
                      isPadding: true,
                    ),
                    const Gap(20),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const AddDrinkBarProfileWidget(),
                          const Gap(60),
                          AppButton(
                            label: AppStrings.T.add,
                            onPressed: () => controller.addBarDrink(),
                          ),
                        ],
                      ),
                    ),
                    const CustomSizedBox()
                  ],
                ),
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
    controller.drinkNameController = TextEditingController();
    controller.drinkPriceController = TextEditingController();
    controller.drinkDescriptionController = TextEditingController();
    controller.imageDrinkPath.value = '';
    controller.loadDrinkCategories();
  }

  @override
  void onDispose() {
    controller.disposeAll();
  }
}
