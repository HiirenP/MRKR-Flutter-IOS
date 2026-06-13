import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/ui/widgets/custom_bottom_sheet.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/gen/assets.gen.dart';

@i.lazySingleton
@i.injectable
class ResetPwdController extends GetxController {
  ResetPwdController() {
    onInit();
  }

  final loginState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController resetPassController = TextEditingController(text: kDebugMode ? 'Test#123' : '');
  TextEditingController confirmPassController = TextEditingController(text: kDebugMode ? 'Test#123' : '');
  String userId = '';

  Future<void> resetPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    loginState.value = LoadingState();
    await getIt<AuthService>().resetPassword(resetPassController.text.trim().convertMd5, userId).handler(
      loginState,
      onSuccess: (value) {
        if (value.isSuccess && value.statusCode == 200) {
          successBottomSheet().then(
            (value) {
              if (value != null && value is bool) {
                if (value) Get.back(result: value);
              }
            },
          );
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  Future<dynamic> successBottomSheet() {
    return Get.bottomSheet(
      AppBottomSheet(
        iconName: Padding(
          padding: const AppEdgeInsets.all12(),
          child: ImageView(Assets.svg.verify),
        ),
        title: AppStrings.T.successful,
        subTitle: AppStrings.T.yourPasswordSuccessfully,
        positiveButtonTitle: AppStrings.T.ok,
        onPositivePressed: () {
          Get.back(result: true);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      ),
    );
  }
}
