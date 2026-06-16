import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/bar_drink_model/bar_drink_model.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/drink_category_model/drink_category_model.dart';
import 'package:marker/app/data/services/member_service/member_service.dart';
import 'package:marker/app/utils/helpers/drink_category_util.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/constants/date_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/model/common_model.dart';

@i.lazySingleton
@i.injectable
class NearByDetailsController extends GetxController with GetTickerProviderStateMixin {
  NearByDetailsController() {
    onInit();
  }

  final barDetailsState = ApiState.initial().obs;
  bool isSelectedTab = false;
  late TabController tabController;
  late GoogleMapController googleMapController;
  final pageController = PageController();
  RxList<Marker> markers = <Marker>[].obs;
  Rx<LatLng> origin = Rx<LatLng>(const LatLng(0, 0));
  List<CommonModel> aboutList = <CommonModel>[];
  RxBool selectedTab = false.obs;
  RxBool isSuccess = false.obs;
  String? barName;
  String? oName;
  String? oProfile;

  String openClose = AppStrings.T.closed;
  String? barProfile;
  String? logo;
  String? averageRating;
  String? totalReviews;
  bool isFriend = false;
  RxBool hasMyBarReview = false.obs;

  Rx<BarGetUpdateData> barDetails = BarGetUpdateData().obs;
  RxList<BarDrinkData> drinkList = <BarDrinkData>[].obs;
  RxList<DrinkCategoryData> drinkCategories = <DrinkCategoryData>[].obs;
  RxString selectedCategoryId = ''.obs;
  List<BarDrinkData> _allDrinks = [];

  void tabBarViewInit() {
    tabController = TabController(vsync: this, length: 2);
  }

  void addAboutListData() {
    aboutList = [];
    final data = barDetails.value;
    final time = '${utcToLocalTime(data.openingHours?.open ?? '')} - ${utcToLocalTime(data.openingHours?.close ?? '')}';
    aboutList.addAll([
      CommonModel(icon: Assets.svg.callCalling, title: AppStrings.T.mobileNumber, subTitle: data.mobile),
      CommonModel(icon: Assets.svg.email, title: AppStrings.T.email, subTitle: data.email),
      CommonModel(icon: Assets.svg.clock, title: AppStrings.T.openingHours, subTitle: time),
      CommonModel(icon: Assets.svg.location, title: AppStrings.T.address, subTitle: data.address),
    ]);
    origin.value = LatLng(data.location?.coordinates?[1] ?? 0, data.location?.coordinates?[0] ?? 0);
    barName = data.name?.capitalize ?? '';
    oName = data.ownerId?.name?.capitalize ?? '';
    oProfile = data.ownerId?.profile ?? '';
    logo = data.logo ?? '';
    averageRating = data.averageRating?.toStringAsFixed(1);
    totalReviews = '${data.totalReviews ?? 0}';
    final isOpen = isBarOpenOrClose(
        openTime: data.openingHours?.open ?? '',
        closeTime: data.openingHours?.close ?? '',
        isOpenToday: data.isOpenToday ?? false);
    if (isOpen) {
      openClose = AppStrings.T.openNow;
    } else {
      openClose = AppStrings.T.closed;
    }
    addMarkerAndPolyline();
  }

  Future<void> addMarkerAndPolyline() async {
    final customIcon = await AssetMapBitmap.create(
      const ImageConfiguration(size: Size(48, 48)), // Specify the size of the icon
      Assets.images.png.mapIcon.path, // Path to your asset
    );

    debugPrint('origin========>$origin');
    markers.add(Marker(
      markerId: const MarkerId('origin'),
      position: origin.value,
      infoWindow: const InfoWindow(title: 'Origin'),
      icon: customIcon, // Set the custom icon
    ));
  }

  Future<void> loadDrinkCategories() async {
    try {
      drinkCategories.value = await fetchDrinkCategoriesFromApi();
    } catch (e) {
      debugPrint('loadDrinkCategories error: $e');
    }
  }

  void applyDrinkCategoryFilter() {
    final selectedId = selectedCategoryId.value;
    if (selectedId.isEmpty) {
      drinkList.value = List<BarDrinkData>.from(_allDrinks);
      return;
    }
    drinkList.value = _allDrinks
        .where(
          (drink) =>
              drinkCategoryIdForFilter(
                categoryId: drink.categoryId,
                category: drink.category,
              ) ==
              selectedId,
        )
        .toList();
  }

  void onDrinkCategoryFilterChanged(String categoryId) {
    selectedCategoryId.value = categoryId;
    applyDrinkCategoryFilter();
  }

  Future<void> getBarDetails(String? barId) async {
    await getIt<MemberService>().details(barId ?? '').handler(
      barDetailsState,
      onSuccess: (value) {
        if (value.isSuccess && value.data != null) {
          barDetails.value = value.data ?? BarGetUpdateData();
          _allDrinks = List<BarDrinkData>.from(value.data?.drinks ?? []);
          selectedCategoryId.value = '';
          applyDrinkCategoryFilter();
          loadDrinkCategories();
          addAboutListData();
          selectedTab.value = true;
          isSuccess.value = true;
          final myReview = value.data?.myReview;
          hasMyBarReview.value = myReview?.sId != null && myReview!.sId!.isNotEmpty;
        } else {
          isSuccess.value = false;
        }
      },
      onFailed: (value) {
        showError(value.error.description);
        isSuccess.value = false;
      },
    );
  }

  void disposeAll() {
    tabController.dispose();
    selectedTab.value = false;
    oProfile = '';
    oName = '';
    barProfile = '';
    barName = '';
    googleMapController.dispose();
    aboutList = [];
    isSuccess.value = false;
    barDetails.value = BarGetUpdateData();
    drinkList.value = [];
    _allDrinks = [];
    drinkCategories.value = [];
    selectedCategoryId.value = '';
    origin.value = const LatLng(0, 0);
    markers.value = [];
  }
}
