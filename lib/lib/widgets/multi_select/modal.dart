import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

/// Defines data modal of a UFUSingleSelect class
class UFUMultiSelectModel {
  /// Defines label of a mainList of a multiselect.
  String label;

  /// Defines id of a mainList of a multiselect
  String id;

  /// Defines child widget of a mainList of a multiselect
  Widget? child;

  /// Defines color of a mainList of a multiselect
  Color? color;

  /// Defines borderColor of a mainList of a multiselect
  Color? borderColor;

  /// Defines list is select or not  of a mainList of a multiselect
  bool isSelect;

  /// subList can be used to add data linked to multiselect items
  List<UFUMultiSelectModel>? subList;

  /// additionData can be used to add some sort of additional data
  dynamic additionData;

  int? subListLength;

  List<TagLimitedModel>? tags;
  
  String? prefixLabel;

  String? suffixLabel;

  String? disableMessage;

  bool displayLabelOnly;

  bool isDisabled;

  UFUInputBoxController? labelController;

  bool? active;

  dynamic additionalDetails;

  UFUMultiSelectModel({
    required this.label,
    required this.id,
    this.prefixLabel,
    this.suffixLabel,
    this.child,
    this.color,
    this.borderColor,
    required this.isSelect,
    this.subList,
    this.subListLength,
    this.tags,
    this.additionData,
    this.displayLabelOnly = false,
    this.active = true,
    this.labelController,
    this.isDisabled = false,
    this.disableMessage,
    this.additionalDetails,
  });

  factory UFUMultiSelectModel.clone(UFUMultiSelectModel source) {

    return UFUMultiSelectModel(
      label: source.label,
      id: source.id,
      child: source.child,
      color: source.color,
      borderColor: source.borderColor,
      isSelect: source.isSelect,
      subList: source.subList,
      subListLength: source.subListLength,
      tags: source.tags,
      prefixLabel: source.prefixLabel,
      suffixLabel: source.suffixLabel,
      additionData: source.additionData,
      displayLabelOnly: source.displayLabelOnly,
      labelController: UFUInputBoxController(text: source.label),
      active: source.active,
      isDisabled: source.isDisabled,
      disableMessage: source.disableMessage,
      additionalDetails: source.additionalDetails
    );
  }

  @override
  bool operator == (other) {
    return (other is UFUMultiSelectModel)
        && other.id == id
        && other.label == label
        && other.borderColor == borderColor
        && other.isSelect == isSelect
        && other.color == color
        && other.child == child
        && other.subList == subList
        && other.subListLength == subListLength
        && other.tags == tags
        && other.prefixLabel == prefixLabel
        && other.additionData == additionData
        && other.displayLabelOnly == displayLabelOnly
        && other.active == active
        && other.suffixLabel == suffixLabel
    ;
  }

  @override
  int get hashCode => 1;


}
