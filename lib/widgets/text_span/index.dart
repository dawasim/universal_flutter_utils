import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';


class UFUTextSpan {
  static TextSpan getSpan(String text, {
    UFUTextSize textSize = UFUTextSize.heading4,
    UFUFontFamily fontFamily = UFUFontFamily.productSans,
    UFUFontWeight fontWeight = UFUFontWeight.regular,
    Color? textColor,
    TextOverflow? overflow,
    TextAlign textAlign = TextAlign.center,
    int? maxLine,
    TextDecoration? textDecoration,
    List<InlineSpan>? children,
    double? letterSpacing,
    GestureRecognizer? recognizer,
    FontStyle? fontStyle,
    double? height}) {
  return TextSpan(
        text: text,
        recognizer: recognizer,
        style: TextStyle(
          color: textColor ?? AppTheme.themeColors.text,
          fontSize: TextHelper.getTextSize(textSize),
          fontFamily: TextHelper.getFontFamily(fontFamily,fontWeight),
          fontWeight: TextHelper.getFontWeight(fontWeight),
          package: 'UFU_mobile_flutter_ui',
          overflow: overflow,
          height: height,
          fontStyle: fontStyle,
          decoration: textDecoration,
          letterSpacing: letterSpacing,
        ),
        children: children);
  }
}
