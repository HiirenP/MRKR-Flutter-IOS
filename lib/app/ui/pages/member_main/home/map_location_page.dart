import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/member_main/home/location_marker_controller.dart';
import 'package:marker/app/data/models/bar_get_update_details_model/bar_get_update_details_model.dart';
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapLocationPage extends GetItHook<LocationMarkerController> {
  const MapLocationPage({super.key});

  static Future<T?>? route<T>({BarGetUpdateData? data, RedeemedUpcomingListData? drink}) {
    return Get.toNamed(AppRoutes.mapLocationPage, arguments: [data, drink]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => GoogleMap(
                onMapCreated: (controllers) {
                  controller.googleMapController = controllers;
                },
                initialCameraPosition: CameraPosition(
                  target: controller.origin,
                  zoom: 13,
                ),
                markers: Set<Marker>.of(controller.markers),
                // Ensure this is a Set
                polylines: Set<Polyline>.of(controller.polyLines),
              ),
            ),
            const Positioned(
                top: 16,
                left: 16,
                child: AppCustomAppbar(
                  isPadding: true,
                )),
            Obx(
              () => controller.isData.value
                  ? Container(
                      height: 145,
                      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const AppEdgeInsets.all8(),
                            child: ImageView(
                              controller.image ?? '',
                              borderRadius: BorderRadius.circular(18),
                              inner: ImageSize(width: 115, height: 140),
                            ),
                          ),
                          const Gap(5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:8,right: 5),
                                  child: AppText(
                                    controller.barName?.capitalize ?? '',
                                    style: context.textTheme.bodyMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Gap(3),
                                Row(
                                  children: [
                                    ImageView(Assets.svg.clock),
                                    const Gap(5),
                                    Expanded(
                                      child: AppText(
                                        controller.time ?? '',
                                        style: context.textTheme.bodySmall?.copyWith(
                                          color: context.colorScheme.secondaryContainer,
                                        ),
                                      ),
                                    ),
                                    const Gap(5),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ImageView(
                                      Assets.svg.routing,
                                      color: context.colorScheme.primary,
                                      inner: ImageSize(height: 20, width: 20),
                                    ),
                                    const Gap(5),
                                    AppText(
                                      controller.distance.isNotEmpty
                                          ? '${double.parse(controller.distance).toStringAsFixed(2)} mi'
                                          : '',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colorScheme.secondaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const AppEdgeInsets.all5(),
                                        margin: const AppEdgeInsets.all10(),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: context.colorScheme.secondary),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Gap(5),
                                            ImageView(Assets.svg.sStar),
                                            const Gap(5),
                                            AppText(
                                              controller.averageRating ?? '',
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.secondaryContainer,
                                              ),
                                            ),
                                            const Gap(5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  Future<void> onInit() async {
    controller.markers = <Marker>[].obs;
    controller.polylineCoordinates = [];
    controller.polyLines = <Polyline>[].obs;
    controller.polylinePoints = PolylinePoints();
    controller.origin =
        LatLng(getIt<SharedPreferences>().getLatitude ?? 0, getIt<SharedPreferences>().getLongitude ?? 0);
    if (Get.arguments != null) {
      if (Get.arguments[0] is BarGetUpdateData) {
        final data = Get.arguments[0] as BarGetUpdateData;
        final barId = data.barId ?? '';
        if (barId.isNotEmpty) {
          await controller.findCurrentLocation(barId);
        }
        controller.isData.value = true;
      }
      if (Get.arguments[1] is RedeemedUpcomingListData) {
        final drinkModel = Get.arguments[1] as RedeemedUpcomingListData;
        final barId = drinkModel.barId?.sId ?? '';
        if (barId.isNotEmpty) {
          await controller.findCurrentLocation(barId);
        }
      }
    }
  }

  @override
  void onDispose() {
    controller.distanceAll();
  }
}
