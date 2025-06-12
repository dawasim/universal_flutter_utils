import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DirectionHelper {
  static bool get isRtl {
    final context = Get.context;
    if (context == null) return false;
    return Directionality.of(context) == TextDirection.rtl;
  }
}