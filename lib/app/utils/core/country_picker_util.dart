import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';

class CountryPickerUtil {
  void countryPick(
      {required BuildContext context, ValueChanged<Country>? selectedItem}) {
    showCountryPicker(
      context: context,
      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
      exclude: <String>['KN', 'MF'],
      favorite: <String>['US'],
      onSelect: (Country country) {
        if (selectedItem != null) selectedItem(country);
      },
      // Optional. Sets the theme for the country list picker.
      countryListTheme: CountryListThemeData(
        // Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        // Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          labelStyle: context.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colorScheme.secondaryFixedDim),
          // hintText: 'Start typing to search',
          prefixIcon: Icon(
            Icons.search,
            color: context.theme.colorScheme.secondaryFixedDim,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colorScheme.secondary
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: context.colorScheme.secondary
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: context.colorScheme.secondary
            ),
          ),
        ),
        // Optional. Styles the text in the search field
        searchTextStyle: context.textTheme.bodyMedium,
      ),
    );
  }
}
