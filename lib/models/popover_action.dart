import 'package:flutter/material.dart';

class PopoverActionModel {
  String label;
  String value;
  bool isSelected;
  bool isDisabled;
  Widget? icon;

  PopoverActionModel({
    required this.label,
    required this.value,
    this.isSelected = false,
    this.isDisabled = false,
    this.icon
  });

  static void selectAction(List<PopoverActionModel> filters, String selectedLabel) {
    for (var element in filters) {
      element.isSelected = false;
    }
    int index = filters.indexWhere((element) => element.value == selectedLabel);
    filters[index].isSelected = true;
  }

}