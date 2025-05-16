import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class IconButtonSamples extends StatelessWidget {
  const IconButtonSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        UFUIconButton(onTap: () {}),
        UFUIconButton(isDisabled: true),
      ],
    );
  }
}
