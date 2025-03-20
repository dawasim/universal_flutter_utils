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

  static String? phoneValidator(String? value, {bool isRequired = true, String field = "Phone number"}) {
    value = value?.replaceAll(" ", "");
    if (isRequired && (value == null || value.isEmpty)) {
      return '$field is required';
    }
    if (value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^\d{10}$');
      if (!phoneRegex.hasMatch(value)) {
        return 'Enter a valid 10-digit phone number';
      }
    }
    return null;
  }

  static String? textValidator(String? value, {bool isRequired = true}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'Must be at least 3 characters';
      }
    }
    return null;
  }
}