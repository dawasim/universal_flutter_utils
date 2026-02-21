import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUText extends StatelessWidget {
  const UFUText({
    required this.text,
    this.textSize = UFUTextSize.heading4,
    // this.fontFamily = UFUFontFamily.productSans,
    this.fontWeight = UFUFontWeight.regular,
    this.textColor,
    this.overflow,
    this.textAlign = TextAlign.center,
    this.maxLine,
    this.textDecoration,
    this.decorationColor,
    this.letterSpacing,
    this.dynamicFontSize,
    this.height,
    this.isSelectable = false,
    this.fontStyle = FontStyle.normal,
    super.key});

  /// Defines text of a text.
  final String text;

  /// Defines textSize of a text.
  final UFUTextSize? textSize;

  /// Defines fontFamily of a text.
  // final UFUFontFamily? fontFamily;

  /// Defines fontWeight of a text.
  final UFUFontWeight? fontWeight;

  /// Defines textColor [JPAppTheme.themeColors.text] of a text.
  final Color? textColor;

  /// Defines decorationColor [JPAppTheme.themeColors.text] of a text.
  final Color? decorationColor;

  /// Defines overflow of a text.
  final TextOverflow? overflow;

  /// Defines textAlign of a text.
  final TextAlign textAlign;

  /// Defines maxLine of a text.
  final int? maxLine;

  ///Defines text decoration
  final TextDecoration? textDecoration;

  final double? letterSpacing;

  final double? height;

  final double? dynamicFontSize;

  /// isSelectable makes text interactive, default value is [false]
  final bool isSelectable;

  /// fontStyle give text italic or normal style
  final FontStyle fontStyle;

  String getText(String text) {
    // 1. Clean up HTML entities
    text = text.replaceAll('&amp;', '&');

    // 2. Check if the text contains Arabic characters (Unicode range 0600-06FF)
    bool containsArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    // 3. ONLY apply the \u200B hack if it's NOT Arabic.
    // This hack was likely added to help English text wrap better,
    // but it is "poison" for cursive scripts like Arabic.
    if (overflow != null && !containsArabic) {
      return text.replaceAll('', '\u200B');
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return isSelectable ? SelectableText(
        getText(text),
        enableInteractiveSelection: true,
        textAlign: textAlign,
        maxLines: maxLine,
        selectionControls: MaterialTextSelectionControls(),
        showCursor: false,
        textDirection: UFUtils.isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: TextHelper.getTextStyle(
            textColor,
            fontWeight,
            textSize,
            dynamicFontSize,
            null,
            // fontFamily,
            overflow,
            height,
            letterSpacing,
            textDecoration,
            fontStyle,
            decorationColor)
    ) : Text(
        getText(text),
        textAlign: textAlign,
        maxLines: maxLine,
        textDirection: UFUtils.isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: TextHelper.getTextStyle(
            textColor,
            fontWeight,
            textSize,
            dynamicFontSize,
            null,
            // fontFamily,
            overflow,
            height,
            letterSpacing,
            textDecoration,
            fontStyle,
            decorationColor)
    );
  }
}
