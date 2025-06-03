import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'controller.dart';

class UFUVideoPlayer extends StatelessWidget {
  const UFUVideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UFUVideoPlayerController>(
      global: false,
      init: UFUVideoPlayerController(),
      dispose: (GetBuilderState<UFUVideoPlayerController> state) => state.controller?.onDispose(),
      builder: (controller) {
        if (controller.chewieController == null) {
          return const Center(child: UFULoader());
        }
        return UFUScaffold(
          body: Stack(
            children: [
              Center(
                child: Chewie(controller: controller.chewieController!),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: UFUIconButton(
                    onTap: () => Get.back(),
                    backgroundColor: AppTheme.themeColors.text.withAlpha(90),
                    icon: Icons.close,
                    iconSize: 25,
                    iconColor: AppTheme.themeColors.base,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
