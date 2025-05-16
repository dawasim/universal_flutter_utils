import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'controller.dart';

class APISampleCalls extends StatelessWidget {
  const APISampleCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<APISampleCallsController>(
      global: false,
      init: APISampleCallsController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: UFUText(text: "API Samples", textSize: UFUTextSize.heading1),
        ),
        body: Obx(()=> SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UFUButton(text: "Get token ( POST Request )", onPressed: controller.getToken),
                  ...divider(),
                  if(controller.token.value.isNotEmpty)
                    ...[
                      UFUText(text: controller.token.value),
                      ...divider(),
                    ],
                  UFUButton(text: "GET Request", onPressed: controller.getRequest),
                  ...divider(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> divider() => [
    SizedBox(height: 10),
    Divider(),
    SizedBox(height: 10),
  ];
}
