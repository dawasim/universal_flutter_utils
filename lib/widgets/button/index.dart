import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUButton extends StatelessWidget {
  const UFUButton({
    this.disabled = false,
    this.colorType = UFUButtonColorType.primary,
    this.gradient,
    this.opacity = 1,
    this.onPressed,
    this.onLongPress,
    this.iconWidget,
    this.suffixIconWidget,
    this.text,
    this.size = UFUButtonSize.flat,
    this.textColor,
    // this.fontFamily = UFUFontFamily.poppins,
    this.fontWeight = UFUFontWeight.bold,
    this.textSize = UFUTextSize.heading3,
    this.type = UFUButtonType.solid,
    this.width,
    this.isFlat = true,
    this.buttonRadius = UFUButtonRadius.roundSquare,
    this.radius,
    this.bgColor,
    super.key,
  });

  /// Defines enabled or disabled of a button.
  final bool disabled;

  /// Used to set button color, text color, border color.
  final UFUButtonColorType colorType;

  /// The [gradient] is drawn under the [image].
  final Gradient? gradient;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  /// For showing icon with button text
  final Widget? iconWidget;

  /// For showing icon on last with button text
  final Widget? suffixIconWidget;

  /// Defines text of a button.
  final String? text;

  /// Defines text color of a button.
  final Color? textColor;

  /// Defines text size of a button.
  final UFUTextSize? textSize;

  /// Defines text font family of a button.
  // final UFUFontFamily fontFamily;

  /// Defines font weight of a button.
  final UFUFontWeight fontWeight;

  /// Defines size of a button.
  final UFUButtonSize size;

  /// Defines type of a button.
  final UFUButtonType? type;

  ///Used for change opacity of button background.
  final double opacity;

  /// Defines width of a button.
  final double? width;

  final bool isFlat;

  final UFUButtonRadius? buttonRadius;

  final double? radius;

  final Color? bgColor;

  /// Return textSize by using button size and default size is [UFUTextSize.heading3].
  UFUTextSize getTextSize(UFUButtonSize size) {
    switch (size) {
      case UFUButtonSize.flat:
      case UFUButtonSize.large:
        return UFUTextSize.heading3;
      case UFUButtonSize.medium:
      case UFUButtonSize.small:
        return UFUTextSize.heading4;
      case UFUButtonSize.mediumWithIcon:
      case UFUButtonSize.extraSmall:
        return (textSize != UFUTextSize.heading4)
            ? textSize ?? UFUTextSize.heading3
            : UFUTextSize.heading3;
      case UFUButtonSize.datePickerButton:
      case UFUButtonSize.size24:
        return UFUTextSize.heading5;
      default:
        return UFUTextSize.heading3;
    }
  }

  /// Return Color by using colorType and default color is [AppTheme.themeColors.base] but for outline button default color is [AppTheme.themeColors.primary].
  Color getTextColor(UFUButtonColorType colorType) {
    Color color = AppTheme.themeColors.base;

    if(textColor != null) return textColor!;

    switch (colorType) {
      case UFUButtonColorType.primary:
        color = (type == UFUButtonType.outline)
            ? AppTheme.themeColors.themeBlue
            : AppTheme.themeColors.base;
        break;

      case UFUButtonColorType.tertiary:
        color = (type == UFUButtonType.outline)
            ? AppTheme.themeColors.tertiary
            : AppTheme.themeColors.base;
        break;

      case UFUButtonColorType.secondaryLight:
        color = (type == UFUButtonType.outline)
            ? AppTheme.themeColors.inverse
            : AppTheme.themeColors.text;
        break;

      case UFUButtonColorType.lightGray:
        color = textColor ?? AppTheme.themeColors.primary;
        break;

      case UFUButtonColorType.base:
        color = textColor ?? AppTheme.themeColors.text;
        break;

      default:
        color = textColor ?? AppTheme.themeColors.base;
        break;
    }

    return disabled ? color.withValues(alpha: 0.4) : color;
  }

  /// Return Color  by using colorType and default color is [AppTheme.themeColors.primary] but for outline button color is [UFUColor.transparent].
  Color getButtonColor(UFUButtonColorType colorType) {

    if (type == UFUButtonType.outline) {
      return UFUColor.transparent;
    }

    Color color = AppTheme.themeColors.secondary;
    if (bgColor != null) return bgColor!;

    switch (colorType) {
      case UFUButtonColorType.primary:
        color = size == UFUButtonSize.floatingButton
            ? AppTheme.themeColors.themeBlue
            : AppTheme.themeColors.primary;
        break;

      case UFUButtonColorType.tertiary:
        color = AppTheme.themeColors.tertiary;
        break;

      case UFUButtonColorType.lightGray:
        color = AppTheme.themeColors.inverse;
        break;

      case UFUButtonColorType.lightBlue:
        color = Color(0XFF0BA544);
        break;

      case UFUButtonColorType.secondary:
        color = AppTheme.themeColors.secondary;
        break;

      case UFUButtonColorType.secondaryLight:
        color = AppTheme.themeColors.secondaryLight;
        break;

      case UFUButtonColorType.transparent:
        color = UFUColor.transparent;
        break;

      case UFUButtonColorType.gradient:
        color = UFUColor.transparent;
        break;

      case UFUButtonColorType.base:
        color = AppTheme.themeColors.base;
        break;

      // default:
      //   color = AppTheme.themeColors.primary;
      //   break;
    }

    color = color.withValues(alpha: opacity);

    return disabled ? color.withValues(alpha: 0.4) : color;
  }

  /// Return Color by using colorType and default color is [AppTheme.themeColors.primary].
  Color getBorderColor(UFUButtonColorType colorType) {
    switch (colorType) {
      case UFUButtonColorType.primary:
        return AppTheme.themeColors.themeBlue;

      case UFUButtonColorType.tertiary:
        return AppTheme.themeColors.tertiary;

      case UFUButtonColorType.lightGray:
        return AppTheme.themeColors.inverse;

      case UFUButtonColorType.base:
        return AppTheme.themeColors.base;

      case UFUButtonColorType.gradient:
        return AppTheme.themeColors.base;

      default:
        return AppTheme.themeColors.primary;
    }
  }

  /// Return double by using button size and default size is flat.
  double getButtonHeight(UFUButtonSize size) {
    switch (size) {
      case UFUButtonSize.flat:
      case UFUButtonSize.large:
        return 52.0;

      case UFUButtonSize.medium:
        return 46.0;

      case UFUButtonSize.small:
        return 42.0;

      case UFUButtonSize.datePickerButton:
      case UFUButtonSize.extraSmall:
        return 26.0;

      case UFUButtonSize.mediumWithIcon:
        return 38.0;

      case UFUButtonSize.smallIcon:
        return 26;

      case UFUButtonSize.floatingButton:
        return 62;

      case UFUButtonSize.size24:
        return 24;

      // default:
      //   return 52.0;
    }
  }

  ///Returning highlight color
  Color getHighlightColor(UFUButtonColorType colorType) {
    switch (colorType) {
      case UFUButtonColorType.primary:
        return AppTheme.themeColors.primary.withValues(alpha: 0.2);
      case UFUButtonColorType.tertiary:
        return AppTheme.themeColors.tertiary.withValues(alpha: 0.2);
      case UFUButtonColorType.lightGray:
        return AppTheme.themeColors.inverse.withValues(alpha: 0.2);
      case UFUButtonColorType.lightBlue:
        return AppTheme.themeColors.lightBlue.withValues(alpha: 0.2);
      case UFUButtonColorType.secondary:
        return AppTheme.themeColors.primary.withValues(alpha: 0.2);
      default:
        return AppTheme.themeColors.primary.withValues(alpha: 0.2);
    }
  }

  double shapeRadius() {
    switch (buttonRadius) {
      case UFUButtonRadius.circular:
        return 50;
      case UFUButtonRadius.roundSquare:
        return radius ?? 12;
      default:
        return radius ?? 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    ShapeBorder shapeBorderType;
    ShapeBorder? borderShape;

    ///Returning min width of button based on size
    BoxConstraints getConstraintForFlatButton() {
      switch (size) {
        case UFUButtonSize.flat:
        case UFUButtonSize.large:
        case UFUButtonSize.medium:
        case UFUButtonSize.small:
          return width != null
              ? BoxConstraints(
                  minWidth: width ?? 0,
                )
              : BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                );

        case UFUButtonSize.datePickerButton:
        case UFUButtonSize.extraSmall:
          return const BoxConstraints(
            minWidth: 60.0,
          );

        case UFUButtonSize.mediumWithIcon:
          return const BoxConstraints(
            minWidth: 120.0,
          );

        case UFUButtonSize.smallIcon:
          return const BoxConstraints(
            minWidth: 26.0,
          );

        case UFUButtonSize.floatingButton:
          return const BoxConstraints(
            minWidth: 62.0,
          );

        default:
          return BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          );
      }
    }

    BoxConstraints getConstraint() {
      switch (size) {
        case UFUButtonSize.flat:
          return BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          );
        case UFUButtonSize.large:
        case UFUButtonSize.medium:
          return const BoxConstraints(
              minWidth: 250.0, maxWidth: UFUResponsiveDesign.maxButtonWidth);
        case UFUButtonSize.small:
          return const BoxConstraints(
              minWidth: 150.0, maxWidth: UFUResponsiveDesign.maxButtonWidth);

        case UFUButtonSize.size24:
          return const BoxConstraints(
              minWidth: 60.0, maxWidth: UFUResponsiveDesign.maxButtonWidth);

        case UFUButtonSize.datePickerButton:
        case UFUButtonSize.extraSmall:
          return const BoxConstraints(
            minWidth: 60.0,
          );

        case UFUButtonSize.mediumWithIcon:
          return const BoxConstraints(
            minWidth: 120.0,
          );

        case UFUButtonSize.smallIcon:
          return const BoxConstraints(
            minWidth: 26.0,
          );

        case UFUButtonSize.floatingButton:
          return const BoxConstraints(
            minWidth: 62.0,
          );

        // default:
        //   return BoxConstraints(
        //     minWidth: MediaQuery.of(context).size.width,
        //   );
      }
    }

    final BorderSide shapeBorder = BorderSide(
      width: (type == UFUButtonType.outline) ? 1.0 : 0.0,
      color: (type == UFUButtonType.outline)
          ? getBorderColor(colorType)
          : UFUColor.transparent,
    );

    if (size == UFUButtonSize.smallIcon) {
      shapeBorderType = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      );
    } else if (size == UFUButtonSize.datePickerButton) {
      shapeBorderType = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      );
    } else {
      shapeBorderType = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(shapeRadius()),
        side: shapeBorder,
      );
    }

    final result = Material(
      shape: shapeBorderType,
      type: MaterialType.button,
      color: Colors.transparent, //getButtonColor(colorType),
      child: Ink(
        decoration: BoxDecoration(
            color: colorType == UFUButtonColorType.gradient
                ? null
                : getButtonColor(colorType),
            gradient: colorType == UFUButtonColorType.gradient
                ? gradient ?? UFUtils.buttonGradient
                : null,
            borderRadius: BorderRadius.circular(shapeRadius())),
        child: InkWell(
          splashColor: Colors.transparent,
          onLongPress: onLongPress,
          highlightColor: getHighlightColor(colorType),
          customBorder: borderShape ?? shapeBorderType,
          onTap: disabled ? null : onPressed,
          child: Container(
              width: width,
              constraints:
                  isFlat ? getConstraint() : getConstraintForFlatButton(),
              height: getButtonHeight(size),
              padding: EdgeInsets.symmetric(
                  horizontal: (iconWidget == null &&
                          suffixIconWidget == null &&
                          text != null)
                      ? 10
                      : 5),
              child: getContainerData()),
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      enabled: disabled,
      child: result,
    );
  }

  /// Defines icon widget
  Widget getIcon() {
    if (iconWidget == null) return const SizedBox.shrink();
    return iconWidget!;
  }

  Widget getSuffixIcon() {
    if (suffixIconWidget == null) return const SizedBox.shrink();
    return suffixIconWidget!;
  }

  /// Defines text widget
  Widget getText() {
    if (text == null && iconWidget != null) {
      return const SizedBox.shrink();
    }
    return UFUText(
      text: text ?? 'Default',
      // fontFamily: fontFamily,
      height: 1,
      fontWeight: fontWeight,
      textColor: getTextColor(colorType),
      textSize: getTextSize(size),
    );
  }

  /// Defines child widget of a container
  Widget getContainerData() {
    List<Widget> rowChildren = <Widget>[
      getIcon(),
      (iconWidget != null && text != null)
          ? const SizedBox(
              width: 4,
            )
          : const SizedBox.shrink(),
      getText(),
      (suffixIconWidget != null && text != null)
          ? const SizedBox(
              width: 4,
            )
          : const SizedBox.shrink(),
      getSuffixIcon(),
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ),
    );
  }
}
