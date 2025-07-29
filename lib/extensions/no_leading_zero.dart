import 'package:flutter/services.dart';

class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    // Allow empty string
    if (text.isEmpty) return newValue;

    // Prevent starting with 0
    if (text.startsWith('0')) {
      return oldValue;
    }

    // Only allow digits
    final filteredText = text.replaceAll(RegExp(r'[^\d]'), '');
    return newValue.copyWith(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}
