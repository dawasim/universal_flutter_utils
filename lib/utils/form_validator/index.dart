import 'package:get/get.dart';

class FormValidator {

  static String? emailValidator(String? value, {bool isRequired = true, String field = "Email"}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$field is required';
    }
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid email';
      }
    }
    return null;
  }

  static String? passwordValidator(String? value, {bool isRequired = true, String field = "Password"}) {
    // Check if the password is required and empty
    if (isRequired && (value == null || value.isEmpty)) {
      return '$field is required';
    }

    // If the password is not null or empty, apply the validation rules
    if (value != null && value.isNotEmpty) {
      // Check the length (min 8, max 12)
      if (value.length < 8) {
        return 'Password must be at least 8 characters';
      } else if (value.length > 12) {
        return 'Password must not exceed 12 characters';
      }

      // Check for at least 1 uppercase letter
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      }

      // Check for at least 1 lowercase letter
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      }

      // Check for at least 1 number
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Password must contain at least one number';
      }

      // Check for at least 1 special character
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return 'Password must contain at least one special character';
      }
    }

    return null; // Return null if the password is valid
  }

  static String? confirmPasswordValidator(String? value, {bool isRequired = true, required String password}) {
    // Check if the password is required and empty
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Confirm password is required';
    }

    // If the password is not null or empty, apply the validation rules
    if (value != null && value.isNotEmpty) {
      // Check the length (min 8, max 12)
      if (value.length < 8) {
        return 'Confirm password must be at least 8 characters';
      } else if (value.length > 12) {
        return 'Confirm password must not exceed 12 characters';
      }

      // Check for at least 1 uppercase letter
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Confirm password must contain at least one uppercase letter';
      }

      // Check for at least 1 lowercase letter
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Confirm password must contain at least one lowercase letter';
      }

      // Check for at least 1 number
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Confirm password must contain at least one number';
      }

      // Check for at least 1 special character
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return 'Confirm password must contain at least one special character';
      }

      // Check for at least confirm password matches with passwoed
      if (value != password) {
        return 'Password and Confirm Password do not match!';
      }
    }

    return null; // Return null if the password is valid
  }

  static String? phoneValidator(String? value, {bool isRequired = true, String field = "Phone number", RegExp? phoneRegex}) {
    value = value?.replaceAll(" ", "");

    // 1. Check for required field
    if (isRequired && (value == null || value.isEmpty)) {
      return '$field ${"is_required".tr}';
    }

    // 2. Validate phone number format
    // Allows numbers with a length between 6 and 12
    if (value != null && value.isNotEmpty) {
      phoneRegex ??= RegExp(r'^\d{6,12}$');
      if (!phoneRegex.hasMatch(value)) {
        return 'enter_valid_phone_number'.tr;
      }

      // 3. Reject phone numbers with only zeros
      if (RegExp(r'^0+$').hasMatch(value)) {
        return 'enter_valid_phone_number'.tr;
      }
    }

    return null;
  }

  static String? textValidator(String? value, {bool isRequired = true, int minCount = 3}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'this_field_is_required'.tr;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < minCount) {
        return '${"must_be_at_least".tr} $minCount ${"characters".tr}';
      }
    }
    return null;
  }
}