import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class TextSamples extends StatelessWidget {
  const TextSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...regularText(),
        SizedBox(height: 10),
        Divider(),
        ...mediumText(),
        SizedBox(height: 10),
        Divider(),
        ...boldText(),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  List<Widget> regularText() => [
    UFUText(
      text: "Size 30 : 30",
      textSize: UFUTextSize.size30,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Size 28 : 28",
      textSize: UFUTextSize.size28,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Heading 1 : 20",
      textSize: UFUTextSize.heading1,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Heading 2 : 18",
      textSize: UFUTextSize.heading2,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Heading 3 : 16",
      textSize: UFUTextSize.heading3,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Heading 4 : 14",
      textSize: UFUTextSize.heading4,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Heading 5 : 12",
      textSize: UFUTextSize.heading5,
      fontWeight: UFUFontWeight.regular,
    ),
    UFUText(
      text: "Heading 6 : 11",
      textSize: UFUTextSize.heading6,
      fontWeight: UFUFontWeight.regular,
    ),
  ];

  List<Widget> mediumText() => [
    UFUText(
      text: "Size 30 : 30",
      textSize: UFUTextSize.size30,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Size 28 : 28",
      textSize: UFUTextSize.size28,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Heading 1 : 20",
      textSize: UFUTextSize.heading1,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Heading 2 : 18",
      textSize: UFUTextSize.heading2,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Heading 3 : 16",
      textSize: UFUTextSize.heading3,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Heading 4 : 14",
      textSize: UFUTextSize.heading4,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Heading 5 : 12",
      textSize: UFUTextSize.heading5,
      fontWeight: UFUFontWeight.medium,
    ),
    UFUText(
      text: "Heading 6 : 11",
      textSize: UFUTextSize.heading6,
      fontWeight: UFUFontWeight.medium,
    ),
  ];

  List<Widget> boldText() => [
    UFUText(
      text: "Size 30 : 30",
      textSize: UFUTextSize.size30,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Size 28 : 28",
      textSize: UFUTextSize.size28,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Heading 1 : 20",
      textSize: UFUTextSize.heading1,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Heading 2 : 18",
      textSize: UFUTextSize.heading2,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Heading 3 : 16",
      textSize: UFUTextSize.heading3,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Heading 4 : 14",
      textSize: UFUTextSize.heading4,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Heading 5 : 12",
      textSize: UFUTextSize.heading5,
      fontWeight: UFUFontWeight.bold,
    ),
    UFUText(
      text: "Heading 6 : 11",
      textSize: UFUTextSize.heading6,
      fontWeight: UFUFontWeight.bold,
    ),
  ];
}
