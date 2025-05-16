import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUResponsiveBuilder extends StatelessWidget {

  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const UFUResponsiveBuilder({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop
  });

  @override
  Widget build(BuildContext context) {
    switch (UFUScreen.type) {

      case DeviceType.mobile:
        return mobile ?? const SizedBox();

      case DeviceType.tablet:
        return tablet ?? mobile ?? const SizedBox();

      case DeviceType.desktop:
        return desktop ?? tablet ?? const SizedBox();

      default:
        return mobile ?? const SizedBox();
    }
  }
}

// ignore: must_be_immutable
class UFULayoutBuilder extends StatelessWidget {
  UFULayoutBuilder({
    super.key,
    required this.child,
    this.onUpdate,
  }) {
    // TODO: implement
    throw UnimplementedError();
  }

  final Widget child;

  final VoidCallback? onUpdate;

  DeviceType type = UFUScreen.type;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        updateOrientation(constraints);
        if(constraints.maxWidth > UFUResponsiveDesign.minimumDesktopWidth) {
          type = DeviceType.desktop;
          update();
          return child;
        } else if(constraints.maxWidth > UFUResponsiveDesign.minimumTabletWidth) {
          type = DeviceType.tablet;
          update();
          return child;
        } else {
          type = DeviceType.mobile;
          update();
          return child;
        }
      },
    );
  }

  void update() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(type != UFUScreen.type) {
        UFUScreen.type = type;
        onUpdate?.call();
      }
    });
  }

  void updateOrientation(BoxConstraints constraints) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      final tempOrientation = constraints.maxWidth > constraints.maxHeight
          ? Orientation.landscape
          : Orientation.portrait;

      if(tempOrientation != UFUScreen.orientation) {
        UFUScreen.orientation = tempOrientation;
        onUpdate?.call();
      }
    });
  }

}

