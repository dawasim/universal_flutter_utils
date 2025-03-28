import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'footer.dart';
import 'header.dart';
import 'list.dart';
import 'modal.dart';

class UFUMultiSelectView extends StatelessWidget {
  const UFUMultiSelectView({
    required this.mainList,
    required this.list,
    this.totalAmount,
    required this.subList,
    this.inputHintText,
    this.title,
    this.onSearch,
    this.canShowSearchBar = false,
    this.searchInputCtrl,
    this.onItemTap,
    this.onSubItemTap,
    this.selectAndClearAll,
    this.onDone,
    this.isFilterSheet = false,
    this.headerPrefixChild,
    this.doneIcon,
    this.disableButtons = false,
    this.canDisableDoneButton = false,
    this.type = UFUMultiSelectType.local,
    this.isLoading = false,
    this.canShowMore = false,
    this.scrollController,
    this.totalNetworkListCount,
    required this.selectedItems,
    this.isSelectedSubListItems,
    this.listLoader,
    this.helperText,
    this.canShowSubList,
    this.showSubList,
    required this.isViewSubList,
    this.subTitleHeader,
    this.tempSelectedItemsCount,
    this.filterListItemsCount,
    this.scrollList,
    this.hideSelectAll = false,
    this.showIncludeInactiveButton = false,
    this.onTapIncludeInactiveButton,
    this.includeInactive = false,
    super.key});

  /// Defines modified list which is copy from mailList using modal class UFUMultiSelectModal of a multiselect.
  final List<UFUMultiSelectModel> list;

  /// Defines subList using modal class UFUMultiSelectModal of a multiselect.
  final List<UFUMultiSelectModel> subList;

  /// Defines mainList using modal class UFUMultiSelectModal of a multiselect.
  final List<UFUMultiSelectModel> mainList;

  /// Defines title of a multiselect.
  final String? title;

  /// Defines the onSearch method to filter the modified list.
  final ValueChanged<String>? onSearch;

  /// Defines searchBar is added or not of a multiselect.
  final bool canShowSearchBar;

  /// Define controller of a searchBar of a multiselect.
  final TextEditingController? searchInputCtrl;

  /// Defines hint text of a searchbox.
  final String? inputHintText;

  /// Defines to filter list of multiselect.
  final bool isFilterSheet;

  /// Defines to add child in the header at right side of a multiselect.
  final Widget? headerPrefixChild;

  /// This method is call when we select the item in a multiselect.
  final ValueChanged<String>? onItemTap;

  final ValueChanged<String>? onSubItemTap;

  /// This method is call when we clear or select complete list.
  final VoidCallback? selectAndClearAll;

  /// This method is used when onDone callback it is use to return updated list.
  final VoidCallback? onDone;

  final Widget? doneIcon;

  final bool disableButtons;

  final bool canDisableDoneButton;

  /// type can be used to differentiate between network list and local list
  /// default selected type is [UFUMultiSelectType.local]
  final UFUMultiSelectType type;

  /// In case of network list isLoading helps to manage loading state
  final bool isLoading;

  /// In case of network list canShowMore helps to manage loader state
  final bool canShowMore;

  /// In case of network list, scrollController helps in load-more
  final ScrollController? scrollController;

  /// In case of network list totalNetworkListCount is used to display
  /// number of total available items
  final int? totalNetworkListCount;

  final List<UFUMultiSelectModel> selectedItems;

  /// Defines that sublist is selected or not.
  final bool? isSelectedSubListItems;

  /// In case of network list listLoader is used to display a loading placeholder
  final Widget? listLoader;

  /// helperText can be used to display some info as a helper to user
  final String? helperText;

  /// Defines to show user filter
  final bool? canShowSubList;

  /// Function to show user filter or not.
  final VoidCallback? showSubList;

  /// Define to show subList or not.
  final bool isViewSubList;

  /// Defines sub list title.
  final String? subTitleHeader;

  /// Defines tempSelected item count of a filterList.
  final int? tempSelectedItemsCount;

  /// Defines filterList item count of a list.
  final int? filterListItemsCount;
  final ScrollController? scrollList;

  final Widget? totalAmount;

  /// Can be used to hide `Select All/Clear All` option
  final bool hideSelectAll;

  final bool showIncludeInactiveButton;

  final bool includeInactive;

  final VoidCallback? onTapIncludeInactiveButton;


  double getHeight(BuildContext context, {double? ratio}) {
    return MediaQuery.of(context).size.height * (ratio ?? 0.85);
  }

  double getsubListHeight() {
    return (41 * subList.length) + 50;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(
          maxHeight: list.isEmpty && subList.isEmpty? getHeight(context, ratio: 0.65) : getHeight(context),
        ),
        child: getView(context));
  }

  Widget getView(BuildContext context) {
    int getSelectedItemCount() {
      if(showIncludeInactiveButton && !includeInactive) {
       return mainList.where((element) => element.isSelect && (element.active ?? true)).length;
      }
      return mainList.where((element) => element.isSelect).length;
    }
    int mainListLength () {
      if(showIncludeInactiveButton && !includeInactive) {
        return mainList.where((element) => element.active ?? true).length;
      }
      return totalNetworkListCount ?? mainList.length;
    }

    Widget selectionList = UFUMultiSelectList(
      controller: scrollController,
      list: list,
      onItemTap: onItemTap,
      canShowMore: canShowMore,
      isLoading: isLoading,
      type: type,
      listLoader: listLoader,
      searchKeyWord: searchInputCtrl?.text ?? '',
      showInactiveUserLabel: showIncludeInactiveButton,
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      padding: UFUResponsiveDesign.popOverBottomInsets,
      child: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: type == UFUMultiSelectType.network || UFUScreen.isTablet
              ? 0 :
          MediaQuery.of(context).size.height * 0.05,
          bottom: isFilterSheet && !UFUScreen.hasBottomPadding ? 20 : 0,
        ),
        decoration: BoxDecoration(
            borderRadius: getBorderRadius(),
            color: AppTheme.themeColors.themeBlue),
        child: SafeArea(
          top: true,
          bottom: !isFilterSheet,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UFUMultiSelectHeader(
                totalAmount: totalAmount,
                inputHintText: inputHintText,
                canShowSearchBar: type == UFUMultiSelectType.network || (searchInputCtrl?.text.isNotEmpty ?? false) ? true : !isFilterSheet && mainList.length > 8,
                title: title!,
                searchInputCtrl: searchInputCtrl,
                onSearch: onSearch,
                headerPrefixChild: headerPrefixChild,
                canShowSubList: canShowSubList ?? false,
                helperText: helperText,
                showSubList: showSubList,
                isViewSubList: isViewSubList,
                isSelectedSubListItems: isSelectedSubListItems ?? false,
              ),
              UFUMultiSelectSubHeader(
                mainListLength:  mainListLength(),
                listLength: list.length,
                canShowClearAll: !(hideSelectAll || searchInputCtrl!.text.isNotEmpty),
                selectedItemCount: getSelectedItemCount(),
                selectAndClearAll: selectAndClearAll,
                canShowCount: list.isNotEmpty || selectedItems.where((element) => element.isSelect).isNotEmpty,
                tempSelectedItemsCount: tempSelectedItemsCount,
                filterListItemsCount: filterListItemsCount,
                isViewSubList: isViewSubList,
                subList: subList,
                showIncludeInactiveButton: showIncludeInactiveButton,
                includeInactive: includeInactive,
                onTapIncludeInactiveButton: onTapIncludeInactiveButton,
              ),

              if(type == UFUMultiSelectType.network) ...{
                Flexible(
                  child: selectionList,
                ),
              } else ...{
                Flexible(
                  child: SingleChildScrollView(
                    controller: type != UFUMultiSelectType.local ? scrollController : scrollList,
                    child: Column(
                      children: [
                        if (isViewSubList && subList.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 200),
                              tween: Tween<double>(begin: 0, end: getsubListHeight()),
                              builder: (BuildContext context, dynamic value,Widget? child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeColors.dimGray.withAlpha(50),
                                        borderRadius: BorderRadius.circular(8)),
                                    constraints: BoxConstraints(maxHeight: value),
                                    child: UFUMultiSelectSubList(
                                      controller: scrollController,
                                      subList: subList,
                                      onSubItemTap: onSubItemTap,
                                      canShowMore: canShowMore,
                                      isLoading: isLoading,
                                      type: type,
                                      listLoader: listLoader,
                                      subTitleHeader: subTitleHeader ?? 'user groups',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        selectionList,
                      ],
                    ),
                  ),
                ),
              },

              UFUMultiSelectFooter(
                disableButtons: disableButtons,
                canDisableDoneButton: canDisableDoneButton,
                doneIcon: doneIcon,
                selectedItemCount: getSelectedItemCount(),
                callBack: (String action) {
                  if (action == 'done') {
                    onDone!();
                    return;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius getBorderRadius() {
    if(isFilterSheet) {
      return BorderRadius.circular(20);
    } else {
      return UFUResponsiveDesign.bottomSheetRadius;
    }
  }

}
