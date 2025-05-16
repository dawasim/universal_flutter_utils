import 'package:flutter/material.dart';

class UFUScaleInOutAnim extends StatelessWidget {
  const UFUScaleInOutAnim({
    super.key,
    this.duration,
    required this.firstChildKey,
    required this.firstChild,
    this.forward = true,
    this.secondChild,
    this.secondChildKey,
    });

  /// It can be used to set duration of animation
  /// default is [300ms]
  final Duration? duration;

  /// first child key is the key of first child and it is required parameter
  final String firstChildKey;

  /// second child key is the key of second child and it is required parameter
  final String? secondChildKey;

  /// first child will be displayed by default with out animating
  final Widget firstChild;

  /// second child will be displayed on animating
  final Widget? secondChild;

  /// It is used to animate between firstChild and secondChild
  /// value [true] will show first child and [false] will show secondChild
  final bool? forward;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(anim),
        child: child,
      ),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: forward!
          ? SizedBox(
              key: ValueKey(firstChildKey),
              child: firstChild,
            )
          : SizedBox(
        key: ValueKey(secondChildKey),
        child: secondChild,
      ),
    );
  }
}
