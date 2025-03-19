import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUSingleSelectHeader extends StatelessWidget {
  const UFUSingleSelectHeader({
    required this.title,
    this.searchInputCtrl,
    this.inputHintText,
    this.canShowSearchBar = false,
    this.onSearch,
    this.canShowIconButton = false,
    this.iconButtonBackgroundColor,
    this.iconButtonBorderRadius,
    this.onIconButtonTap,
    this.iconButtonIcon,
    this.iconButtonIconColor,
    this.iconButtonIconSize,
    this.iconButtonIconWidget,
    this.suffixChild,
    this.isDisabled = false,
    this.showIncludeInactiveButton = false,
    this.onTapIncludeInactiveButton,
    this.includeInactive = false,
    super.key});

  //Single select header title
  final String title;

  //Placeholder of searchBox
  final String? inputHintText;

  final bool canShowSearchBar;

  // final bool isDraggable;

  final ValueChanged<String>? onSearch;

  final TextEditingController? searchInputCtrl;

  ///   Icon Button Params
  final bool canShowIconButton;
  final Color? iconButtonBackgroundColor;
  final double? iconButtonBorderRadius;
  final VoidCallback? onIconButtonTap;
  final IconData? iconButtonIcon;
  final double? iconButtonIconSize;
  final Color? iconButtonIconColor;
  final Widget? iconButtonIconWidget;
  final Widget? suffixChild;
  final bool isDisabled;
  
  /// For show include inactive button or not
  final bool showIncludeInactiveButton;
  
  /// Funtion for perform action on include inactive button click
  final VoidCallback? onTapIncludeInactiveButton;
  
  /// For change include inactive status
  final bool includeInactive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UFUResponsiveBuilder(
          mobile: Container(
              height: 4,
              width: 30,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
          ),
          tablet: const SizedBox(height: 20,),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: UFUText(
                  text: title,
                  fontWeight: UFUFontWeight.bold,
                  textSize: UFUTextSize.heading3
                )
              ),

              if(suffixChild != null) suffixChild!,

              Visibility(
              visible: showIncludeInactiveButton,
                child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: UFUTextButton(
                onPressed: onTapIncludeInactiveButton,
                text:  includeInactive ? 'Exclude Inactive' : 'Include Inactive', 
                textSize: UFUTextSize.heading4, 
                color: AppTheme.themeColors.primary,
              ),
            ),
          ),
              if(canShowIconButton)
                UFUIconButton(
                  backgroundColor: iconButtonBackgroundColor,
                  borderRadius: iconButtonBorderRadius,
                  onTap: onIconButtonTap,
                  icon: iconButtonIcon,
                  iconSize: iconButtonIconSize,
                  iconColor: iconButtonIconColor,
                  iconWidget: iconButtonIconWidget,
                )
            ],
          ),
        ),

        if (canShowSearchBar)
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
            child: UFUInputBox(
              controller: searchInputCtrl,
              fillColor: AppTheme.themeColors.base,
              type: UFUInputBoxType.searchbar,
              onChanged: onSearch,
              hintText: inputHintText,
              disabled: isDisabled,
              debounceTime: 500,
            ),
          ),
      ],
    );
  }
}
