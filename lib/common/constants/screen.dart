
import 'package:flutter/cupertino.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';


class UFUScreen {

  static MediaQueryData mediaQueryData = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);

  static final double _screenWidth = mediaQueryData.size.width;

  static final double _screenHeight = mediaQueryData.size.height;

  static Orientation orientation = Orientation.portrait;

  static DeviceType type = getScreenType();

  static bool get hasBottomPadding => mediaQueryData.padding.bottom > 0;

  static bool get isTablet => type == DeviceType.tablet;

  static bool get isMobile => type == DeviceType.mobile;

  static bool get isDesktop => type == DeviceType.desktop;

  static bool get isSmallWidthMobile => isMobile && width < UFUResponsiveDesign.maxSmallMobileWidth;

  static bool get isSmallHeightMobile => isMobile && height < UFUResponsiveDesign.smallDeviceHeight;

  static double height = _screenHeight;
  static double width = _screenWidth;

  static double get maxWidth => width <= 1200 ? 1200 : width;

  static bool get doForceRefershOnLayoutChange => (isMobile && height > 500) || (isTablet && height > 350);

  static Future<void> setDimensions(GlobalKey key) async {

    if (key.currentContext == null) return;

      RenderBox? box = key.currentContext!.findRenderObject() as RenderBox?;

        height = box?.size.height ?? _screenHeight;
        width = box?.size.width ?? _screenWidth;
  }

  static DeviceType getScreenType() {
    if(UFUScreen.width > UFUResponsiveDesign.minimumDesktopWidth) {
      return DeviceType.desktop;
    } else if(UFUScreen.width > UFUResponsiveDesign.minimumTabletWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }
}