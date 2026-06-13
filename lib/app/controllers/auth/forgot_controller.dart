import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/models/auth_model/auth_model.dart';
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/ui/pages/authentication/verify_code_page.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';

@i.lazySingleton
@i.injectable
class ForgotController extends GetxController {
  ForgotController() {
    onInit();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final loginState = ApiState.initial().obs;
  Rxn<AuthModel> authModel = Rxn<AuthModel>();
  TextEditingController forgotEmailController = TextEditingController();

  // Rx<ChannelType> channelType = ChannelType.email.obs;

  Future<void> forgotPassword() async {
    print("aave che ");
    if (!formKey.currentState!.validate()) {
      return;
    }
    print("aave che 2222");

    loginState.value = LoadingState();
    await getIt<AuthService>().forgotPassword(forgotEmailController.text, ChannelType.email.backendValue).handler(
      loginState,
      onSuccess: (value) {
        if (value.isSuccess && value.statusCode == 200 && value.data != null) {
          showSuccess(value.message);
          var responseData = <String, dynamic>{
            'email': value.data?.email,
            // 'channel': channelType.value.backendValue,
          };
          VerifyCodePage.route(argument: responseData)!.then((value) {
            // forgotEmailController.clear();
          });
        } else {
          showError(value.message);
        }
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }

  void onDisposeAll() {
    forgotEmailController.text = '';
  }
}
