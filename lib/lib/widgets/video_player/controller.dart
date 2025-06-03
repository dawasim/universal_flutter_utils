import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:video_player/video_player.dart';

class UFUVideoPlayerController extends GetxController {
  String? videoUrl = Get.arguments["video_url"];
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    if (videoUrl?.isNotEmpty ?? false) {
      try {
        videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl ?? ""));

        await videoPlayerController.initialize();
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: true,
          fullScreenByDefault: true,
          allowFullScreen: false,
        );
        update();
      } catch (e) {
        Get.back();
        await Future.delayed(Duration(seconds: 2));
        UFUToast.showToast("Unable to load video");
      }

    }
  }


  void onDispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    videoPlayerController.dispose();
    chewieController?.dispose();
  }
}