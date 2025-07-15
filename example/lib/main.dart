import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'api_calls/view/index.dart';
import 'file_picker/index.dart';
import 'widgets/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    UFUtils.appName = "Universal Flutter Utils Demo";
    UFUtils.baseUrl = "https://dummyjson.com/";

    AppTheme.themeColors.primary = Color(0xff9381ff);
    AppTheme.themeColors.secondary = Color(0xffb8b8ff);
    AppTheme.themeColors.tertiary = Color(0xffffd8be);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: UFUtils.appName,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.themeColors.primary,
        title: Text(UFUtils.appName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UFUButton(text: "Widgets Sample", onPressed: () => Get.to(WidgetsSamples())),
              ...divider(),
              UFUButton(text: "API Sample Call's", onPressed: () => Get.to(APISampleCalls())),
              ...divider(),
              UFUButton(text: "File Picker", onPressed: () => Get.to(FilePicker())),
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
