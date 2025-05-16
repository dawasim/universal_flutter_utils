import 'package:flutter/material.dart';

class UFUCommonMethods {
  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}