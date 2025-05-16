import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UFUSvgImage extends StatelessWidget {
  const UFUSvgImage({
    super.key,
    required this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.none,
    this.colorFilter
  });

  final String assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      colorFilter: colorFilter,
    );
  }
}