import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/utils/constants/app_strings.dart';

class AppValidations {
  AppValidations._();

  static const String currencyCode = 'USD';
  static const String currencySymbol = '\$';

  static String getFormattedPrice(dynamic amount) {
    double price = 0;

    if (amount is int) {
      price = amount.toDouble();
    } else if (amount is double) {
      price = amount;
    } else if (amount is String) {
      price = double.tryParse(amount) ?? 0;
    }

    // FIX: round to 2 decimals safely
    price = (price * 100).round() / 100;

    if (price % 1 == 0) {
      return '$currencySymbol${price.toInt()}';
    }
    return '$currencySymbol${price.toStringAsFixed(2)}';
  }

  static String? verificationCodeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.emptyVerificationCode;
    }
    return null;
  }

  static String? phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyPhoneNumber;
    return null;
  }

  static String? otpValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyOTP;
    return null;
  }

  static String? otpLengthValidation(String? value) {
    if (value != null && value.isNotEmpty && value.length != 4) return AppStrings.T.emptyOTP;
    return null;
  }

  static String? nameValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyName;
    return null;
  }

  static String? reviewValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.reviewEnter;
    return null;
  }

  static String? pincodeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.pleaseEnterPin;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return AppStrings.T.enter6Digit;
    }
    return null;
  }

  static String? lastNameValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyLastName;
    return null;
  }

  static String? firstNameValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyFirstName;
    return null;
  }

  static String? dobValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyDob;
    return null;
  }

  static String? identifyValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyIdentifyNumber;
    return null;
  }

  static String? postalValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyPostalCode;
    return null;
  }

  static String? externalAccountValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyExternalAccount;
    return null;
  }

  static String? currencyAccountValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyCurrencyAccount;
    return null;
  }

  static String? bankAccountNumberValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyBankAccountNumber;
    return null;
  }

  static String? routingValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.emptyRoutingNumber;
    } else if (value.length != 9) {
      return AppStrings.T.routingNumberMust9;
    }
    return null;
  }

  static String? messageValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseContact;
    return null;
  }

  static String? subjectValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseSubject;
    return null;
  }

  static String? countryValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyCountry;
    return null;
  }

  static String? cityValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleasEnterCity;
    return null;
  }

  static String? cityBankValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleasEnterCityBank;
    return null;
  }

  static String? stateBankValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleasEnterStateBank;
    return null;
  }

  static String? stateValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleasEnterState;
    return null;
  }

  static String? openingHourValidation(String? toValue, String? formValue, String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleasSelectOpening;
    if (formValue == null || formValue.isEmpty) return AppStrings.T.openBarTime;
    if (toValue == null || toValue.isEmpty) return AppStrings.T.closeBarTime;
    return null;
  }

  static String? barNameValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.barName;
    return null;
  }

  static String? drinkValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseDrink;
    return null;
  }

  static String? priceValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleasePrice;
    return null;
  }

  static String? desDrinkValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseDes;
    return null;
  }

  static String? latLogValidation(LatLng? value) {
    if (value == null) return AppStrings.T.barName;
    return null;
  }

  static String? genderValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyGender;
    return null;
  }

  static String? addressValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyAddress;
    return null;
  }

  static String? amountValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyAmount;
    return null;
  }

  static String? tipAmountValidation(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.T.emptyAmount;
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) return AppStrings.T.invalidAmount;
    return null;
  }

  static String imageValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.pleaseSelectImage;
    return '';
  }

  static String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyPassword;
    final passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#@$!%*?&])[A-Za-z\d@#$!%*?&]{8,}$',
    );

    if (!passwordRegExp.hasMatch(value)) {
      return AppStrings.T.emptyPassOrLength;
    }

    return null;
  }

  static String? confirmPasswordValidation(String? value, String otherPasswordValue) {
    if (value == null || value.isEmpty) {
      return AppStrings.T.emptyConfirmPassword;
    }
    if (otherPasswordValue.isEmpty) return null;
    if (otherPasswordValue != value) return AppStrings.T.passwordMismatch;
    return null;
  }

  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) return AppStrings.T.emptyEmail;
    if (!value.isEmail) return AppStrings.T.invalidEmail;
    return null;
  }

  static String? descriptionValidation(String? value) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    return null;
  }
}
