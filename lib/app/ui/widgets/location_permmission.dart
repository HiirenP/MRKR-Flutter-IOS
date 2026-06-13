import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:marker/app/ui/pages/member_main/main_page/main_page.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_circular_container.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PopScope(
          canPop: false,
          child: Center(
            child: Padding(
              padding: const AppEdgeInsets.all16(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppCircularContainer(
                    iconName: Padding(
                      padding: const EdgeInsets.all(30),
                      child: ImageView(
                        Assets.svg.location,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  const Gap(20),
                  CenterText(
                    AppStrings.T.locationService,
                    style: context.textTheme.titleLarge,
                  ),
                  const Gap(20),
                  CenterText(
                    AppStrings.T.locationAccess,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.secondaryFixedDim,
                    ),
                  ),
                  const Gap(40),
                  AppButton(
                      label: AppStrings.T.turnLocationService,
                      onPressed: () async {
                        await checkLocationAccess(context);
                      }),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkLocationAccess(BuildContext context) async {
    var permissionStatus = await Permission.location.status;
    debugPrint('serviceEnabled--------------------$permissionStatus');

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.location.request();
    }

    // If permanently denied, guide user to settings
    if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    if (permissionStatus.isGranted) {
      debugPrint('serviceEnabled--------------------$permissionStatus');
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('serviceEnabled--------------------$serviceEnabled');
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        await Future.delayed(const Duration(seconds: 3));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        debugPrint('serviceEnabled--------------------$serviceEnabled');
        if (!serviceEnabled) {
          return false;
        } else {
          await MainPage.route(from: 'Location1');
        }
      }
      await MainPage.route(from: 'Location2');
    }

    return false;
  }
}
