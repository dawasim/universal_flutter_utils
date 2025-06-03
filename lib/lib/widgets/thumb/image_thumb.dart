import 'package:flutter/material.dart';
import 'thumb_size.dart';

class UFUThumbImage extends StatelessWidget {
  const UFUThumbImage({
    this.thumbImage,
    this.size,
    this.borderRadius,
    super.key
  });

  /// It is used to set size of image thumb as [ThumbSize.large]
  final ThumbSize? size;

  /// It is used to set image of thumbImage of a thumb.
  final Widget? thumbImage;

  /// It is used to set borderRadius of thumbImage
  final BorderRadius? borderRadius;

  double getHeight() {
    switch (size) {
      case ThumbSize.small:
        return 30;
      case ThumbSize.large:
        return 110;
      default:
        return double.maxFinite;
    }
  }

  double getWidth() {
    switch (size) {
      case ThumbSize.small:
        return 30;
      case ThumbSize.large:
        return 141;
      default:
        return double.maxFinite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: getWidth(),
        maxHeight: getHeight(),
      ),
      child: ClipRRect(
          borderRadius: borderRadius ?? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: thumbImage ??
              Image.asset(
                'assets/images/default_image.png',
                package: 'UFU_mobile_flutter_ui',
                width: getWidth(),
                height: getHeight(),
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
