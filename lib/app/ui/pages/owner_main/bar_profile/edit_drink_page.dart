import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/owner_main/bar_profile/add_drink_controller.dart';
import 'package:marker/app/data/models/bar_drink_details_model/bar_drink_details_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/owner_main/bar_profile/add_drink_bar_profile_widget.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class EditDrinkPage extends GetItHook<AddDrinkController> {
  const EditDrinkPage({super.key});

  static Future<T?>? route<T>({required DrinkDetailsData drinkDetailsData, required String drinkId}) {
    return Get.toNamed(AppRoutes.editDrinkPage, arguments: [drinkDetailsData, drinkId]);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        child: Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                children: [
                  AppCustomAppbar(
                    appTitle: AppStrings.T.editDrink,
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
                          label: AppStrings.T.save,
                          onPressed: () => controller.editDrink(),
                        ),
                      ],
                    ),
                  ),
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
    if (Get.arguments != null) {
      if (Get.arguments[0] is DrinkDetailsData) {
        final data = Get.arguments[0] as DrinkDetailsData;
        controller.drinkNameController = TextEditingController(text: data.name ?? '');
        controller.drinkPriceController = TextEditingController(text: '${data.price ?? ''}');
        controller.drinkDescriptionController = TextEditingController(text: data.description ?? '');
        controller.imageDrinkPath.value = data.image ?? '';
        controller.applyCategoryFromDrink(data);
      }
      if (Get.arguments[1] is String) {
        controller.drinksId.value = Get.arguments[1] as String;
      }
    }
    controller.loadDrinkCategories().then((_) {
      if (Get.arguments != null && Get.arguments[0] is DrinkDetailsData) {
        controller.applyCategoryFromDrink(Get.arguments[0] as DrinkDetailsData);
      }
    });
  }

  @override
  void onDispose() {
    controller.drinkNameController.dispose();
    controller.drinkPriceController.dispose();
    controller.drinkDescriptionController.dispose();
    controller.imageDrinkPath.value = '';
  }
}
