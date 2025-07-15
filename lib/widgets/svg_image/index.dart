import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UFUSvgImage extends StatelessWidget {
  const UFUSvgImage({
    super.key,
    required this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.none,
    this.colorFilter,
    this.isRtl
  });

  final String assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final bool? isRtl;

  @override
  Widget build(BuildContext context) {

    bool isWithRtl = isRtl ?? Directionality.of(context) == TextDirection.rtl;

    if(Directionality.of(context) == TextDirection.rtl && isRtl == true) isWithRtl = false;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(isWithRtl ? -1.0 : 1.0, 1.0),
      child: SvgPicture.asset(
        assetPath,
        height: height,
        width: width,
        fit: fit,
        colorFilter: colorFilter,
      ),
    );
  }
}