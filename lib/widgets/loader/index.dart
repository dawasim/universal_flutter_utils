import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

Future<void> ShowUFULoader({String? msg}) async {
  if (Get.isSnackbarOpen) Get.closeAllSnackbars();
  if (UFUtils.isLoaderVisible()) return;

  Get.generalDialog(
    barrierDismissible: false,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: UFUtils.transitionDuration),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Animations.grow(animation, secondaryAnimation, child);
    },
    pageBuilder: (animation, secondaryAnimation, child) {
      return UFULoader(
        key: UFUtils.ufuLoaderKey,
        text: msg,
      );
    },
  );
}

/// showUFUConfirmationLoader can be used to show loading animation on buttons
/// parameters: show[optional]
/// show:- it is a bool variable which can be used to show or hide loader
///        default value is [false]
Widget? showUFUConfirmationLoader({bool? show = false, double size = 20}) {
  return show! ? SpinKitThreeBounce(color: UFUColor.white, size: size) : null;
}

class UFULoader extends StatelessWidget {
  const UFULoader({
    super.key,
    this.text,
  });

  /// It is used to set loader text
  final String? text;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadingCircle(color: AppTheme.themeColors.primary, size: 40),
          const SizedBox(
            height: 5,
          ),
          if (text != null)
            UFUText(
              text: text!,
              textSize: UFUTextSize.heading5,
              textColor: AppTheme.themeColors.primary,
            ),
        ],
      ),
    );
  }
}
