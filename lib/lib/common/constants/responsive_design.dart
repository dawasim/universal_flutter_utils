import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUResponsiveDesign {

  static const double minimumTabletWidth = 600;
  static const double minimumDesktopWidth = 900;
  static const double maxSmallMobileWidth = 400;

  static const double maxSizeMenuWidth = 360;

  static const double maxButtonWidth = 500;

  static const double smallDeviceHeight = 670;

  static const double maxPopOverWidth = 550;
  static double get maxPopOverHeight => 800;
  static const double floatingButtonSize = 80;

  static EdgeInsets get popOverBottomInsets => getPopOverBottomInsets();

  static BorderRadius get bottomSheetRadius => getBottomSheetBorderRadius();

  static int get popOverButtonFlex => getPopOverButtonFlex();

  static EdgeInsets get floatingButtonPadding => const EdgeInsets.only(
      bottom: UFUResponsiveDesign.floatingButtonSize
  );

  static BorderRadius getBottomSheetBorderRadius() {
    switch (UFUScreen.type) {
      case DeviceType.mobile:
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        );

      case DeviceType.tablet:
      case DeviceType.desktop:
        return BorderRadius.circular(20);
    }
  }

  static int getPopOverButtonFlex() {
    switch (UFUScreen.type) {
      case DeviceType.mobile:
        return 1;

      case DeviceType.desktop:
      case DeviceType.tablet:
        return 0;
    }
  }

  static EdgeInsets getPopOverBottomInsets() {
    switch (UFUScreen.type) {
      case DeviceType.mobile:
        return EdgeInsets.zero;

      case DeviceType.desktop:
      case DeviceType.tablet:
        final bottom = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first)
                .viewInsets
                .bottom -
            50;
        return EdgeInsets.only(
          bottom: bottom >= 0 ? bottom : 0,
        );
    }
  }
}
