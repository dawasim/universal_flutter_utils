import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUMultiSelectFooter extends StatelessWidget {
  const UFUMultiSelectFooter({
    required this.callBack,
    this.doneIcon,
    this.disableButtons = false,
    this.canDisableDoneButton = false,
    this.selectedItemCount,
    this.suffixTitle = 'done',
    super.key,
  });

  /// This method is used when onDone callback it is use to return updated list.
  final ValueChanged<String> callBack;
  
  final Widget? doneIcon;

  final bool disableButtons;
  final bool canDisableDoneButton;

  /// Defines selected item count of a multiselect.
  final int? selectedItemCount;

  final String? suffixTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, UFUScreen.hasBottomPadding && UFUScreen.isMobile ? 10 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: UFUResponsiveDesign.popOverButtonFlex,
            child: UFUButton(
              onPressed: () {
                callBack('cancel');
              },
              size: UFUButtonSize.small,
              disabled: disableButtons,
              text: 'CANCEL',
              textColor: AppTheme.themeColors.themeBlue,
              colorType: UFUButtonColorType.lightGray,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            flex: UFUResponsiveDesign.popOverButtonFlex,
            child: UFUButton(
              text: doneIcon == null ? suffixTitle!.toUpperCase() : '',
              onPressed: () {
                callBack('done');
              },
              size: UFUButtonSize.small,
              iconWidget: doneIcon,
              disabled: disableButtons || (selectedItemCount == 0 && canDisableDoneButton),
              textColor: AppTheme.themeColors.text,
              colorType: UFUButtonColorType.primary,
            ),
          )
        ],
      ),
    );
  }
}
