import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';
import 'package:marker/app/data/models/search_drinks_model/search_drinks_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/ui/widgets/app_text_style.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/ui/widgets/drink_category_dropdown.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/debouncer.dart';
import 'package:marker/app/utils/core/country_picker_util.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/helpers/validations/validations.dart';
import 'package:marker/gen/assets.gen.dart';

@i.lazySingleton
@i.injectable
class SearchDrinkController extends GetxController {
  SearchDrinkController() {
    onInit();
  }

  List<String> rate = <String>[].obs;
  RxString searchValue = ''.obs;
  RxInt selectedIndex = (-1).obs;
  RxDouble rangeValue = 0.0.obs;
  RxInt minPrice = 0.obs;
  RxInt maxPrice = 0.obs;
  bool isOnce = false;
  int totalRecord = 0;
  final searchState = ApiState.initial().obs;
  Debouncer debouncer = Debouncer(milliseconds: 700);
  TextEditingController searchController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  RxList<SearchDrinksList> searchDrinkData = <SearchDrinksList>[].obs;
  final ScrollController scrollController = ScrollController();
  int page = 1;
  RxBool hasMoreData = false.obs;
  RxBool isDataEmpty = false.obs;
  RxBool isEndPage = false.obs;
  bool isApply = false;
  bool isOnceS = false;
  RxList<DrinkCategoryData> drinkCategories = <DrinkCategoryData>[].obs;
  RxString selectedCategoryId = ''.obs;

  Future<void> loadDrinkCategories() async {
    try {
      final response = await getIt<BarOwnerService>().drinkCategoriesList();
      final data = response['data'] as List<dynamic>? ?? [];
      drinkCategories.value = data
          .map((e) => DrinkCategoryData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('loadDrinkCategories error: $e');
    }
  }

  void allDrinkList() {
    rate = [];
    rate.addAll(['5', '4', '3', '2', '1']);
  }

  Future<void> searchData() async {
    hasMoreData.value = false;
    searchState.value = LoadingState();
    searchDrinkData.isEmpty;
    if (page == 1) {
      isEndPage.value = false;
    } else {
      hasMoreData.value = true;
    }

    final requestData = <String, dynamic>{
      'query': searchController.text.trim(),
      'country': countryController.text.trim(),
      'state': stateController.text.trim(),
      'city': cityController.text.trim(),
      'limit': 10,
      'page': page,
    };
    if (selectedIndex.value != -1 && isApply) {
      requestData.putIfAbsent(
        'rating',
        () => rate[selectedIndex.value],
      );
    }
    if (maxPrice.value != 0 && isApply) {
      requestData.putIfAbsent(
        'priceMax',
        () => maxPrice.value,
      );
    }
    if (minPrice.value != 0 && isApply) {
      requestData.putIfAbsent(
        'priceMin',
        () => minPrice.value,
      );
    }
    if (selectedCategoryId.value.isNotEmpty && isApply) {
      requestData['categoryId'] = selectedCategoryId.value;
    }

    await getIt<MemberService>().searchDrinksList(requestData).handler(
      searchState,
      isLoading: page == 1,
      onSuccess: (value) {
        isOnceS = false;
        if (value.statusCode == 200 && value.data != null) {
          final newItems = value.data?.data ?? [];
          if (newItems.isEmpty && page == 1) {
            isDataEmpty.value = true;
          }
          if (page != 1) {
            hasMoreData.value = false;
            searchDrinkData.addAll(newItems);
          } else {
            searchDrinkData.value = newItems;
          }
          final totalRecord = value.data?.totalRecord ?? 0;
          page++;
          if (totalRecord == searchDrinkData.length) {
            isEndPage.value = true;
          }
          final prices = searchDrinkData.map((drink) => drink.price).whereType<int>().toList();
          if (prices.isNotEmpty && !isOnce) {
            isOnce = true;
            minPrice.value = prices.reduce((a, b) => a < b ? a : b);
            maxPrice.value = prices.reduce((a, b) => a > b ? a : b);
            maxPrice += 20;
            rangeValue.value = minPrice.value.toDouble();
          }
        }
      },
      onFailed: (value) {
        isOnceS = false;
        showError(value.error.description);
      },
    );
  }

  Future<void> setSearchValue(String value) async {
    page = 1;
    isEndPage.value = false;
    hasMoreData.value = false;
    debouncer.run(searchData);
  }

  void updateInitEntry() {
    isEndPage.value = false;
    searchDrinkData.value = [];
    page = 1;
    searchData();
    debouncer = Debouncer(milliseconds: 700);
    scrollController.addListener(() async {
      if (!isOnceS && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isEndPage.value) {
          return;
        }
        isOnceS = true;
        await searchData();
      }
    });
  }

  Future<dynamic> filterBottomSheet() async {
    final context = Get.context!;
    return Get.bottomSheet(
      AppBottomSheet(
        title: AppStrings.T.filter,
        isClose: true,
        isDivider: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => drinkCategories.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('Category', style: context.textTheme.bodyLarge),
                        const Gap(10),
                        DrinkCategoryDropdown(
                          categories: drinkCategories,
                          selectedId: selectedCategoryId.value,
                          includeAllOption: true,
                          allOptionLabel: 'All categories',
                          onChanged: (value) => selectedCategoryId.value = value,
                        ),
                        const Gap(20),
                      ],
                    ),
            ),
            AppText(AppStrings.T.rating, style: context.textTheme.bodyLarge),
            const Gap(10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: rate.length,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      selectedIndex.value = index;
                    },
                    child: Obx(
                      () => Container(
                        height: 60,
                        margin: const AppEdgeInsets.oL8(),
                        padding: const AppEdgeInsets.h16(),
                        decoration: BoxDecoration(
                          color: context.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: selectedIndex.value == index ? context.colorScheme.primary : context.colorScheme.secondary,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            ImageView(Assets.svg.sStar),
                            const Gap(15),
                            AppText(
                              rate[index],
                              style: context.textTheme.bodySmall?.copyWith(
                                  color: selectedIndex.value == index ? context.colorScheme.onSecondary : context.colorScheme.secondaryFixedDim),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(20),
            AppText(AppStrings.T.price, style: context.textTheme.bodyLarge),
            const Gap(20),
            Obx(
              () => SliderTheme(
                data: SliderThemeData(
                  activeTickMarkColor: Colors.yellow,
                  overlappingShapeStrokeColor: Colors.green,
                  valueIndicatorColor: context.colorScheme.onPrimary,
                  overlayColor: context.colorScheme.onPrimary,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
                  valueIndicatorTextStyle: AppTextStyle(fontSize: 16, color: context.colorScheme.primary, fontWeight: FontWeight.w500),
                ),
                child: Slider(
                  onChanged: (value) {
                    rangeValue.value = value;
                  },
                  min: minPrice.toDouble(),
                  max: maxPrice.toDouble(),
                  value: rangeValue.value,
                  label: AppValidations.getFormattedPrice(rangeValue.value.toStringAsFixed(0)),
                  divisions: 15,
                ),
              ),
            ),
            Padding(
              padding: const AppEdgeInsets.h16(),
              child: Obx(
                () => Row(
                  children: [
                    AppText(AppValidations.getFormattedPrice(minPrice.value), style: context.textTheme.bodyMedium),
                    const Spacer(),
                    AppText(AppValidations.getFormattedPrice(maxPrice.value), style: context.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const Gap(15),
            TextInputField(
              type: InputType.text,
              controller: cityController,
              hintLabel: AppStrings.T.enterCity,
              context: context,
              prefixIcon: ImageView(Assets.svg.buliding),
            ),
            const Gap(15),
            TextInputField(
                type: InputType.text,
                controller: stateController,
                hintLabel: AppStrings.T.enterState,
                context: context,
                prefixIcon: ImageView(Assets.svg.routing)),
            const Gap(15),
            TextInputField(
              type: InputType.text,
              controller: countryController,
              hintLabel: AppStrings.T.chooseCountry,
              context: context,
              prefixIcon: ImageView(
                Assets.svg.global,
                color: context.colorScheme.secondaryFixedDim,
              ),
              suffixIcon: ImageView(
                Assets.svg.arrowDown,
                color: context.colorScheme.secondaryFixedDim,
              ),
              readOnly: true,
              onTap: () => CountryPickerUtil().countryPick(
                context: context,
                selectedItem: (p0) {
                  countryController.text = p0.name;
                },
              ),
            ),
            const Gap(15),
          ],
        ),
        positiveButtonTitle: AppStrings.T.apply,
        negativeButtonTitle: AppStrings.T.reset,
        onPositivePressed: () {
          page = 1;
          isApply = true;
          searchData();
          Get.back();
        },
        onNegativePressed: () {
          disposeAll();
          searchData();
          Future.delayed(const Duration(seconds: 2));
          Get.back();
        },
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  void resetData() {
    cityController.clear();
    countryController.clear();
    stateController.clear();
    searchValue = ''.obs;
    selectedIndex.value = -1;
    rangeValue = 0.0.obs;
    minPrice = 0.obs;
    maxPrice = 0.obs;
    isOnce = false;
    hasMoreData.value = false;
    searchDrinkData.value = [];
  }

  void disposeAll() {
    cityController.text = '';
    countryController.text = '';
    stateController.text = '';
    searchValue.value = '';
    selectedIndex.value = -1;
    selectedCategoryId.value = '';
    rangeValue.value = 0.0;
    minPrice.value = 0;
    maxPrice.value = 0;
    isOnce = false;
    hasMoreData = false.obs;
    isDataEmpty = false.obs;
    isEndPage = false.obs;
    totalRecord = 0;
    searchDrinkData.value = [];
  }
}
