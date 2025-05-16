// ignore: file_names
import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'modal.dart';

class UFUMultiSelectSubList extends StatelessWidget {
  const UFUMultiSelectSubList({
    this.controller,
    required this.subList,
    this.onSubItemTap,
    this.isLoading = false,
    this.canShowMore = false,
    this.type = UFUMultiSelectType.local,
    this.listLoader,
    this.searchKeyWord = '',
    required this.subTitleHeader,
    super.key});

  /// Defines the scroll controller of a draggable list.
  final ScrollController? controller;

  /// Defines modified list which is copy from mailList using modal class UFUMultiSelectModal of a multiselect.
  final List<UFUMultiSelectModel> subList;

  /// This method is call when we select the item in a multiselect.
  final ValueChanged<String>? onSubItemTap;

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

  /// Defines sub list title.
  final String subTitleHeader;

  @override
  Widget build(BuildContext context) {
    if(type == UFUMultiSelectType.network && isLoading) {
      return listLoader ?? SizedBox(
        height: 150,
        child: Center(
          child: FadingCircle(
              color: AppTheme.themeColors.primary,
              size: 25),
        ),
      );
    } else if (subList.isEmpty || !isAnyItemVisible()) {
      return const SizedBox.shrink();
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 15),
              child: UFUText(
                    text: subTitleHeader.toUpperCase()+' (${subList.length})',
                    fontWeight: UFUFontWeight.medium,
                    textAlign: TextAlign.left,
                    textSize: UFUTextSize.heading4),
            ),
            ListView.builder(
                controller: controller,
                itemCount: getItemCount(),
                padding: const EdgeInsets.symmetric(
                    vertical: 6
                ),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  if(index < subList.length) {
                    return getSelectionTile(index);
                  } else if(index >= subList.length && canShowMore && type == UFUMultiSelectType.network) {
                    return Center(
                      child: FadingCircle(
                          color: AppTheme.themeColors.primary,
                          size: 25),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ),
      );
    }
  }

  int getItemCount() {
    if(type == UFUMultiSelectType.network) {
      return subList.length + 1;
    }
    return subList.length;
  }

  Widget getSelectionTile(int index) {
    return Visibility(
      visible: searchKeyWord.isEmpty || subList[index].label.toLowerCase().contains(searchKeyWord),
      child: Material(
        color: UFUColor.transparent,
        child: InkWell(
          onTap: () {
            onSubItemTap!(subList[index].id);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            height: 41,
            padding: const EdgeInsets.only(left: 20, right: 5),
            color: UFUColor.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: UFUText(text: subList[index].label,overflow: TextOverflow.ellipsis,)),
                UFUCheckbox(
                  selected: subList[index].isSelect,
                  onTap: (value) {
                    onSubItemTap!(subList[index].id);
                  },
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
    return subList.any((element) => element.label.toLowerCase().contains(searchKeyWord));
  }

}
