import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUMultiSelectHeader extends StatelessWidget {
  const UFUMultiSelectHeader({
    required this.title,
    this.searchInputCtrl,
    this.totalAmount,
    this.inputHintText,
    this.canShowSearchBar = false,
    this.onSearch,
    this.headerPrefixChild,
    this.helperText,
    this.canShowSubList = false,
    this.showSubList,
    this.isSelectedSubListItems = false,
    this.isDisabled = false,
    required this.isViewSubList,
    super.key});

  /// Defines title of a multiselect.
  final String title;

  /// Defines hint text of a searchBar of a multiselect.
  final String? inputHintText;

  /// Defines searchBar is added or not of a multiselect.
  final bool canShowSearchBar;

  /// Defines the onSearch method to filter the modified list.
  final ValueChanged<String>? onSearch;

  /// Defines input value of a searchBar of a multiselect.
  final TextEditingController? searchInputCtrl;

  /// Defines to add child in the header at right side of a multiselect.
  final Widget? headerPrefixChild;

  /// helperText can be used to display some info as a helper to user
  final String? helperText;

  /// Defines to show user filter 
  final bool canShowSubList;

  /// Function to show user filter or not.
  final VoidCallback? showSubList;

  /// Define to show subList or not.
  final bool isViewSubList;

  /// Defines that sublist is selected or not.
  final bool isSelectedSubListItems;

  final Widget? totalAmount;

  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UFUResponsiveBuilder(
          tablet: const SizedBox(
            height: 15,
          ),
          mobile: Container(
            height: 4,
            width: 30,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            color: AppTheme.themeColors.inverse,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UFUText(
                    text: title.toUpperCase(),
                    fontWeight: UFUFontWeight.medium,
                    textSize: UFUTextSize.heading3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                ),
              ),
              Row(
                children: [
                  if(totalAmount != null) totalAmount!,
                  canShowSubList ? Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 4,
                            right: 3
                        ),
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(6),
                          color: AppTheme.themeColors.dimGray,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: showSubList,
                            child: UFUIcon(
                              Icons.group_outlined,
                              color: AppTheme.themeColors.tertiary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      if(isSelectedSubListItems) Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: AppTheme.themeColors.success,
                                borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) : headerPrefixChild ?? const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),

        if(helperText != null)
          Container(
          padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 28
          ),
          margin: const EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 15
          ),
          decoration: BoxDecoration(
            color: AppTheme.themeColors.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: UFUText(
            text: helperText!,
            textColor: AppTheme.themeColors.tertiary,
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
              disabled: isDisabled,
              hintText: inputHintText,
              debounceTime: 300,
            ),
          ),
      ],
    );
  }
}
