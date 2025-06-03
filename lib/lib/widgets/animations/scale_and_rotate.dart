import 'package:flutter/material.dart';

class UFUScaleAndRotateAnim extends StatelessWidget {
  const UFUScaleAndRotateAnim({
    super.key,
    this.duration,
    required this.firstChildKey,
    required this.secondChildKey,
    required this.firstChild,
    required this.secondChild,
    this.forward = true});

  /// It can be used to set duration of animation
  /// default is [300ms]
  final Duration? duration;

  /// first child key is the key of first child and it is required parameter
  final String firstChildKey;

  /// second child key is the key of second child and it is required parameter
  final String secondChildKey;

  /// first child will be displayed by default with out animating
  final Widget firstChild;

  /// second child will be displayed on animating
  final Widget secondChild;

  /// It is used to animate between firstChild and secondChild
  /// value [true] will show first child and [false] will show secondChild
  final bool? forward;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? const Duration(milliseconds: 500),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: child.key == ValueKey(firstChildKey)
            ? Tween<double>(begin: 0, end: 1).animate(anim)
            : Tween<double>(begin: 1, end: 0).animate(anim),
        child: ScaleTransition(scale: anim, child: child),
      ),
      child: forward!
          ? SizedBox(key: ValueKey(firstChildKey), child: firstChild)
          : SizedBox(key: ValueKey(secondChildKey), child: secondChild),
    );
  }
}
