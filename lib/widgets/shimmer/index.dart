import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUShimmer extends StatelessWidget {
  const UFUShimmer({
    super.key,
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 700), //Default value
      interval: const Duration(milliseconds: 700), //Default value: Duration(seconds: 0)
      color: AppTheme.themeColors.base, //Default value
      colorOpacity: 1, //Default value
      enabled: true, //Default value
      direction: const ShimmerDirection.fromLTRB(),  //Default Value
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: AppTheme.themeColors.inverse,
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}
