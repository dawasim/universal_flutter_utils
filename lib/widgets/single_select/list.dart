import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUSingleSelectList extends StatelessWidget {
  const UFUSingleSelectList({
    required this.list,
    this.scrollController,
    this.selectedItemId,
    this.onSelect,
    this.type = UFUSingleSelectType.local,
    this.isLoading = false,
    this.isLoadMore = false,
    this.listLoader,
    this.canShowLoadMore = false,
    this.showInActiveUserLabel = false,
      super.key});

  //List which renders
  final List<UFUSingleSelectModel> list;

  //Selected item id from the list
  final String? selectedItemId;

  final ValueChanged<String>? onSelect;

  final AutoScrollController? scrollController;

  /// type can be used to differentiate between network list and local list
  /// default selected type is [UFUSingleSelectType.local]
  final UFUSingleSelectType type;

  /// In case of network list isLoading helps to manage loading state
  final bool isLoading;

  /// In case of network list isLoading helps to manage load more state
  final bool isLoadMore;

  /// In case of network list listLoader is used to display a loading placeholder
  final Widget? listLoader;

  /// In case of network list canShowMore helps to manage loader state
  final bool canShowLoadMore;

  /// To show inactive users label in the list view
  final bool showInActiveUserLabel;

  @override
  Widget build(BuildContext context) {

    if(type == UFUSingleSelectType.network && isLoading) {
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
    } else if (list.isEmpty) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: UFUText(
            text: 'No record found',
            textSize: UFUTextSize.heading4,
          ),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 10),
        controller: scrollController,
        itemCount: getItemCount(),
        separatorBuilder: (_, index) => const SizedBox(height: 5,),
        itemBuilder: (_, index) => getItem(index)
      );
    }
  }

  Widget subTitle(int index) => Container(
        height: 36,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: UFUColor.transparent,
        alignment: Alignment.centerLeft,
        child: UFUText(
            text: list[index].label,
            textColor: AppTheme.themeColors.secondaryText,
            textSize: UFUTextSize.heading5),
      );

  Widget items(int index) => InkWell(
        onTap: (list[index].onTapItem) ??
            (onSelect != null
                ? () {
                    onSelect!(list[index].id);
                  }
                : null),
        child: Container(
          height: 36,
          padding: const EdgeInsets.only(left: 20, right: 20),
          color: list[index].id == selectedItemId
              ? AppTheme.themeColors.draft
              : UFUColor.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    list[index].child != null || list[index].color != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: UFUAvatar(
                            borderColor: list[index].borderColor ?? UFUColor.transparent,
                            backgroundColor: list[index].color,
                            borderWidth: list[index].borderWidth,
                            size: UFUAvatarSize.small,
                            child: list[index].child ?? const SizedBox(),
                          ),
                        )
                      : const SizedBox.shrink(),
                    Flexible(
                      child: UFUText(
                        text: list[index].label,
                        overflow: TextOverflow.ellipsis
                      )
                    ),
                    if((!(list[index].active ?? true) && showInActiveUserLabel))
                    UFUText(
                    text: ' (Inactive)', 
                    textColor: AppTheme.themeColors.red, 
                    overflow: TextOverflow.ellipsis,
                  ), 

                  ],
                ),
              ),
              if (list[index].suffix != null)
                list[index].suffix ?? const SizedBox(),
              if (list[index].id == selectedItemId)
                UFUIcon(Icons.done, color: AppTheme.themeColors.primary)
            ],
          ),
        ),
      );

  int getItemCount() {
    if(type == UFUSingleSelectType.network) {
      return list.length + 1;
    }
    return list.length;
  }

  Widget getItem(int index) {

    if(index < list.length) {
      return AutoScrollTag(
        index: index,
        key: Key(index.toString()),
        controller: scrollController!,
        child: Material(
          color: UFUColor.transparent,
          child: list[index].id == "sub_title"
              ? subTitle(index)
              : items(index),
        ),
      );
    } else if(index >= list.length && canShowLoadMore && type == UFUSingleSelectType.network) {
      return Center(
        child: FadingCircle(
            color: AppTheme.themeColors.primary,
            size: 25),
      );
    } else {
      return const SizedBox();
    }
  }

}
