import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUAvatar extends StatelessWidget {
  const UFUAvatar({
    this.height,
    this.width,
    this.radius = 50.0,
    this.borderColor,
    this.isDashedBorder,
    this.dashLength,
    this.size,
    this.backgroundColor = UFUColor.transparent,
    this.child,
    this.borderWidth,
    super.key});

  /// Defines width of avatar
  final double? width;

  /// Defines height of avatar
  final double? height;

  /// Defines radius of avatar
  final double radius;

  /// Defines borderColor [UFUColor.transparent] of avatar
  final Color? borderColor;

  /// Defines if border is dashed border of avatar
  final bool? isDashedBorder;

  /// Defines the length of a dash for border of avatar
  final double? dashLength;

  /// Defines borderWidth of avatar
  final double? borderWidth;

  /// Defines size [UFUAvatarSize.medium] of avatar
  final UFUAvatarSize? size;

  /// Defines backgroundColor [UFUColor.transparent] of avatar
  final Color? backgroundColor;

  /// Defines child widget of a avatar
  /// We can add icon,images etc. in this child
  /// like.... Icon(Icons.person);
  /// like.... image.network('');
  final Widget? child;

  /// Defines size [UFUAvatarSize.medium] of a avatar
  getSize() {
    switch (size) {
      case UFUAvatarSize.extraLarge:
        return 128.0;
      case UFUAvatarSize.size_72x72:
        return 72.0;
      case UFUAvatarSize.size_30x30:
        return 30.0;
      case UFUAvatarSize.large:
        return 42.0;
      case UFUAvatarSize.medium:
        return 36.0;
      case UFUAvatarSize.small:
        return 24.0;
      default:
        return 36.0;
    }
  }

  /// Defines default size of default icon of a avatar
  getDefaultIconSize() {
    switch (size) {
      case UFUAvatarSize.extraLarge:
        return 100.0;
      case UFUAvatarSize.size_72x72:
        return 65.0;
      case UFUAvatarSize.size_30x30:
        return 30.0;
      case UFUAvatarSize.large:
        return 40.0;
      case UFUAvatarSize.medium:
        return 30.0;
      case UFUAvatarSize.small:
        return 20.0;
      default:
        return 30.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? getSize(),
      height: height ?? getSize(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size == UFUAvatarSize.extraLarge ? 100.0 : radius),
        color: backgroundColor,
        border: (isDashedBorder ?? false)
          ? UFUDashedBorder.fromBorderSide(dashLength: dashLength ?? 0, side: BorderSide(
              color: borderColor ?? AppTheme.themeColors.primary, width: borderWidth ?? 0))
          : (borderColor != null)
            ? Border.all(color: borderColor!, width: borderWidth ?? 0.0,)
            : null),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            (size == UFUAvatarSize.extraLarge) ? 100.0 : radius),
        child: Center(
          child: child ??
              UFUIcon(
                Icons.person,
                size: getDefaultIconSize(),
                color: AppTheme.themeColors.dimGray,
              ),
        ),
      ),
    );
  }
}
