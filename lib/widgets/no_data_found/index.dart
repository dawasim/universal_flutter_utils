import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUNoDataFound extends StatelessWidget {
  final String? title;
  final String? descriptions;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? textColor;
  final UFUTextSize? textSize;

  const UFUNoDataFound({
    this.title,
    this.descriptions,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.textColor,
    this.textSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon != null)...{
              UFUIcon(icon!,
                color: (iconColor ?? AppTheme.themeColors.primary).withAlpha(60),
                size: iconSize ?? 90,
              )
            },

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UFUText(
                text: title ?? '',
                textSize: textSize ?? UFUTextSize.heading3,
                textAlign: TextAlign.center,
                fontFamily: UFUFontFamily.productSans,
                fontWeight: UFUFontWeight.medium,
                textColor: textColor,
              ),
            ),
            if(!UFUtils.isValueNullOrEmpty(descriptions))...{
              UFUText(
                text: descriptions ?? '',
                textColor: AppTheme.themeColors.darkGray,
              ),
            }
          ],
        ),
      ),
    );
  }
}
