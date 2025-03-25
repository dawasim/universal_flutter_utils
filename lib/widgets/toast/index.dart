import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUToast{
  static showToast(String message, {String? title}) {
    Get.snackbar(
        title ?? UFUtils.appName, message,
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: UFUText(
          text: title ?? UFUtils.appName,
          textSize: UFUTextSize.heading2,
          fontWeight: UFUFontWeight.bold,
        ),
        messageText: UFUText(
          text: message,
          fontWeight: UFUFontWeight.regular,
          textSize: UFUTextSize.heading4,
          maxLine: 5,
        ),
        margin: EdgeInsets.fromLTRB(15, 0, 15, MediaQuery.of(Get.context!).padding.bottom + 16),
        borderRadius: 8,
        snackStyle: SnackStyle.GROUNDED,
        borderColor: AppTheme.themeColors.primary,
        borderWidth: 3
    );
  }
}