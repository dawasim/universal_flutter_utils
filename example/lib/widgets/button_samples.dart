import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class ButtonSamples extends StatelessWidget {
  const ButtonSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...defaultButtons(),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        ...defaultDisabledButtons(),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        ...outlinedButtons(),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        ...outlinedDisabledButtons(),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
      ],
    );
  }

  List<Widget> defaultButtons() => [
    UFUButton(onPressed: () {}, text: "Default Flat", ),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Large",  size: UFUButtonSize.large),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium", size: UFUButtonSize.medium),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small", size: UFUButtonSize.small),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Extra small", size: UFUButtonSize.extraSmall),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.mediumWithIcon),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.smallIcon),
  ];

  List<Widget> defaultDisabledButtons() => [
    UFUButton(onPressed: () {}, text: "Default Flat", disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Large",  size: UFUButtonSize.large, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium", size: UFUButtonSize.medium, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small", size: UFUButtonSize.small, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Extra small", size: UFUButtonSize.extraSmall, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.mediumWithIcon, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.smallIcon, disabled: true),
  ];

  List<Widget> outlinedButtons() => [
    UFUButton(onPressed: () {}, text: "Default Flat", type: UFUButtonType.outline),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Large",  size: UFUButtonSize.large, type: UFUButtonType.outline),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium", size: UFUButtonSize.medium, type: UFUButtonType.outline),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small", size: UFUButtonSize.small, type: UFUButtonType.outline),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Extra small", size: UFUButtonSize.extraSmall, type: UFUButtonType.outline),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.mediumWithIcon, type: UFUButtonType.outline),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.smallIcon, type: UFUButtonType.outline),
  ];

  List<Widget> outlinedDisabledButtons() => [
    UFUButton(onPressed: () {}, text: "Default Flat", type: UFUButtonType.outline, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Large",  size: UFUButtonSize.large, type: UFUButtonType.outline, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium", size: UFUButtonSize.medium, type: UFUButtonType.outline, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small", size: UFUButtonSize.small, type: UFUButtonType.outline, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Extra small", size: UFUButtonSize.extraSmall, type: UFUButtonType.outline, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Medium With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.mediumWithIcon, type: UFUButtonType.outline, disabled: true),
    SizedBox(height: 5),
    UFUButton(onPressed: () {}, text: "Small With Icon", iconWidget: UFUIcon(Icons.ice_skating_outlined), size: UFUButtonSize.smallIcon, type: UFUButtonType.outline, disabled: true),
  ];
}
