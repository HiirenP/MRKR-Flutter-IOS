import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:marker/app/data/services/auth_service/auth_service.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@i.lazySingleton
@i.injectable
class ContactUsController extends GetxController {
  ContactUsController() {
    onInit();
  }

  final GlobalKey<FormState> formKeyContact = GlobalKey<FormState>();
  final changeState = ApiState.initial().obs;

  TextEditingController subjectController = TextEditingController();
  TextEditingController cFullNameController = TextEditingController();
  TextEditingController cEmailController = TextEditingController();
  TextEditingController cWriteMessageController = TextEditingController();

  Future<void>  getUserData() async {
    final authData = getIt<SharedPreferences>().getUserData;
    if (authData != null) {
      cFullNameController = TextEditingController(text: authData.name);
      cEmailController = TextEditingController(text: authData.email);
      cWriteMessageController = TextEditingController();
      subjectController = TextEditingController();
    }
  }

  Future<void> contactUs(BuildContext context) async {
    if (!formKeyContact.currentState!.validate()) {
      return;
    }
    changeState.value = LoadingState();
    await getIt<AuthService>()
        .contactUs(
            name: cFullNameController.text,
            email: cEmailController.text,
            subject: subjectController.text,
            message: cWriteMessageController.text)
        .handler(
      changeState,
      onSuccess: (value) {
        Get.back();
        showSuccess(value.message);
      },
      onFailed: (value) {
        showError(value.error.description);
      },
    );
  }
}
