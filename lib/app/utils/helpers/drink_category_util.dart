import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';
import 'package:marker/app/data/services/bar_owner_service/bar_owner_service.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

Future<List<DrinkCategoryData>> fetchDrinkCategoriesFromApi() async {
  final response = await getIt<BarOwnerService>().drinkCategoriesList();
  final data = response['data'] as List<dynamic>? ?? [];
  return data
      .map((e) => DrinkCategoryData.fromJson(e as Map<String, dynamic>))
      .toList();
}

String? drinkCategoryIdForFilter({
  String? categoryId,
  DrinkCategoryData? category,
}) =>
    category?.sId ?? categoryId;
