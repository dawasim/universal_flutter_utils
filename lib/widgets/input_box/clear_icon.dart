
import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUInputBoxClearIcon extends StatelessWidget {
  const UFUInputBoxClearIcon({
    super.key,
    this.cancelButtonColor,
    this.cancelButtonSize = 22,
    required this.type
  });

  final Color? cancelButtonColor;

  final double? cancelButtonSize;

  final UFUInputBoxType type;

  @override
  Widget build(BuildContext context) {

    switch(type) {
      case UFUInputBoxType.withLabelAndClearIcon:
        return Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: cancelButtonColor ?? AppTheme.themeColors.secondaryText
            )
          ),
          child: UFUIcon(
            Icons.clear,
            size: 15,
            color: AppTheme.themeColors.secondary,
          ),
        );

      case UFUInputBoxType.searchbarWithoutBorder:
        return UFUIcon(
          Icons.cancel,
          color: cancelButtonColor ?? AppTheme.themeColors.secondaryText,
          size: cancelButtonSize,
        );

      default:
        return const SizedBox();
    }
  }
}
