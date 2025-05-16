import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFULoadMoreButton extends StatelessWidget {
  const UFULoadMoreButton({
    super.key,
    this.isLoadMore = false,
    this.callback
  });

  final bool isLoadMore;

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: UFUButton(
          size: UFUButtonSize.mediumWithIcon,
          text: 'load_more'.tr,
          onPressed: callback,
          iconWidget: isLoadMore
              ? FadingCircle(color: AppTheme.themeColors.base, size: 20)
              : null,
          colorType: UFUButtonColorType.tertiary,
          fontFamily: UFUFontFamily.productSans,
        ));
  }
}
