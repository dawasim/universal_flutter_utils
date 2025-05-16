import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';


class UFUCheckbox extends StatelessWidget {
  const UFUCheckbox({
    this.disabled = false,
    this.isTextClickable = true,
    this.selected = false,
    this.text,
    this.textSize = UFUTextSize.heading4,
    this.textColor,
    this.fontFamily = UFUFontFamily.productSans,
    this.fontWeight = UFUFontWeight.regular,
    this.borderColor,
    this.color,
    this.position = UFUPosition.start,
    this.checkColor,
    this.height = 17.0,
    this.width = 17.0,
    this.onTap,
    this.padding,
    this.separatorWidth = 8.5,
    super.key});

  /// Defines enabled or disabled of a checkbox.
  final bool disabled;

  /// Defines text is clickable or not of a checkbox.
  final bool? isTextClickable;

  /// Defines selection of a checkbox.
  final bool? selected;

  /// Defines text of a checkbox.
  final String? text;

  /// Defines textColor[AppTheme.themeColors.text] of a checkbox.
  final Color? textColor;

  /// Defines text fontFamily[UFUFontFamily.roboto] of a checkbox.
  final UFUFontFamily? fontFamily;

  /// Defines text fontWeight[UFUFontWeight.regular] of a checkbox.
  final UFUFontWeight? fontWeight;

  /// Defines text textSize[UFUTextSize.heading4] of a checkbox.
  final UFUTextSize? textSize;

  /// Defines borderColor [AppTheme.themeColors.text] of a checkbox.
  final Color? borderColor;

  /// Defines checkBoxColor [AppTheme.themeColors.primary] of a checkbox.
  final Color? color;

  /// Defines checkbox position [UFUPosition.start] with related to text of a checkbox.
  final UFUPosition? position;

  /// Defines checkColor [AppTheme.themeColors.base] of a checkbox.
  final Color? checkColor;

  /// Defines width of a checkbox.
  final double? width;

  /// Defines height of a checkbox.
  final double? height;

  /// Defines onTap function on text of a checkbox.
  final ValueChanged<bool>? onTap;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry? padding;

  /// separatorWidth can be used to give space between checkbox and title, default width is 8.5
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    late Color? textColors;
    late Color? borderColors;
    late Color? colors;

    textColors = textColor ?? AppTheme.themeColors.text;
    borderColors = borderColor ?? AppTheme.themeColors.text;
    colors = color ?? AppTheme.themeColors.themeGreen;

    ///Defines border of a checkbox.
    getBorder() {
      return Border.all(
          color: disabled ? borderColors!.withValues(alpha:0.5) : borderColors!,
          width: 1);
    }

    ///Defines text widget of a checkbox.
    Widget getText() {
      getColor() {
        return disabled ? textColors!.withValues(alpha:0.4) : textColors;
      }

      return UFUText(
        text: text!,
        textColor: getColor(),
        textSize: textSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        textAlign: TextAlign.start,
      );
    }

    ///Defines checkbox widget of a checkbox.
    ///InkWell is used when isTextClickable method of a checkbox.
    Widget getCheckBox() {
      getColor() {
        return selected!
            ? (disabled ? colors!.withValues(alpha:0.5) : colors)
            : Colors.white;
      }

      return InkWell(
        borderRadius: BorderRadius.circular(50),
        highlightColor: AppTheme.themeColors.primary.withValues(alpha:0.1),
        onTap: disabled ? null : () => onTap!(selected!),
        child: SizedBox(
          height: 32,
          width: 32,
          child: Center(
            child: AnimatedContainer(
              height: height,
              width: width,
              curve: Curves.linear,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: getColor(),
                border: selected! ? null : getBorder(),
              ),
              duration: const Duration(milliseconds: 1),
              child: Center(
                  child: UFUIcon(
                    Icons.check,
                    color: checkColor ?? AppTheme.themeColors.base,
                    size: 14,
                  )),
            ),
          ),
        ),
      );
    }

    /// Defines Fitted box Widget
    getFittedBoxData() {
      if (text == null) {
        return getCheckBox();
      }

      if (position == UFUPosition.end) {
        return Row(
          children: [
            getText(),
            SizedBox(
              width: separatorWidth,
            ),
            getCheckBox(),
          ],
        );
      }
      return Row(
        children: [
          getCheckBox(),
          SizedBox(
            width: separatorWidth,
          ),
          getText(),
        ],
      );
    }

    return GestureDetector(
      onTap: disabled
          ? null
          : (isTextClickable!
          ? () {
        onTap!(selected!);
      }
          : null),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: FittedBox(fit: BoxFit.scaleDown, child: getFittedBoxData()),
      ),
    );
  }
}

