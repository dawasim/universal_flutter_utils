import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUPopUpMenuButton<T> extends StatelessWidget {

  const UFUPopUpMenuButton({
    Key? key,
    this.popUpMenuButtonChild,
    required this.itemList,
    required this.popUpMenuChild,
    this.offset = Offset.zero,
    this.onTap,
    this.childPadding = EdgeInsets.zero,
    this.toolTip
  }) : super(key: key);

  /// itemList will contain list of items you want to display in popUpMenu
  final List<T> itemList;

  /// popUpMenuChild is a widget that will be displayed when popUpMenu is visible
  final Widget Function(T val) popUpMenuChild;

  /// popUpMenuButtonChild is a widget on clicking it popUpMenu will be displayed
  final Widget? popUpMenuButtonChild;

  /// Offset is used to specify position of popUpMenu
  final Offset offset;

  /// onTap can be used to perform some action on selecting popUpMenu item
  final Function(T val)? onTap;

  /// childPadding can be used to give padding to child
  final EdgeInsets? childPadding;

  /// toolTip is a hint that will be displayed on long press of popup menu
  final String? toolTip;

  @override
  Widget build(BuildContext context) {


    return PopupMenuButton(
      offset: offset,
      child: popUpMenuButtonChild,
      color: AppTheme.themeColors.base,
      itemBuilder: (context) => itemList.map((T e) {
        return PopupMenuItem<T>(
          child: popUpMenuChild(e),
          value: e,
          padding: childPadding,
          height: childPadding!.vertical,
          enabled: onTap != null,

        );
      }).toList(),
      tooltip: toolTip,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: onTap,
    );
  }
}
