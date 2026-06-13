import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker/app/controllers/member_main/home/map_near_by_bar_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class MapNearByBarPage extends GetItHook<MapNearByBarController> {
  const MapNearByBarPage({super.key});

  static Future<T?>? route<T>({dynamic map}) {
    return Get.toNamed(AppRoutes.mapMarkerPage, arguments: map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              children: [
                Obx(
                  () => controller.isLoaded.value
                      ? GoogleMap(
                          onMapCreated: (controllers) {
                            controller.googleMapController = controllers;
                          },
                          initialCameraPosition: CameraPosition(
                            target: controller.latLong.value,
                            zoom: 13,
                          ),
                          markers: Set<Marker>.of(controller.markers),
                        )
                      : const SizedBox(),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: AppCustomAppbar(isPadding: true),
                ),
              ],
            )));
  }

  @override
  bool get canDisposeController => false;

  @override
  void onDispose() {
    controller.resetData();
    controller.stream?.cancel();
  }

  @override
  void onInit() {
    controller.initData();
  }
}
