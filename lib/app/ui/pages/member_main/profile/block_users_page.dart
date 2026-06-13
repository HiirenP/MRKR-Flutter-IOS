import 'package:marker/app/controllers/member_main/profile/profile_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/pages/empty_screen.dart';
import 'package:marker/app/ui/widgets/custom_appbar.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';

import 'package:marker/app/utils/helpers/exporter.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';

class BlockUsersPage extends GetItHook<ProfileController> {
  const BlockUsersPage({super.key});

  static Future<T?>? route<T>() {
    return Get.toNamed(AppRoutes.blockUsersPage);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        key: controller.formChangePwdKey,
        child: Obx(
          () => Scaffold(
            body: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const AppEdgeInsets.all16(),
                    child: AppCustomAppbar(
                      appTitle: AppStrings.T.blockUsers,
                      isPadding: true,
                    ),
                  ),
                  Expanded(
                    child: controller.listBlockedUsers.isEmpty
                        ? EmptyScreen(
                            title: controller.errorMessage.value,
                          )
                        : ListView.builder(
                            padding: const AppEdgeInsets.h16(),
                            itemBuilder: (context, index) {
                              final model = controller.listBlockedUsers[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: context.colorScheme.secondary,
                                ),
                                margin: EdgeInsets.symmetric(vertical: 3),
                                child: ListTile(
                                  leading: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: ImageView(
                                        model.blockedUser?.profile ?? '',
                                        shape: BoxShape.circle,
                                      )),
                                  title: AppText(model.blockedUser?.name ?? '', style: context.textTheme.bodyMedium),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      controller.apiUnBlockUser(
                                        blockedId: model.blockedUser?.id??'',
                                        index: index,
                                      );
                                    },
                                    child: AppText('Unblock',
                                        style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.primary)),
                                  ),
                                ),
                              );
                            },
                            itemCount: controller.listBlockedUsers.length,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.listBlockedUsers.value = [];
    controller.apiBlockedUsers();
  }

  @override
  void onDispose() {}
}
