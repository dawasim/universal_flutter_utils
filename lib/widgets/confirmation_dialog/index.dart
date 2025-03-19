import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

ShowUFUConfirmationDialog({required String? title, String? subTitle,
  String? prefixBtnText = 'Cancel', String? suffixBtnText = 'Confirm', VoidCallback? onTapPrefix,
  VoidCallback? onTapSuffix, IconData? icon, UFUConfirmationDialogType? type = UFUConfirmationDialogType.message,
  bool disableButtons = false, Widget? suffixBtnIcon, Widget? content,
  UFUButtonColorType? prefixBtnColorType, VoidCallback? onTapIcon,}) async {
  await Get.bottomSheet(
    UFUConfirmationDialog(
      title: title,
      subTitle: subTitle,
      prefixBtnText: prefixBtnText,
      suffixBtnText: suffixBtnText,
      onTapPrefix: onTapPrefix,
      onTapSuffix: onTapSuffix,
      icon: icon,
      type: type ?? UFUConfirmationDialogType.message,
      disableButtons: disableButtons,
      suffixBtnIcon: suffixBtnIcon,
      content: content,
      prefixBtnColorType: prefixBtnColorType,
      onTapIcon: onTapIcon
    ),
    // _buildErrorBottomSheet(title, message, showRetry, retryCallback),
    backgroundColor: AppTheme.themeColors.base,
    isScrollControlled: true,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    // ),
  );
}

class UFUConfirmationDialog extends StatefulWidget {

  const UFUConfirmationDialog({
    super.key,
    required this.title,
    this.subTitle,
    this.prefixBtnText = 'Cancel',
    this.suffixBtnText = 'Confirm',
    this.onTapPrefix,
    this.onTapSuffix,
    this.icon,
    this.type = UFUConfirmationDialogType.message,
    this.disableButtons = false,
    this.suffixBtnIcon,
    this.content,
    this.prefixBtnColorType,
    this.onTapIcon,
    });

  /// It can be used to set title of the dialog, this is required
  final String? title;

  /// It can be used to set subtitle, this is an optional field
  final String? subTitle;

  /// It can be used to set text of the button, one on the left side
  /// default value is [CANCEL]
  final String? prefixBtnText;

  /// It can be used to set text of the button, one on the right side
  final String? suffixBtnText;

  /// It can be used to perform action on click of prefix button,
  /// default action is navigate back
  final VoidCallback? onTapPrefix;

  /// It can be used to perform action on suffix button click
  final VoidCallback? onTapSuffix;

  /// It can be used to set any icon above title of confirmation dialog
  final IconData? icon;

  /// It can be used to display widget inside suffix button
  /// when it is in use suffixText text will hide by default
  final Widget? suffixBtnIcon;

  /// It can be used to specify type of dialog
  final UFUConfirmationDialogType type;

  /// Used to set button color, text color, border color.
  final UFUButtonColorType? prefixBtnColorType;

  final bool disableButtons;

  final Widget? content;

  /// [onTapIcon] can be used to perform click on icon
  final VoidCallback? onTapIcon;

  @override
  UFUConfirmationDialogState createState() => UFUConfirmationDialogState();
}

class UFUConfirmationDialogState extends State<UFUConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height / 1.5,
          bottom: 10
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppTheme.themeColors.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 180,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null)
                          InkWell(
                            onTap: widget.onTapIcon,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppTheme.themeColors.lightBlue),
                              margin: const EdgeInsets.only(bottom: 15, top: 5),
                              padding: const EdgeInsets.all(4),
                              child: UFUIcon(
                                widget.icon!,
                                size: 28,
                                color: AppTheme.themeColors.primary,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: UFUText(
                            text: widget.title!,
                            textSize: UFUTextSize.heading3,
                            fontWeight: UFUFontWeight.medium,
                            fontFamily: UFUFontFamily.productSans,
                          ),
                        ),
                        if (widget.subTitle != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: UFUText(
                              text: widget.subTitle!,
                              textSize: UFUTextSize.heading4,
                              textColor: AppTheme.themeColors.darkGray,
                              height: 1.5,
                            ),
                          ),

                        if(widget.content != null) Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: widget.content!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: getButtons(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getButtons() {
    switch (widget.type) {
      case UFUConfirmationDialogType.alert:
        return cancelBtnOnly();
      default:
        return cancelConfirmBtn();
    }
  }

  // Will return both buttons
  Widget cancelConfirmBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: UFUResponsiveDesign.popOverButtonFlex,
          child: UFUButton(
            text: widget.prefixBtnText?.toUpperCase(),
            textColor: AppTheme.themeColors.primary,
            size: UFUButtonSize.small,
            disabled: widget.disableButtons,
            colorType: UFUButtonColorType.lightGray,
            onPressed: widget.onTapPrefix ??
                () {
                  Navigator.pop(context);
                },
          ),
        ),
        const SizedBox(
          width: 14,
        ),
        Expanded(
          flex: UFUResponsiveDesign.popOverButtonFlex,
          child: UFUButton(
            text: widget.suffixBtnIcon == null
                ? widget.suffixBtnText?.toUpperCase()
                : '',
            textColor: AppTheme.themeColors.base,
            size: UFUButtonSize.small,
            colorType: UFUButtonColorType.primary,
            onPressed: widget.onTapSuffix,
            iconWidget: widget.suffixBtnIcon,
            disabled: widget.disableButtons,
          ),
        ),
      ],
    );
  }

  // Will return single btn in the center
  Widget cancelBtnOnly() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UFUButton(
          text: widget.prefixBtnText?.toUpperCase(),
          textColor: AppTheme.themeColors.text,
          size: UFUButtonSize.small,
          disabled: widget.disableButtons,
          colorType: widget.prefixBtnColorType ?? UFUButtonColorType.lightGray,
          onPressed: widget.onTapPrefix ?? () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
