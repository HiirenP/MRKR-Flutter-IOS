import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';

class _SuffixIcon extends StatelessWidget {
  const _SuffixIcon({
    required this.showing,
  });

  final RxBool showing;

  @override
  Widget build(BuildContext context) {
    /// If you have to change the suffixIcon widget so you must have to be change your icon here.
    return ExcludeFocus(
      child: GestureDetector(
        onTap: showing.toggle,
        child: (showing.value
            ? ImageView(
                Assets.svg.eye,
                color: context.colorScheme.secondaryContainer,
              )
            : ImageView(
                Assets.svg.eyeSlash,
                color: context.colorScheme.secondaryContainer,
              )),
      ),
    );
  }
}

class TextInputField extends TextFormField {
  TextInputField({
    super.key,
    required BuildContext context,
    required InputType type,
    required String hintLabel,
    required super.controller,
    super.textInputAction = TextInputAction.next,
    super.maxLines,
    super.minLines,
    super.autovalidateMode = AutovalidateMode.onUnfocus,
    super.validator,
    super.enabled,
    super.readOnly,
    super.expands,
    super.onTap,
    super.onChanged,
    RxBool? obscureText,
    RxBool? isCountryPicker,
    RxDouble? circularValue,
    RxDouble? isSend,
    super.obscuringCharacter,
    TextInputType? keyboardType,
    Iterable<String>? autoFillHints,
    Widget? suffixIcon,
    Widget? prefixIcon,
    Color? fillColor,
    TextStyle? labelStyle,
    super.maxLength,
    int? errorMaxLines,
    List<TextInputFormatter>? inputFormatters,
    super.focusNode,
  })  : assert(type != InputType.multiline || textInputAction == TextInputAction.newline,
            'Make textInputAction = TextInputAction.newline'),
        assert(
          (type != InputType.password && type != InputType.newPassword && type != InputType.confirmPassword) ||
              obscureText != null,
          'Make sure you are providing obscureText and wrapping Obx on TextInputField',
        ),
        super(
          keyboardType: keyboardType ??
              switch (type) {
                InputType.name => TextInputType.name,
                InputType.text => TextInputType.text,
                InputType.email => TextInputType.emailAddress,
                InputType.password => TextInputType.visiblePassword,
                InputType.confirmPassword => TextInputType.visiblePassword,
                InputType.newPassword => TextInputType.visiblePassword,
                InputType.phoneNumber => TextInputType.phone,
                InputType.digits => TextInputType.number,
                InputType.decimalDigits => const TextInputType.numberWithOptions(decimal: true),
                InputType.multiline => TextInputType.multiline,
              },
          autofillHints: [
            if (autoFillHints != null) ...autoFillHints,
            switch (type) {
              InputType.name => AutofillHints.name,
              InputType.email => AutofillHints.email,
              InputType.password => AutofillHints.password,
              InputType.confirmPassword => AutofillHints.password,
              InputType.newPassword => AutofillHints.newPassword,
              InputType.phoneNumber => AutofillHints.telephoneNumber,
              _ => '',
            },
          ],
          inputFormatters: [
            if (inputFormatters != null) ...inputFormatters,
            if (type == InputType.digits) FilteringTextInputFormatter.digitsOnly,
            if (type == InputType.decimalDigits) FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          obscureText: obscureText?.value ?? false,
          style: labelStyle ?? context.textTheme.labelMedium,
          decoration: InputDecoration(
            hintText: hintLabel,
            counterText: '',
            errorMaxLines: errorMaxLines,
            hintStyle: context.textTheme.labelMedium?.copyWith(color: AppColors.greyTextColor),
            // Apply label style from the theme
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(circularValue?.value ?? 12), // Circular shape
              borderSide: BorderSide.none, // Optional: removes the border
            ),
            fillColor: fillColor ?? context.colorScheme.secondary,
            filled: true,
            prefixIcon: prefixIcon == null
                ? const SizedBox()
                : Padding(
                    padding: isCountryPicker == true.obs
                        ? const EdgeInsets.only(left: 14, top: 17, bottom: 17)
                        : const AppEdgeInsets.all14(),
                    child: prefixIcon,
                  ),
            contentPadding: prefixIcon == null ? const EdgeInsets.all(10) : const AppEdgeInsets.v10(),
            suffixIconConstraints: const BoxConstraints(minHeight: 50, minWidth: 50),
            prefixIconConstraints: prefixIcon == null
                ? const BoxConstraints(minHeight: 10, minWidth: 10)
                : const BoxConstraints(minHeight: 50, minWidth: 50),
            suffixIcon: Padding(
              padding: EdgeInsets.all(isSend?.value ?? 12.0),
              child: suffixIcon ??
                  (obscureText == null
                      ? null
                      : Builder(
                          builder: (context) {
                            if (type == InputType.email || type == InputType.password) {
                              return _SuffixIcon(
                                showing: obscureText,
                              );
                            }
                            return Container(); // Handle the default case or other input types
                          },
                        )),
            ),
          ),
        );
}

enum InputType {
  name,
  text,
  email,
  password,
  confirmPassword,
  newPassword,
  phoneNumber,
  digits,
  decimalDigits,
  multiline,
}
