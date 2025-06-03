import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUOtpInputBox extends StatefulWidget {
  const UFUOtpInputBox({
    super.key,
    this.inputBoxController,
    this.controller,
    this.focusNode,
    this.validator,
    this.onCompleted,
  });

  final UFUInputBoxController? inputBoxController;
  final TextEditingController? controller;
  /// It is use to get focus of a inputBox.
  final FocusNode? focusNode;
  /// Use to validate values of inputBox.
  final FormFieldValidator<dynamic>? validator;
  /// Fires when user completes pin input
  final ValueChanged<String>? onCompleted;

  @override
  State<UFUOtpInputBox> createState() => _UFUOtpInputBoxState();
}

class _UFUOtpInputBoxState extends State<UFUOtpInputBox> {

  late UFUInputBoxController inputBoxController;
  String errorText = '';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    inputBoxController = widget.inputBoxController ?? UFUInputBoxController();
    inputBoxController.setParentController(widget.controller);
    inputBoxController.setParentFocusNode(widget.focusNode);
    inputBoxController.setValidator(validateField);
  }

  String? validateField(String? value) {
    setState(() {
      if(widget.validator != null) {
        errorText = widget.validator!(value) ?? '';
      }
    });
    return errorText.isEmpty ? null : errorText;
  }

  @override
  Widget build(BuildContext context) {

    Color focusedBorderColor = AppTheme.themeColors.primary;
    Color fillColor = AppTheme.themeColors.base;
    Color borderColor = AppTheme.themeColors.inverse;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: AppTheme.themeColors.primary,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );


    return Pinput(
      controller: inputBoxController.controller,
      focusNode: inputBoxController.focusNode,
      defaultPinTheme: defaultPinTheme,
      validator: validateField,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      keyboardType: TextInputType.number,
      onCompleted: widget.onCompleted,
      // onChanged: (value) {
      //   debugPrint('onChanged: $value');
      // },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: focusedBorderColor,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: fillColor,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );
  }
}
