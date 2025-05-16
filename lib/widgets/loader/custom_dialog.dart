import 'package:flutter/material.dart';

// CustomDialog withholds properties on alert dialog,
// it is implemented to have dynamic/adjustable dialog size as per content

class CustomDialog extends StatelessWidget {

  const CustomDialog({
    super.key,
    this.shape = _shape,
    this.child,
    this.elevation = 24,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(24),
    this.insetDuration = const Duration(milliseconds: 100)
  });

  /// It is used to shape dialog
  final ShapeBorder shape;

  /// It is used to set child of CustomDialog
  final Widget? child;

  /// It is used to give shadow to CustomDialog
  final double elevation;

  /// It is used to specify the position of CustomDialog
  final Alignment alignment;

  /// It is used to give padding to the child of CustomDialog
  final EdgeInsets padding;

  /// It is used to give margin to CustomDialog
  final EdgeInsets margin;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  final Duration insetDuration;

  /// This is used to initialize shape of CustomDialog
  static const _shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)));


  @override
  Widget build(BuildContext context) {

    return AnimatedPadding(
      padding: margin,
      duration: insetDuration,
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 0),
          child: Material(
            color: Theme.of(context).dialogBackgroundColor, // Picks dialog color as per theme
            elevation: elevation,
            shape: shape,
            type: MaterialType.card,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}