import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'modal.dart';

class UFUMultiSelectList extends StatelessWidget {
  const UFUMultiSelectList({
    this.controller,
    required this.list,
    this.onItemTap,
    this.isLoading = false,
    this.canShowMore = false,
    this.type = UFUMultiSelectType.local,
    this.listLoader,
    this.searchKeyWord = '',
    this.showInactiveUserLabel = false,
    super.key});

  /// Defines the scroll controller of a draggable list.
  final ScrollController? controller;

  /// Defines modified list which is copy from mailList using modal class UFUMultiSelectModal of a multiselect.
  final List<UFUMultiSelectModel> list;

  /// This method is call when we select the item in a multiselect.
  final ValueChanged<String>? onItemTap;

  /// In case of network list isLoading helps to manage loading state
  final bool isLoading;

  /// In case of network list canShowMore helps to manage loader state
  final bool canShowMore;

  /// type can be used to differentiate between network list and local list
  /// default selected type is [UFUMultiSelectType.local]
  final UFUMultiSelectType type;

  /// In case of network list listLoader is used to display a loading placeholder
  final Widget? listLoader;

  /// Search keyword helps to filter list
  final String searchKeyWord;

  /// Helps to show inactive user label
  final bool showInactiveUserLabel;

  @override
  Widget build(BuildContext context) {
    if(type == UFUMultiSelectType.network && isLoading) {
      return SizedBox(
        child: listLoader ?? SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: FadingCircle(
                color: AppTheme.themeColors.primary,
                size: 25),
          ),
        ),
      );
    } else if (list.isEmpty || !isAnyItemVisible()) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: UFUText(
            text: 'No record found',
            textSize: UFUTextSize.heading4,
          ));
    } else {
      return ListView.builder(
          controller: controller,
          itemCount: getItemCount(),
          padding: const EdgeInsets.symmetric(
              vertical: 6
          ),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            if(index < list.length) {
              return getSelectionTile(index);
            } else if(index >= list.length && canShowMore && type == UFUMultiSelectType.network) {
              return Center(
                child: FadingCircle(
                    color: AppTheme.themeColors.primary,
                    size: 25),
              );
            } else {
              return const SizedBox();
            }
          });
    }
  }

  int getItemCount() {
    if(type == UFUMultiSelectType.network) {
      return list.length + 1;
    }
    return list.length;
  }

  Widget getSelectionTile(int index) {
    return Visibility(
      visible: searchKeyWord.isEmpty || list[index].label.toLowerCase().contains(searchKeyWord.toLowerCase()),
      child: Material(
        color: AppTheme.themeColors.themeBlue,
        child: InkWell(
          onTap: list[index].isDisabled ? null : () {
            onItemTap!(list[index].id);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            height: list[index].isDisabled ? 45 : 41,
            padding: const EdgeInsets.only(left: 20, right: 5),
            color: list[index].isDisabled ? UFUColor.lightGray : UFUColor.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          list[index].child != null
                              ? Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: UFUAvatar(
                              child: list[index].child,
                              borderColor: list[index].borderColor ??
                                  UFUColor.transparent,
                              backgroundColor: list[index].color,
                              size: UFUAvatarSize.small,
                            ),
                          )
                              : const SizedBox.shrink(),
                          Flexible(child: Row(
                            children: [
                              if(list[index].prefixLabel != null) ...{
                                UFUText(text: list[index].prefixLabel!, overflow: TextOverflow.ellipsis, fontWeight: UFUFontWeight.medium,),
                              },
                              Flexible(
                                  child: UFUText(text: list[index].label,overflow: TextOverflow.ellipsis,),
                              ),
                              if((!(list[index].active ?? true) && showInactiveUserLabel))
                               UFUText(
                                text: ' (Inactive)', 
                                textColor: AppTheme.themeColors.red, 
                                overflow: TextOverflow.ellipsis,
                              ), 
                              if(list[index].suffixLabel != null) ...{
                                const SizedBox(width: 5),
                                UFUText(text: list[index].suffixLabel!, textSize: UFUTextSize.heading4, overflow: TextOverflow.ellipsis, textColor: AppTheme.themeColors.secondaryText),
                              }
                            ],
                          )),
                        ],
                      ),
                      if(list[index].isDisabled) ...{
                        const SizedBox(height: 2,),
                        UFUText(
                          text: list[index].disableMessage ?? '', 
                          textColor: AppTheme.themeColors.darkGray,
                          textSize: UFUTextSize.heading5,
                        ),
                      }
                    ],
                  ),
                ),
                UFUCheckbox(
                  selected: list[index].isSelect,
                  onTap: list[index].isDisabled ? null : (value) {
                    onItemTap!(list[index].id);
                  },
                  disabled: list[index].isDisabled,
                  borderColor: AppTheme.themeColors.themeGreen,
                  color: AppTheme.themeColors.themeGreen,
                  checkColor: AppTheme.themeColors.base,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isAnyItemVisible() {
    return list.any((element) => element.label.toLowerCase().contains(searchKeyWord.toLowerCase()));
  }

}
