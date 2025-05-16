import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUTextButton extends StatelessWidget {
  const UFUTextButton({
    this.text,
    this.onPressed,
    this.onLongPress,
    this.highlightColor,
    this.icon,
    this.iconPosition = UFUPosition.end,
    this.fontFamily,
    this.fontWeight,
    this.color,
    this.padding = 5,
    this.paddingInsets,
    this.textSize = UFUTextSize.heading3,
    this.textDecoration,
    this.decorationColor,
    this.iconSize = 16,
    this.isExpanded = false,
    this.isDisabled = false,
    super.key,
  });

  // Defines text used in textbutton
  final String? text;

  // Defines fontFamily of text used in textButton
  final UFUFontFamily? fontFamily;

  // Defines fontweight of text used in textbutton
  final UFUFontWeight? fontWeight;

  // Defines color of text and icon used in textbutton
  final Color? color;

  // Defines padding of container
  final double padding;

  // Defines color of text and icon used in textbutton
  final UFUTextSize? textSize;

  // Define icon used in textbutton
  final IconData? icon;

  // Defines iconWidget position before or after text.
  final UFUPosition? iconPosition;

  // Define size of icon used in textbutton
  final double? iconSize;

  // Defines highlightColor of inkewwl used for ripple color effect
  final Color? highlightColor;

  // Called when the icon and text is tapped .
  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final TextDecoration? textDecoration;

  final Color? decorationColor;

  // Can be used to adjust width of button as per content
  final bool isExpanded;

  // Can be used to disable button, default value is false
  final bool isDisabled;

  final EdgeInsets? paddingInsets;

  // Defines text of textbutton and return UFUText values
  Widget getText() {
    if (text == null) return const SizedBox.shrink();

    Widget buttonText = UFUText(
      text: text!,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      textColor: color ?? AppTheme.themeColors.text,
      textDecoration: textDecoration,
      decorationColor: decorationColor,
      overflow: TextOverflow.ellipsis,
      textSize: textSize,
    );

    if (icon != null) {
      return Flexible(child: buttonText);
    }

    return buttonText;
  }

  // Defines icon of textbutton and return IconData properties
  Widget getIcon() {
    if (icon == null) return const SizedBox.shrink();

    return UFUIcon(
      icon!,
      size: iconSize,
      color: color ?? AppTheme.themeColors.text,
    );
  }

  //returning icon and text according to positions
  Widget getIconAndText() {
    if (iconPosition == UFUPosition.start) {
      return Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [getIcon(), getText()],
      );
    }
    return Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [getText(), getIcon()],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color defaultColor = color ?? AppTheme.themeColors.text;

    return InkWell(
      onTap: isDisabled ? null : onPressed,
      onLongPress: onLongPress,
      highlightColor: highlightColor ?? defaultColor.withValues(alpha:0.1),
      splashColor: highlightColor ?? defaultColor.withValues(alpha:0.1),
      borderRadius: BorderRadius.circular(text != null ? 5 : 10),
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1,
        child: Container(
          padding: EdgeInsets.all(padding),
          child: getIconAndText()
        ),
    )
    );
  }
}
