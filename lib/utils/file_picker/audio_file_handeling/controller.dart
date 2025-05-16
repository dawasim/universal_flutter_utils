import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';

class RecordingDialogController extends GetxController {

  RecorderController recorderController = RecorderController();

  RxBool isRecording = false.obs;

  @override
  void onInit() {
    super.onInit();
    startRecording();
  }

  Future<void> startRecording() async {
    try {
      isRecording.value = true;
      await recorderController.record();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stopRecording() async {
    try {
      if (isRecording.isTrue) {
        recorderController.reset();
        final path = await recorderController.stop(false);
        if (path != null) {
          print(path);
          Get.back(result: path);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isRecording.value = false;
    }
  }

}