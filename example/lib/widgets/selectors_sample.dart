import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class SelectorsSample extends StatelessWidget {
  SelectorsSample({super.key});

  final List<UFUSingleSelectModel> mainList = [
    UFUSingleSelectModel(id: "1", label: "Label 1"),
    UFUSingleSelectModel(id: "2", label: "Label 2"),
    UFUSingleSelectModel(id: "3", label: "Label 3"),
    UFUSingleSelectModel(id: "4", label: "Label 4"),
    UFUSingleSelectModel(id: "5", label: "Label 5"),
    UFUSingleSelectModel(id: "6", label: "Label 6"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UFUButton(onPressed: () => UFUSingleSelect(mainList: mainList), text: "Single Select",  size: UFUButtonSize.large),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
        UFUButton(onPressed: () => UFUSingleSelect(mainList: mainList), text: "Multi Select",  size: UFUButtonSize.large),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
      ],
    );
  }
}
