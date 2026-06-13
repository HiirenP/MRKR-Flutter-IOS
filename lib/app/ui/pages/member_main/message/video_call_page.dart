import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:marker/app/controllers/member_main/message/video_call_controller.dart';
import 'package:marker/app/routes/app_routes.dart';
import 'package:marker/app/ui/widgets/custom_button.dart';
import 'package:marker/app/ui/widgets/custom_gap.dart';
import 'package:marker/app/ui/widgets/custom_image_view.dart';
import 'package:marker/app/ui/widgets/custom_text.dart';
import 'package:marker/app/utils/constants/app_colors.dart';
import 'package:marker/app/utils/constants/app_edge_insets.dart';
import 'package:marker/app/utils/constants/app_strings.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:marker/gen/assets.gen.dart';
import 'package:marker/service/notification_service.dart';

class VideoCallPage extends GetItHook<VideoCallController> {
  const VideoCallPage({super.key});

  static Future<T?>? route<T>({dynamic model}) async {
    debugPrint('VideoCallPage route');
    isVideoNavigate = true;
    return Get.toNamed(AppRoutes.videoCallPage, arguments: model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 48),
                            child: AppText(
                              controller.userName.value,
                              style: context.textTheme.headlineLarge,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Center(
                          child: controller.remoteUidCall.value != -1
                              ? AgoraVideoView(
                                  controller: VideoViewController.remote(
                                    rtcEngine: controller.engine,
                                    canvas: VideoCanvas(uid: controller.remoteUidCall.value),
                                    connection: RtcConnection(channelId: controller.callChannel),
                                    useAndroidSurfaceView: true,
                                  ),
                                )
                              : controller.profile.value.isNotEmpty
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: ImageView(
                                            controller.profile.value,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const Gap(10),
                                        AppText(
                                          AppStrings.T.ringing,
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ],
                                    )
                                  : AppText(
                                      AppStrings.T.pleaseWaitForRemoteUser,
                                      style: context.textTheme.bodyMedium,
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        right: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 120,
                            height: 170,
                            child: Center(
                              child: Obx(
                                () => controller.localUserJoined.value
                                    ? AgoraVideoView(
                                        controller: VideoViewController(
                                          rtcEngine: controller.engine,
                                          canvas: const VideoCanvas(uid: 0),
                                        ),
                                      )
                                    : const Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                              margin: const AppEdgeInsets.oB15(),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (controller.remoteUidCall.value != -1)
                                      GestureDetector(
                                        onTap: () {
                                          controller.engine.switchCamera();
                                        },
                                        child: CircularContainer(
                                          imagePath: Assets.svg.frontBackCamera,
                                          bgColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.8),
                                          color: context.colorScheme.onPrimary,
                                          radius: 32,
                                        ),
                                      ),
                                    if (controller.remoteUidCall.value != -1)
                                      Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            controller.isMute.value = !controller.isMute.value;
                                            controller.engine.muteLocalAudioStream(controller.isMute.value);
                                          },
                                          child: CircularContainer(
                                            imagePath: controller.isMute.value ? Assets.svg.muteAudio : Assets.svg.microphone,
                                            bgColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.8),
                                            color: context.colorScheme.onPrimary,
                                            radius: 32,
                                          ),
                                        ),
                                      ),
                                    if (controller.remoteUidCall.value != -1)
                                      Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            controller.isStopVideo.value = !controller.isStopVideo.value;
                                            controller.engine.muteLocalVideoStream(controller.isStopVideo.value);
                                          },
                                          child: CircularContainer(
                                            imagePath: controller.isStopVideo.value ? Assets.svg.muteVideo : Assets.svg.video,
                                            bgColor: context.colorScheme.secondaryFixedDim.withValues(alpha: 0.8),
                                            color: context.colorScheme.onPrimary,
                                            radius: 32,
                                          ),
                                        ),
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.disConnectCall();
                                      },
                                      child: CircularContainer(
                                        imagePath: Assets.svg.call,
                                        bgColor: AppColors.darkRed,
                                        color: context.colorScheme.onPrimary,
                                        radius: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSizedBox()
              ],
            ),
          )),
    );
  }

  @override
  bool get canDisposeController => false;

  @override
  void onInit() {
    controller.callInitialize();
  }

  @override
  void onDispose() {
    controller.disposeRecords();
  }
}
