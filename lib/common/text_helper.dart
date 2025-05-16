import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class TextHelper {
  /// Return double  textSize of a text and default textSize is [UFUTextSize.heading4]
  static double getTextSize(UFUTextSize textSize) {
    switch (textSize) {
      case UFUTextSize.heading1:
        return 20;
      case UFUTextSize.heading2:
        return 18;
      case UFUTextSize.heading3:
        return 16;
      case UFUTextSize.heading4:
        return 14;
      case UFUTextSize.heading5:
        return 12;
      case UFUTextSize.heading6:
        return 11;
      case UFUTextSize.size30:
        return 30;
      case UFUTextSize.size28:
        return 28;
      default:
        return 14;
    }
  }

  /// Return  fontFamily of a text and default textSize is [UFUFontFamily.roboto]
  static String getFontFamily(UFUFontFamily fontFamily, UFUFontWeight fontWeight) {
    switch (fontFamily) {
      case UFUFontFamily.productSans:
        return getRobotoFontFamily(fontWeight);
      case UFUFontFamily.productSans:
        return getMontserratFontFamily(fontWeight);
      default:
        return 'productSans';
    }
  }

  static String getRobotoFontFamily(UFUFontWeight fontWeight) {
    switch (fontWeight) {
      case UFUFontWeight.regular:
        return 'RobotoRegular';
      case UFUFontWeight.medium:
        return 'RobotoMedium';
      case UFUFontWeight.bold:
        return 'RobotoBold';
      default:
        return 'RobotoRegular';
    }
  }

  static getMontserratFontFamily(UFUFontWeight fontWeight) {
    switch (fontWeight) {
      case UFUFontWeight.regular:
        return 'MontserratRegular';
      case UFUFontWeight.medium:
        return 'MontserratMedium';
      default:
        return 'MontserratRegular';
    }
  }

  /// Return  fontWeight of a text and default textSize is [UFUFontFamily.regular]
  static FontWeight getFontWeight(UFUFontWeight fontWeight) {
    switch (fontWeight) {
      case UFUFontWeight.regular:
        return FontWeight.w400;
      case UFUFontWeight.medium:
        return FontWeight.w500;
      case UFUFontWeight.bold:
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }

  static TextStyle getTextStyle(Color? textColor, UFUFontWeight? fontWeight, UFUTextSize? textSize, double?  dynamicFontSize, UFUFontFamily? fontFamily,TextOverflow? overflow, double? height, double? letterSpacing,TextDecoration? textDecoration, FontStyle? fontStyle, Color? decorationColor) {
    return TextStyle(
      color: textColor ?? AppTheme.themeColors.text,
      fontSize: dynamicFontSize ?? getTextSize(textSize ?? UFUTextSize.heading4),
      fontFamily: getFontFamily(fontFamily ?? UFUFontFamily.productSans, fontWeight ?? UFUFontWeight.regular),
      package: 'UFU_mobile_flutter_ui',
      overflow: overflow,
      fontWeight: getFontWeight(fontWeight ?? UFUFontWeight.regular),
      height: height,
      decoration: textDecoration,
      decorationColor: decorationColor,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle ?? FontStyle.normal,
    );
  }

}
