import 'package:gap/gap.dart';
import 'package:marker/app/controllers/auth/owner/owner_register_profile_controller.dart';
import 'package:marker/app/ui/widgets/camera_gallery_dialog.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class AddDrinkWidget extends StatelessWidget {
  const AddDrinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OwnerRegisterProfileController>(
      init: getIt.get<OwnerRegisterProfileController>(),
      builder: (controller) {
        return FocusScope(
          child: Form(
            key: controller.formBarAddKey,
            child: Column(
              children: [
                TextInputField(
                  type: InputType.text,
                  controller: controller.drinkNameController,
                  hintLabel: AppStrings.T.enterDrinkName,
                  context: context,
                  validator: AppValidations.drinkValidation,
                  prefixIcon: ImageView(
                    Assets.svg.drinkGlass,
                    color: context.colorScheme.secondaryContainer,
                  ),
                ),
                const Gap(16),
                TextInputField(
                  type: InputType.decimalDigits,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: controller.drinkPriceController,
                  hintLabel: AppStrings.T.enterPrice,
                  context: context,
                  validator: AppValidations.priceValidation,
                  prefixIcon: ImageView(
                    Assets.svg.dollarCircle,
                    color: context.colorScheme.secondaryContainer,
                  ),
                ),
                const Gap(16),
                TextInputField(
                  type: InputType.multiline,
                  controller: controller.drinkDescriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 4,
                  maxLines: 4,
                  hintLabel: AppStrings.T.enterDescription,
                  context: context,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 55),
                    child: ImageView(
                      Assets.svg.documentText,
                      color: context.colorScheme.secondaryContainer,
                    ),
                  ),
                  validator: AppValidations.desDrinkValidation,
                ),
                const Gap(16),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      profilePictureBottomSheet(
                          title: AppStrings.T.uploadDrink,
                          subTitle: AppStrings.T.chooseBarDrink,
                          selectedPath: (String path) {
                            controller.imageDrinkPath.value = path;
                          });
                    },
                    child: Container(
                      width: Get.width,
                      height: 124,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.greyTextColor.withValues(alpha: 0.1)),
                      child: controller.imageDrinkPath.value.isNotEmpty
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                ImageView(
                                  controller.imageDrinkPath.value,
                                  borderRadius: BorderRadius.circular(12),
                                  inner: ImageSize(width: Get.width, height: 124),
                                ),
                                Container(
                                  width: Get.width,
                                  height: 124,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: context.colorScheme.onSecondary.withValues(alpha: 0.5),
                                  ),
                                ),
                                ImageView(
                                  Assets.svg.edit,
                                  color: context.colorScheme.onPrimary,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImageView(
                                  Assets.svg.export,
                                  color: context.colorScheme.secondaryContainer,
                                  inner: ImageSize(width: 25, height: 25),
                                ),
                                const Gap(15),
                                CenterText(
                                  AppStrings.T.uploadPhoto,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.theme.colorScheme.secondaryFixedDim,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const Gap(16),
              ],
            ),
          ),
        );
      },
    );
  }
}
