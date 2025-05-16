import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class TextButtonSamples extends StatelessWidget {
  const TextButtonSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        UFUTextButton(text: "Text button", onPressed: (){}, ),
        UFUTextButton(text: "Text button", onPressed: (){}, isDisabled: true),
      ],
    );
  }
}
