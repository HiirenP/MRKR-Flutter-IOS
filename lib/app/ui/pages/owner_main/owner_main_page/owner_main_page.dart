import 'package:marker/app/controllers/basehome_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:marker/app/utils/constants/app_constant.dart';
import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerMainPage extends GetItHook<BaseHomeController> {
  const OwnerMainPage({super.key});

  static Future<T?>? route<T>({dynamic value}) {
    return Get.offAllNamed(AppRoutes.ownerMainPage, arguments: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          return controller.pages1[controller.selectedIndex.value];
        }),
      ),
      bottomNavigationBar: Obx(() {
        return AppBottomNavigationBar(
          selectedCallback: controller.onItemTapped,
          currentIndex: controller.selectedIndex.value,
          counter: 0.obs,
        );
      }),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onDispose() {
    controller.socketDisconnection();
  }

  @override
  void onInit() {
    final userData = getIt<SharedPreferences>().getUserData;
    if (userData != null) {
      AppConstant.userType = UserTypeExtension.fromString(userData.userType);
    }
    if (Get.arguments != null && Get.arguments is int) {
      controller.selectedIndex.value = 2;
    } else {
      controller.selectedIndex = 0.obs;
    }
    controller.socketConnection();
  }
}
/*
*
* Emit event: rejectCall
payload: { userId, callerId, channelId }

On eventL callRejected
response: { resData: { userId, channelId } }
* */
