import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUIconButton extends StatelessWidget {
  const UFUIconButton({
    super.key,
    this.backgroundColor,
    this.borderRadius = 8,
    this.icon = Icons.add,
    this.iconSize = 18,
    this.iconColor,
    this.highlightColor,
    this.iconWidget,
    this.onTap,
    this.onLongPress,
    this.isDisabled = false
  });

  final Color? backgroundColor;
  final Color? iconColor;
  final Color? highlightColor;
  final double? borderRadius;
  final double? iconSize;
  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppTheme.themeColors.lightBlue,
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
        child: iconWidget ?? UFUTextButton(
          icon: icon ?? Icons.add,
          iconSize: iconSize ?? 18,
          color: iconColor ?? AppTheme.themeColors.primary,
          highlightColor : highlightColor,
          onPressed: onTap,
          onLongPress: onLongPress,
          isDisabled: isDisabled,
        )
    );
  }
}
