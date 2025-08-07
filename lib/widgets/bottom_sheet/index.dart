import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUPopUpBuilder extends StatelessWidget {
  const UFUPopUpBuilder({
    super.key,
    required this.child,
    this.allowFullWidth = false,
    this.enableInsets = false
  });

  final bool allowFullWidth;
  final bool enableInsets;
  final Widget Function(UFUBottomSheetController controller) child;

  Widget get popOverChild => GetBuilder<UFUBottomSheetController>(
      init: UFUBottomSheetController(),
      global: false,
      builder: (controller) {
        return child(controller);
      });

  @override
  Widget build(BuildContext context) {
    switch (UFUScreen.type) {
      case DeviceType.mobile:
        return popOverChild;

      case DeviceType.desktop:
      case DeviceType.tablet:
        return Center(
          child: AnimatedPadding(
            padding: !enableInsets
                ? EdgeInsets.zero
                : MediaQuery.of(context).viewInsets +
                    const EdgeInsets.only(bottom: 20),
            duration: const Duration(milliseconds: 50),
            child: Container(
              constraints: allowFullWidth
                  ? null
                  : BoxConstraints(
                      maxWidth: UFUResponsiveDesign.maxPopOverWidth,
                      minWidth: UFUResponsiveDesign.maxPopOverWidth,
                      maxHeight: UFUResponsiveDesign.maxPopOverHeight),
              child: Material(
                color: UFUColor.transparent,
                child: popOverChild,
              ),
            ),
          ),
        );
      // default:
      //   return popOverChild;
    }
  }
}

/// showUFUBottomSheet can be used when we have to perform loading
/// but we don't have controller for managing our loading state
/// a default controller will be provided with it and loading
/// state can be toggled easily by [controller.toggleIsLoading()]
Future<dynamic> ShowUFUBottomSheet({
  required Widget Function(UFUBottomSheetController controller) child,
  bool isScrollControlled = false,
  bool ignoreSafeArea = true,
  bool isDismissible = true,
  bool enableDrag = false,
  bool allowFullWidth = false,
  bool enableInsets = false}) async {

  // Avoiding dialog and bottom sheet opening in unit testing
  if (RunModeService.isUnitTestMode) return;

  if (!UFUScreen.isMobile) {
    return await showUFUDialog(
        child: child,
        allowFullWidth: allowFullWidth,
        enableInsets: enableInsets);
  } else {
    return await Get.bottomSheet(
      UFUPopUpBuilder(
        child: child,
      ),
      
      isScrollControlled: isScrollControlled,
      ignoreSafeArea: ignoreSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      enterBottomSheetDuration: const Duration(milliseconds: UFUtils.transitionDuration),
      exitBottomSheetDuration: const Duration(milliseconds: UFUtils.transitionDuration),
    );
  }
}

Future<dynamic> showUFUDialog({
  required Widget Function(UFUBottomSheetController controller) child,
  bool allowFullWidth = false,
  bool enableInsets = false,
}) async {

  // Avoiding dialog and bottom sheet opening in unit testing
  if (RunModeService.isUnitTestMode) return;

  return await Get.dialog(
    UFUPopUpBuilder(
      child: (controller) => Center(
        child: Material(
          color: Colors.transparent,
          child: child.call(controller))),
      allowFullWidth: allowFullWidth,
      enableInsets: enableInsets,
    ),
    transitionDuration: const Duration(milliseconds: UFUtils.transitionDuration),
  );
}

Future<dynamic> showUFUGeneralDialog({
  required Widget Function(UFUBottomSheetController controller) child,
  Widget? secondChild,
  bool? isDismissible = true,
  bool allowFullWidth = false,
}) async {

  // Avoiding dialog and bottom sheet opening in unit testing
  if (RunModeService.isUnitTestMode) return;

  Widget persistentChild = UFUPopUpBuilder(child: child);

  if (!UFUScreen.isMobile) {
    return await showUFUDialog(child: child, allowFullWidth: allowFullWidth);
  } else {
    return await Get.generalDialog(
        barrierDismissible: isDismissible ?? false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: UFUtils.transitionDuration),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return Animations.fromBottom(animation, secondaryAnimation, child);
        },
        pageBuilder: (animation, secondaryAnimation, child) {
          return persistentChild;
        });
  }
}
