import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'thumb_size.dart';

class UFUThumbFolder extends StatelessWidget {
  const UFUThumbFolder({this.size, super.key});

  /// It is used to set size of folder thumb as [ThumbSize.large]
  final ThumbSize? size;

  double getHeight() {
    switch (size) {
      case ThumbSize.small:
        return 25;
      case ThumbSize.large:
        return 71;
      default:
        return 71;
    }
  }

  double getWidth() {
    switch (size) {
      case ThumbSize.small:
        return 30;
      case ThumbSize.large:
        return 87;
      default:
        return 87;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: getWidth(),
        maxHeight: getHeight(),
      ),
      child: SvgPicture.asset(
        'assets/folder.svg',
        package: 'UFU_mobile_flutter_ui',
      ),
    );
  }
}
