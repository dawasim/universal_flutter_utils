import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'controller.dart';

class FilePicker extends StatelessWidget {
  const FilePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilePickerController>(
      global: false,
      init: FilePickerController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: UFUText(text: "File Picker Samples", textSize: UFUTextSize.heading1),
        ),
        body: Obx(()=> SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UFUButton(text: "Pick File", onPressed: controller.pickFile),
                ...divider(),
                if(controller.filePath.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.filePath.value),
                    ...divider(),
                  ],
                UFUButton(text: "Pick Image from Gallery", onPressed: controller.pickImageFromGallery),
                ...divider(),
                if(controller.imagePathFromGallery.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.imagePathFromGallery.value),
                    ...divider(),
                  ],
                UFUButton(text: "Pick Image from Camera", onPressed: controller.pickImageFromCamera),
                ...divider(),
                if(controller.imagePath.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.imagePath.value),
                    ...divider(),
                  ],
                UFUButton(text: "Record Audio", onPressed: controller.recordAudio),
                ...divider(),
                if(controller.audioPath.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.audioPath.value),
                    ...divider(),
                  ],
                UFUButton(text: "Pick Contact", onPressed: controller.pickContact),
                ...divider(),
                if(controller.contact.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.contact.value),
                    ...divider(),
                  ],
                UFUButton(text: "Pick Data", onPressed: controller.pickDate),
                ...divider(),
                if(controller.date.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.date.value),
                    ...divider(),
                  ],
                UFUButton(text: "Pick Time", onPressed: controller.pickTime),
                ...divider(),
                if(controller.time.value.isNotEmpty)
                  ...[
                    UFUText(text: controller.time.value),
                    ...divider(),
                  ],
              ],
            ),
          ),
        )),
      ),
    );
  }

  List<Widget> divider() => [
    SizedBox(height: 10),
    Divider(),
    SizedBox(height: 10),
  ];
}
