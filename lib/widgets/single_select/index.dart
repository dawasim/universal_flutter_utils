import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';


class UFUSingleSelect extends StatefulWidget {
  const UFUSingleSelect({
    required this.mainList,
    this.selectedItemId,
    this.onItemSelect,
    this.isFilterSheet = false,
    this.inputHintText,
    this.title = 'select option',
    this.canShowIconButton = false,
    this.iconButtonBackgroundColor,
    this.iconButtonBorderRadius,
    this.onIconButtonTap,
    this.iconButtonIcon,
    this.iconButtonIconSize,
    this.iconButtonIconColor,
    this.iconButtonIconWidget,
    this.suffixButtonText,
    this.prefixButtonText,
    this.onTapSuffixBtn,
    this.onTapPrefixBtn,
    this.type = UFUSingleSelectType.local,
    this.isLoading = false,
    this.onLoadMore,
    this.isLoadMore = false,
    this.listLoader,
    this.canShowLoadMore = false,
    this.onSearch,
    this.canShowSearchBar,
    this.showIncludeInactiveButton = false,
    super.key
  });

  //Main list of which will have all elements
  final List<UFUSingleSelectModel> mainList;

  //Selected item id from the list
  final String? selectedItemId;

  final ValueChanged<String>? onItemSelect;

  //Header title
  final String title;

  //For showing single select as filter - Pass true to make it as fiter
  //This will add extra padding from bottom and change draggable scroll behaviour
  final bool isFilterSheet;

  //Placeholder of searchbox
  final String? inputHintText;

  ///   Icon Button Params
  final bool canShowIconButton;
  final Color? iconButtonBackgroundColor;
  final double? iconButtonBorderRadius;
  final VoidCallback? onIconButtonTap;
  final IconData? iconButtonIcon;
  final double? iconButtonIconSize;
  final Color? iconButtonIconColor;
  final Widget? iconButtonIconWidget;

  final String? suffixButtonText;
  final String? prefixButtonText;

  final VoidCallback? onTapSuffixBtn;
  final VoidCallback? onTapPrefixBtn;

  /// type can be used to differentiate between network list and local list
  /// default selected type is [UFUSingleSelectType.local]
  final UFUSingleSelectType type;

  /// In case of network list isLoading helps to manage loading state
  final bool isLoading;

  /// In case of network list canShowMore helps to manage loader state
  final bool canShowLoadMore;

  /// In case of network list isLoading helps to manage load more state
  final bool isLoadMore;

  /// In case of network list isLoading helps to manage searchbar state
  final bool? canShowSearchBar;

  /// In case of network list listLoader is used to display a loading placeholder
  final Widget? listLoader;

  /// In case of network list onLoadMore send a callback to perform further action
  final VoidCallback? onLoadMore;

  /// In case of network list onSearch returns a callback with search keyword to take an action
  final Function(String keyword)? onSearch;

  /// For showing include inactive button 
  final bool showIncludeInactiveButton;

  @override
  _UFUSingleSelectState createState() => _UFUSingleSelectState();
}

class _UFUSingleSelectState extends State<UFUSingleSelect> {
  List<UFUSingleSelectModel> list = [];
  TextEditingController textEditingController = TextEditingController();
  final scrollController = AutoScrollController(
    initialScrollOffset: 0,
  );

  String? selectedItemId;
  bool isVisibile = false;
  // For change include inactive state
  bool includeInactive = false;

  void scrollToIndex() async {
    int index = getList().indexWhere((element) => element.id == selectedItemId);

    await scrollController.scrollToIndex(index,
        duration: const Duration(milliseconds: 100),
        preferPosition: AutoScrollPosition.middle);

    setState(() {
      isVisibile = true;
    });
  }

  /// toggle include inactive value 
  void toggleIncludeInactive() {
    includeInactive = !includeInactive;
    if(list.any((element) => !(element.active ?? true) && widget.selectedItemId == element.id)) {
      selectedItemId = list.first.id;
      widget.onItemSelect!(list.first.id);
    }
    setState(() {});
  }

  /// get list based on inactive or active user
  List<UFUSingleSelectModel> getList () {
    if(widget.showIncludeInactiveButton && list.any((element) => !(element.active ?? true) && widget.selectedItemId == element.id)) {
      includeInactive = true;
    } 
    if (includeInactive) {
      return list;
    } else {
      return list.where((element) => element.active ?? true).toList();
    }
  }

  @override
  void initState() {
    list = widget.mainList;
    selectedItemId = widget.selectedItemId;

    if (widget.type == UFUSingleSelectType.network) {
      // adding a listener in case of network listing
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && widget.onLoadMore != null && !widget.isLoadMore) {
          widget.onLoadMore!();
        }
      });
    }

    isVisibile =
        (!widget.isFilterSheet && widget.mainList.length > 10) ? false : true;

    if (!widget.isFilterSheet && widget.mainList.length > 10) {
      scrollToIndex();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UFUSingleSelectView(
      isVisible: isVisibile,
      list: getList(),
      scrollController: scrollController,
      title: widget.title,
      mainList: widget.mainList,
      searchInputCtrl: textEditingController,
      selectedItemId: selectedItemId,
      isFilterSheet: widget.isFilterSheet,
      inputHintText: widget.inputHintText,
      onSearch: onSearch,
      onSelect: widget.onItemSelect == null ? null : (value) {
        setState(() {
          selectedItemId = value;
        });
        widget.onItemSelect!(value);
      },
      canShowSearchBar: widget.canShowSearchBar,
      canShowIconButton: widget.canShowIconButton,
      iconButtonBackgroundColor: widget.iconButtonBackgroundColor,
      iconButtonBorderRadius: widget.iconButtonBorderRadius,
      onIconButtonTap: widget.onIconButtonTap,
      iconButtonIcon: widget.iconButtonIcon,
      iconButtonIconSize: widget.iconButtonIconSize,
      iconButtonIconColor: widget.iconButtonIconColor,
      iconButtonIconWidget: widget.iconButtonIconWidget,
      suffixButtonText: widget.suffixButtonText,
      prefixButtonText: widget.prefixButtonText,
      onTapPrefixBtn: widget.onTapPrefixBtn,
      onTapSuffixBtn: widget.onTapSuffixBtn,
      type: widget.type,
      canShowLoadMore: widget.canShowLoadMore,
      isLoading: widget.isLoading,
      isLoadMore: widget.isLoadMore,
      listLoader: widget.listLoader,
      onTapIncludeInactiveButton: toggleIncludeInactive,
      showIncludeInactiveButton: widget.showIncludeInactiveButton,
      includeInactive: includeInactive,
    );
  }

  // onSearch() : is used to differentiate working for local list and network list
  void onSearch(String value) async {
    if (widget.type == UFUSingleSelectType.network && widget.onSearch != null) {
      widget.onSearch!(value);
    } else {
      setState(() {
        list = widget.mainList
            .where((element) => element.label
            .trim()
            .toLowerCase()
            .contains(value.trim().toLowerCase()))
            .toList();
      });
    }
  }
}
