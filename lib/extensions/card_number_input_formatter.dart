import 'package:flutter/services.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue,) {
    final formatted = UFUtils.formatCardNumber(newValue.text);
    // Calculate the new cursor position
    int selectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

