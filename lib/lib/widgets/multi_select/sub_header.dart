import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUMultiSelectSubHeader extends StatelessWidget {
  const UFUMultiSelectSubHeader({
    required this.mainListLength,
    this.listLength = 0,
    this.selectedItemCount,
    this.canShowClearAll = true,
    this.canShowCount = true,
    this.selectAndClearAll,
    this.tempSelectedItemsCount,
    this.isViewSubList = false,
    this.filterListItemsCount,
    this.subList = const [],
    this.isDisabled = false,
    this.showIncludeInactiveButton = false,
    this.includeInactive = false,
    this.onTapIncludeInactiveButton,
    super.key});

  /// Defines the mainList length of a multiselect.
  final int mainListLength;

  /// Defines the list length of a multiselect.
  final int? listLength;

  /// Defines selected item count of a multiselect.
  final int? selectedItemCount;

  /// It is use to select all and clear all in one click of a multiSelect.
  final VoidCallback? selectAndClearAll;

  /// It is used to show clearAll button or not.
  final bool canShowClearAll;

  /// It is used to show count or not.
  final bool canShowCount;
  
  /// Defines tempSelected item count of a filterList.
  final int? tempSelectedItemsCount;

  /// Defines filterList item count of a list.
  final int? filterListItemsCount;

  /// Function to show user filter or not.
  final bool isViewSubList;

  final List<UFUMultiSelectModel> subList;

  final bool isDisabled;

  /// Used to show includeInactive button or not.
  final bool showIncludeInactiveButton;

  /// Used to show includeInactive text or excludeInactive.
  final bool includeInactive;

  /// Function to handle tap of includeInactive button 
  final VoidCallback? onTapIncludeInactiveButton;


  Widget getSelectListLength() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4
      ),
      child: UFUText(
        text: '$selectedItemCount/$mainListLength',
        textColor: AppTheme.themeColors.secondaryText,
      ),
    );
  }

  Widget getIcon() {
    if (selectedItemCount == 0) {
      return const SizedBox.shrink();
    }
    if (selectedItemCount == mainListLength) {
      return UFUIcon(
        Icons.check,
        color: AppTheme.themeColors.base,
        size: 14,
      );
    }
    if(isViewSubList){
      if (subList.where((element) => element.isSelect).isNotEmpty){
      if(filterListItemsCount == tempSelectedItemsCount){
         return UFUIcon(
          Icons.check,
          color: AppTheme.themeColors.base,
          size: 14,
      );
      } else if(tempSelectedItemsCount == 0) {
        return const SizedBox.shrink();
      } else {
        return UFUIcon(
          Icons.remove,
          size: 14,
          color: AppTheme.themeColors.base,
    );
      }
    }
    }
    return UFUIcon(
      Icons.remove,
      size: 14,
      color: AppTheme.themeColors.base,
    );
  }
  String getText(){
    if(selectedItemCount == 0){
      return 'Select All';
    }
    if(subList.where((element) => element.isSelect).isNotEmpty){
      if(tempSelectedItemsCount == 0){
        return 'Select All';
      } else {
        return 'Clear All';
      }
    } 
    return 'Clear All';
  }

  Color getColor(){
    if(selectedItemCount == 0) {
      return AppTheme.themeColors.base;
    }
    if(isViewSubList){
      if(subList.where((element) => element.isSelect).isNotEmpty ){
        if(tempSelectedItemsCount == 0){
          return AppTheme.themeColors.base;
        }
      return AppTheme.themeColors.themeGreen;
    }
    }
    return AppTheme.themeColors.themeGreen;
  }

  Widget getSelectAndClearList() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10
      ),
      child: Material(
        color: UFUColor.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: isDisabled ? null : (){
            selectAndClearAll!();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 5, 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: UFUText(
                    text: getText(),
                    textColor: AppTheme.themeColors.secondaryText,
                    textSize: UFUTextSize.heading4,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Opacity(
                  opacity: isDisabled ? 0.4 : 1,
                  child: Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        color: getColor(),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppTheme.themeColors.themeGreen,
                          width: 1.0,
                        )),
                    child: getIcon(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 6, top: 4, bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(canShowCount) getSelectListLength(),
          Visibility(
            visible: showIncludeInactiveButton,
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Material(
                color: UFUColor.transparent,
                child: UFUTextButton(
                  onPressed: onTapIncludeInactiveButton,
                  text: includeInactive ? 'Exclude Inactive' : 'Include Inactive', 
                  textSize: UFUTextSize.heading4, 
                  color: AppTheme.themeColors.primary,
                ),
              ),
            ),
          ),
          const Spacer(),
          (canShowClearAll && mainListLength > 0) ? ((listLength! > 0) ? getSelectAndClearList() : const SizedBox.shrink()) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
