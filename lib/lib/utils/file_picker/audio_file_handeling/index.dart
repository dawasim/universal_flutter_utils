
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'controller.dart';

Future<dynamic> ShowRecordingDialog() async {
  return await showUFUDialog(
    child: (UFUBottomSheetController bottomSheetController) => GetBuilder<RecordingDialogController>(
    global: false,
    init: RecordingDialogController(),
    builder:(controller) =>  Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: AudioWaveforms(
              enableGesture: true,
              size: Size(MediaQuery.of(Get.context!).size.width * 0.65, 50),
              recorderController: controller.recorderController,
              waveStyle: WaveStyle(
                waveColor: AppTheme.themeColors.primary,
                extendWaveform: true,
                showMiddleLine: false,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppTheme.themeColors.base,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: controller.stopRecording,
            child: UFUIcon(
              Icons.stop,
              color: AppTheme.themeColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    ),
  ));
}