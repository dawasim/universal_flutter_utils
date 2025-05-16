import 'package:example/widgets/list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'avtar_samples.dart';
import 'button_samples.dart';
import 'edit_profile_image.dart';
import 'icon_button_samples.dart';
import 'selectors_sample.dart';
import 'text_button_samples.dart';
import 'text_samples.dart';

class WidgetsSamples extends StatelessWidget {
  const WidgetsSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: UFUText(text: "Widgets Samples", textSize: UFUTextSize.heading1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextSamples(),
              ButtonSamples(),
              SelectorsSample(),
              IconButtonSamples(),
              ...divider(),
              TextButtonSamples(),
              ...divider(),
              AvtarSamples(),
              ...divider(),
              UFUButton(text: "List View Sample (With Pagination)", onPressed: () => Get.to(ListViewSample())),
              ...divider(),
              UFUButton(text: "Profile Image Edit", onPressed: () => Get.to(EditProfileImage())),
              ...divider(),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> divider() => [
    SizedBox(height: 10),
    Divider(),
    SizedBox(height: 10),
  ];
}
