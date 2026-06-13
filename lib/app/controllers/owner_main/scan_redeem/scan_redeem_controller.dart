import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/ui/pages/member_main/home/upcoming_marker_details_page.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_textfields.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

@i.lazySingleton
@i.injectable
class ScanRedeemController extends GetxController {
  ScanRedeemController() {
    onInit();
  }

  TextEditingController enterMarkerCodeController = TextEditingController();

  // String scanDataUrl = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void onQRViewCreated(QRViewController controllers) {
    var isOnce = false;
    controllers.scannedDataStream.listen((scanData) async {
      final scanDataUrl = scanData.code ?? '';
      if (scanDataUrl.isNotEmpty) {
        if (isOnce) {
          return;
        }
        isOnce = true;
        Get.back();
        debugPrint('Scanned QR Code-----------------------------------------------: ${scanData.code}');
        await UpcomingMarkerDetailsPage.route(isShowBtn: true, qrCode: scanDataUrl)?.then(
          (value) {
            if (value != null && value is bool) {
              if (value) {
                Get.back();
              }
            }
          },
        );
      }
      debugPrint('Scanned QR Code: ${scanData.code}');
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      showError('Permission not allow');
    }
  }

  Future<dynamic> viaCodeBottomSheet() async {
    enterMarkerCodeController.text = '';
    final context = Get.context!;
    return Get.bottomSheet(
      AppBottomSheet(
        title: AppStrings.T.markerCode,
        isDivider: true,
        content: TextInputField(
          type: InputType.text,
          textInputAction: TextInputAction.done,
          controller: enterMarkerCodeController,
          hintLabel: AppStrings.T.enterMarkerCode,
          context: context,
          prefixIcon: ImageView(Assets.svg.hashtag),
        ),
        positiveButtonTitle: AppStrings.T.getDetails,
        onPositivePressed: () async {
          if (enterMarkerCodeController.text.isNotEmpty) {
            Get.back();
            await UpcomingMarkerDetailsPage.route(
                isShowBtn: true, type: 'code', qrCode: enterMarkerCodeController.text.trim());
          } else {
            showError(AppStrings.T.pleaseEnterMarker);
          }
        },
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }

  Future<dynamic> qrCodeBottomSheet() async {
    final context = Get.context!;
    return Get.bottomSheet(
      isScrollControlled: true,
      AppBottomSheet(
        title: AppStrings.T.scanQRCode,
        isDivider: true,
        content: SizedBox(
          height: 350,
          width: 350,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: context.colorScheme.onPrimary,
                borderRadius: 10,
                borderWidth: 7,
                cutOutSize: 250,
              ),
              onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
            ),
          ),
        ),
        positiveButtonTitle: AppStrings.T.getDetails,
        onPositivePressed: () async {
          showError(AppStrings.T.pleaseScanQr);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
