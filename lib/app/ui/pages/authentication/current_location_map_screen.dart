import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/auth/current_location_map_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class CurrentLocationMapScreen extends GetItHook<LocationMapController> {
  const CurrentLocationMapScreen({super.key});

  static bool isBackVisible = false;

  static Future<T?>? route<T>({bool isAllClear = false}) {
    isBackVisible = isAllClear;
    if (isAllClear) {
      Get.offAllNamed(AppRoutes.locationMapPage);
    }
    return Get.toNamed(AppRoutes.locationMapPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.secondary,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Obx(() {
              return controller.currentPosition.value != null
                  ? GoogleMap(
                      onMapCreated: (controllers) {
                        controller.googleMapController = controllers;
                      },
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value!,
                        zoom: 17,
                      ),
                      markers: Set<Marker>.of(controller.markers), // Ensure this is a Set
                    )
                  : const Center(child: CircularProgressIndicator());
            }),
            Column(
              children: [
                Padding(
                  padding: const AppEdgeInsets.all16(),
                  child: AppCustomAppbar(
                    appTitle: AppStrings.T.currentLocation,
                    isPadding: true,
                    isHideBackButton: isBackVisible,
                  ),
                ),
                const Spacer(),
                Container(
                  height: Get.height / 3.5,
                  width: Get.width,
                  padding: const AppEdgeInsets.all16(),
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        AppStrings.T.currentAddress,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: context.colorScheme.secondaryFixedDim, fontWeight: FontWeight.w400),
                      ),
                      const Gap(10),
                      Obx(
                        () => AppText(
                          controller.fullAddress.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                        label: AppStrings.T.useCurrentLocation,
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.mainPage);
                        },
                      ),
                      const Gap(15),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.offAllNamed(AppRoutes.mainPage);
                          },
                          child: AppText(
                            AppStrings.T.skip,
                            style: context.textTheme.labelSmall?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: context.colorScheme.secondaryFixedDim,
                            ),
                          ),
                        ),
                      ),
                      const CustomSizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => true;

  @override
  void onInit() {
    controller.markers.value = [];
    controller.checkLocationPermission();
  }

  @override
  void onDispose() {
    controller.googleMapController?.dispose();
    controller.positionStream?.cancel();
    controller.positionStream = null;
    controller.markers.value = [];
  }
}
