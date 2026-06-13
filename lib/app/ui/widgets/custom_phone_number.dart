import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/gen/assets.gen.dart';

class CustomPhoneNumber<T> extends StatelessWidget {
  const CustomPhoneNumber({
    super.key,
    this.controller,
    this.onChanged,
    this.initialSelection = 'US',
    this.showFlag = true,
    this.showDropDownButton = true,
    this.showCountryOnly = false,
    this.hideMainText = true,
    this.isHideIOS = false,
    this.readOnly = false,
    this.validator, // Add the validator parameter here
  });

  final TextEditingController? controller;
  final ValueChanged<Country>? onChanged;
  final String initialSelection;
  final bool showFlag;
  final bool isHideIOS;
  final bool showDropDownButton;
  final bool showCountryOnly;
  final bool hideMainText;
  final bool readOnly;
  final FormFieldValidator<String>? validator; // Use the type parameter T

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      type: InputType.digits,
      controller: controller,
      hintLabel: AppStrings.T.enterMobileNumber,
      context: context,
      maxLength: 15,
      isCountryPicker: true.obs,
      validator: validator,
      readOnly: readOnly,
      // Pass the validator to the TextInputField
      prefixIcon: CountryCodePicker(
              onChanged: onChanged,
              initialSelection: initialSelection,
              showFlag: showFlag,
              showDropDownButton: showDropDownButton,
              showCountryOnly: showCountryOnly,
              hideMainText: hideMainText,
              insetPadding: const AppEdgeInsets.all16(),
              dialogTextStyle: context.textTheme.bodySmall,
              builder: (Country? country) {
                debugPrint('--------$initialSelection-->${country!.flagUri}');
                return SizedBox(
                  width: 60,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        country.flagUri,
                        package: 'country_code_picker_plus',
                        width: 26,
                        height: 18,
                      ),
                      const Gap(10),
                      ImageView(Assets.svg.dropDown)
                    ],
                  ),
                );
              },
            ),
    );
  }
}
