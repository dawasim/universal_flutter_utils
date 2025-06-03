import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UFUToast {
  static DateTime? _lastShownTime;
  static const Duration _cooldown = Duration(seconds: 1);

  static void showToast(String message, {String? title}) {
    final now = DateTime.now();

    // Prevent showing toasts if another was just shown recently
    if (_lastShownTime != null &&
        now.difference(_lastShownTime!) < _cooldown) {
      return;
    }

    _lastShownTime = now;

    // Cancel existing toast before showing a new one
    Fluttertoast.cancel();

    // Show the toast
    Fluttertoast.showToast(
      msg: title != null ? "$title\n$message" : message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
