
import 'package:flutter/material.dart';

class UFUInputBoxController {

  bool validateOnChange = false;
  Function(String)? validator;
  GlobalKey key = GlobalKey();
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  set text(String data) {
    controller.text = data;
  }

  String get text => controller.text.trim().toString();

  UFUInputBoxController({String? text, bool validateInRealTime = false}) {
    if(text != null)  this.text = text;

    if (validateInRealTime) {
      controller.addListener(() {
        if (!validateOnChange) {
          validateOnChange = true;
        }
      });
    }
  }

  void setParentController(TextEditingController? controller) {
    if(controller != null) {
      this.controller = controller;
    }
  }

  void setParentFocusNode(FocusNode? focusNode) {
    if(focusNode != null) {
      this.focusNode = focusNode;
    }
  }

  void setValidator(Function(String) validator) {
    this.validator = validator;
  }

  Future<void> scrollAndFocus() async {

    if(key.currentContext == null) return;

    await Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      alignment: 0.08,
    );
    focusNode.requestFocus();
  }

  // void validate() {
  //   validator?.call(controller.text);
  // }

  bool validate() {
    if (validator != null) {
      final result = validator!(controller.text);
      return result == null || result.isEmpty; // Assuming the validator returns null or an empty string for valid cases
    }
    return true; // If no validator is set, consider it valid
  }
}