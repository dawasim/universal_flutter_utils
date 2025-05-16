import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUMultiSelect extends StatefulWidget {
  const UFUMultiSelect({
    required this.mainList,
    this.inputHintText,
    this.totalAmount,
    this.updateTotalAmount,
    this.isFilterSheet = false,
    this.title = 'Select option',
    this.onDone,
    this.doneIcon,
    this.disableButtons = false,
    this.canDisableDoneButton = false,
    this.headerPrefixChild,
    this.type = UFUMultiSelectType.local,
    this.isLoading = false,
    this.onLoadMore,
    this.isLoadMore = false,
    this.onSearch,
    this.totalNetworkListCount,
    this.listLoader,
    this.initialSelectionsForNetworkList,
    this.canShowLoadMore = false,
    this.helperText,
    this.subList,
    this.canShowSubList,
    this.showSubList,
    this.subTitleHeader,
    this.maxSelection,
    this.onMaxSelectionReached,
    this.showIncludeInactiveButton = false,
    this.onTapItem,
    this.hideSelectAll = false,
    super.key,
  });

  /// Defines the mainList list of a multiselect.
  final List<UFUMultiSelectModel> mainList;

  /// Defines the subList list of a multiselect.
  final List<UFUMultiSelectModel>? subList;

  /// Defines title of a multiselect.
  final String title;

  /// Defines to filter list of multiselect.
  final bool isFilterSheet;

  /// Defines to filter list of multiselect.
  final String? inputHintText;

  /// Defines to add child widget in the header at right side of a multiselect.
  final Widget? headerPrefixChild;

  /// This method is used when onDone callback it is use to return updated list.
  final ValueChanged<List<UFUMultiSelectModel>>? onDone;

  final Widget? doneIcon;

  final Widget? totalAmount;

  final bool disableButtons;

  final bool canDisableDoneButton;

  /// type can be used to differentiate between network list and local list
  /// default selected type is [UFUMultiSelectType.local]
  final UFUMultiSelectType type;

  /// In case of network list isLoading helps to manage loading state
  final bool isLoading;

  /// In case of network list canShowMore helps to manage loader state
  final bool canShowLoadMore;

  /// In case of network list isLoading helps to manage load more state
  final bool isLoadMore;

  /// In case of network list onLoadMore send a callback to perform further action
  final VoidCallback? onLoadMore;

  /// In case of network list onSearch returns a callback with search keyword to take an action
  final Function(String keyword)? onSearch;

  /// In case of network list totalNetworkListCount is used to display
  /// number of total available items
  final int? totalNetworkListCount;

  /// In case of network list listLoader is used to display a loading placeholder
  final Widget? listLoader;

  /// In case of network list initialSelectionsForNetworkList is used to display selected items at beginning
  final List<UFUMultiSelectModel>? initialSelectionsForNetworkList;

  /// helperText can be used to display some info as a helper to user
  final String? helperText;

  /// Defines to show user filter 
  final bool? canShowSubList;

  /// Function to show user filter or not.
  final ValueChanged<bool>? showSubList;

  /// Defines sub list title.
  final String? subTitleHeader;

  /// Helps in restricting maximum selections
  final int? maxSelection;

  /// Can be used to display warning to user on max selection reach
  final VoidCallback? onMaxSelectionReached;

  /// Defines to show include inactive button
  final bool showIncludeInactiveButton;

  /// Defined to update TotalAmount
  final void Function({int? index, bool? isSelectAll,bool? isSelect})? updateTotalAmount;

  /// Can be used to perform actions externally on selecting an item
  final Function(List<UFUMultiSelectModel>, int)? onTapItem;

  final bool hideSelectAll;

  @override
  _UFUMultiSelectState createState() => _UFUMultiSelectState();
}

class _UFUMultiSelectState extends State<UFUMultiSelect> {
  /// textEditingController is used in search field
  TextEditingController textEditingController = TextEditingController();

  /// list is used to store results of main list locally
  List<UFUMultiSelectModel> list = [];

  /// list is used to store results of filter by users from list locally
  List<UFUMultiSelectModel> listfilter = [];

  List<String> selectedSubListId = [];

  /// list is used to store results of sub list locally
  List<UFUMultiSelectModel> subList = [];

  /// selectedItems is used to store list list of selected items
  List<UFUMultiSelectModel> selectedItems = [];

  /// tempSelectedItems is used to store list listfilter of selected items
  List<UFUMultiSelectModel> tempSelectedItems = [];

  /// selectedItems is used to store list selectedSubList of selected items
  List<UFUMultiSelectModel> selectedSubListItems = [];

  /// In case of network list, scrollController helps in load-more
  late ScrollController scrollController;

  /// doCloneLists is used as a comparator to avoid state leaks
  bool doCloneLists = true;

  /// Define to show subList or not.
  bool isViewSubList = false;

  /// Defines to show subList is Selected or not.
  bool isSelectedSubList = false;

  /// Define to show include inactive or exclude inactive user
  bool includeInactive = false;

  final ScrollController scrollList = ScrollController();

  int tempSelectedItemsCount = 0;
  int filterListItemsCount = 0;

  @override
  void initState() {
    scrollController = ScrollController(); // initializing scroll controller
    if (widget.type == UFUMultiSelectType.network) {
      // adding a listener in case of network listing
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && widget.onLoadMore != null && !widget.isLoadMore) {
          widget.onLoadMore!();
        }
      });
    }
    // cloning lists at initial in case of local list
    cloneList();
    setUpSelectedValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: ValueNotifier(widget.isLoading),
        builder: (_, isLoading, child) {
          if (isLoading != doCloneLists &&
              widget.type == UFUMultiSelectType.network) {
            doCloneLists = !isLoading;
            cloneList(addToLists: true);
          }
          return child ?? const SizedBox();
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            top: true,
            bottom: false,
            child: UFUMultiSelectView(
              totalAmount: widget.totalAmount,
              listLoader: widget.listLoader,
              selectedItems: selectedItems,
              isSelectedSubListItems: isSelectedSubList,
              helperText: widget.helperText,
              totalNetworkListCount: widget.totalNetworkListCount,
              scrollController: scrollController,
              canShowMore: widget.canShowLoadMore,
              isLoading: widget.isLoading,
              type: widget.type,
              inputHintText: widget.inputHintText,
              list: getList(),
              showIncludeInactiveButton: widget.showIncludeInactiveButton,
              includeInactive: includeInactive,
              onTapIncludeInactiveButton: toggleIncludeInactiveValue,
              subList: subList,
              canShowSearchBar: widget.mainList.length > 8,
              title: widget.title,
              searchInputCtrl: textEditingController,
              disableButtons: widget.disableButtons,
              canDisableDoneButton: widget.canDisableDoneButton,
              doneIcon: widget.doneIcon,
              isFilterSheet: widget.isFilterSheet,
              selectAndClearAll: selectAndClearAll,
              subTitleHeader: widget.subTitleHeader,
              tempSelectedItemsCount:tempSelectedItemsCount ,
              filterListItemsCount: filterListItemsCount,
              hideSelectAll: widget.hideSelectAll || widget.maxSelection != null,
              onItemTap: (String itemId) {
                int indexOfRenderList = list.indexWhere((element) => element.id == itemId);
                int indexOfRendertempList = listfilter.indexWhere((element) => element.id == itemId);
                 
                if (listfilter.isNotEmpty && isViewSubList) {
                  if (indexOfRendertempList != -1) {
                    if (listfilter[indexOfRendertempList].isSelect) {
                      listfilter[indexOfRendertempList].isSelect = false;
                      list[indexOfRenderList].isSelect = false;

                      if (widget.type == UFUMultiSelectType.local) {
                        tempSelectedItems.removeWhere((element) => element.id == listfilter[indexOfRendertempList].id);
                        selectedItems[indexOfRenderList].isSelect = false;
                      } 
                    } else if (isMaxSelectionsReached()) {
                      widget.onMaxSelectionReached?.call();
                    } else {
                      listfilter[indexOfRendertempList].isSelect = true;
                      list[indexOfRenderList].isSelect = true;

                      if (widget.type == UFUMultiSelectType.local) {
                        tempSelectedItems.add(listfilter[indexOfRendertempList]);
                        selectedItems[indexOfRenderList].isSelect = true;
                      } 
                    }
                  }
                } else {
                  if (indexOfRenderList != -1) {
                    if (list[indexOfRenderList].isSelect) {
                      list[indexOfRenderList].isSelect = false;

                      if (widget.type == UFUMultiSelectType.network) {
                        selectedItems.removeWhere((element) => element.id == list[indexOfRenderList].id);
                      } else {
                        selectedItems[indexOfRenderList].isSelect = false;
                        if (indexOfRendertempList != -1) {
                          tempSelectedItems.removeWhere((element) =>element.id == listfilter[indexOfRendertempList].id);
                        }
                      }
                    } else if (isMaxSelectionsReached()) {
                      widget.onMaxSelectionReached?.call();
                    } else {
                      list[indexOfRenderList].isSelect = true;

                      if (widget.type == UFUMultiSelectType.network) {
                        selectedItems.add(list[indexOfRenderList]);
                      } else {
                        selectedItems[indexOfRenderList].isSelect = true;
                        if (indexOfRendertempList != -1) {
                          tempSelectedItems.add(listfilter[indexOfRendertempList]);
                        }
                      }
                    }
                  }
                }

                if(widget.updateTotalAmount != null){
                  widget.updateTotalAmount!(
                    isSelect: selectedItems[indexOfRenderList].isSelect,
                    index: indexOfRenderList
                  );
                }
                
                listCount();
                widget.onTapItem?.call(list, indexOfRenderList);
                setState(() {});
              },
              onSubItemTap: (String subListId) {
                getList();
                int indexOfRenderSubList = subList.indexWhere((element) => element.id == subListId);

                if (indexOfRenderSubList != -1) {
                  if (subList[indexOfRenderSubList].isSelect) {
                    subList[indexOfRenderSubList].isSelect = false;
                    onFilterTags(subListId, 'remove');
                    if (widget.type == UFUMultiSelectType.local) {
                      selectedSubListItems.removeWhere((element) => element.id == subList[indexOfRenderSubList].id);
                    } else {
                      selectedSubListItems[indexOfRenderSubList].isSelect = false;
                    }
                  } else {
                    subList[indexOfRenderSubList].isSelect = true;
                    onFilterTags(subListId, 'add');
                    if (widget.type == UFUMultiSelectType.local) {
                      selectedSubListItems.add(subList[indexOfRenderSubList]);
                    } else {
                      selectedSubListItems[indexOfRenderSubList].isSelect = true;
                    }
                  }
                }
                getIsSelectedSubList();
                listCount();
                setState(() {});
              },
              onSearch: onSearch,
              onDone: onDone,
              headerPrefixChild: widget.headerPrefixChild,
              mainList: list,
              canShowSubList: widget.canShowSubList,
              showSubList: () async {
                isViewSubList = !isViewSubList;
                // Delay to make sure the frames are rendered properly
                if(isViewSubList){
                  await Future<void>.delayed(const Duration(milliseconds: 200));
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollList.animateTo(
                    scrollList.position.minScrollExtent,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn);
                  });
                }
                listCount();
                setState(() {});
              },
              scrollList: scrollList,
              isViewSubList: isViewSubList,
            ),
          ),
        ));
  }

  // getSelectedItemCount() : will return selected item count
  int getSelectedItemCount() {
    return selectedItems.where((element) => element.isSelect).length;
  }

  void selectAndClearAll() {
    if(widget.updateTotalAmount != null){
     widget.updateTotalAmount!(isSelectAll: getSelectedItemCount() == 0);
    }
    if (isViewSubList && subList.where((element) => element.isSelect).isNotEmpty) {
      tempListselectAndClearAll();
    } else {
      List <UFUMultiSelectModel>list = userListOnActiveStatus;
      List <UFUMultiSelectModel>selectedItems = selectedUserListOnActiveStatus;
          
      if (getSelectedItemCount() != 0) {
        for (var i = 0; i < list.length; i++) {
          list[i].isSelect = false;
          if (widget.type == UFUMultiSelectType.network) {
            selectedItems.removeWhere((element) => element.id == list[i].id);
          } else {
            selectedItems[i].isSelect = false;
            tempSelectedItems.clear();
            for (int i = 0; i < listfilter.length; i++) {
              listfilter[i].isSelect = false;
            }
          }
        }
        if (widget.type == UFUMultiSelectType.network) selectedItems.clear();
      } else {
        for (var i = 0; i < list.length; i++) {
          list[i].isSelect = true;
          if (widget.type == UFUMultiSelectType.network) {
            selectedItems.add(list[i]);
          } else {
            selectedItems[i].isSelect = true;
            for (int i = 0; i < listfilter.length; i++) {
              tempSelectedItems.add(listfilter[i]);
              listfilter[i].isSelect = true;
            }
          }
        }
      }
    }
    listCount();
    setState(() {});
    
  }

  void getIsSelectedSubList() {
    isSelectedSubList = selectedSubListId.isNotEmpty;
  }

  // getUserFilteredList() : will return user filtered list based on active or inactive user
  List<UFUMultiSelectModel> get userListOnActiveStatus {
    if(widget.showIncludeInactiveButton && !includeInactive) {
      return list.where((element) => element.active ?? true).toList();
    } 
    return list;
  }

  List<UFUMultiSelectModel> get selectedUserListOnActiveStatus {
    if(widget.showIncludeInactiveButton && !includeInactive) {
      return selectedItems.where((element) => element.active ?? true).toList();
    } 
    return selectedItems;
  }

  List<UFUMultiSelectModel> getList() {
    if(widget.showIncludeInactiveButton && list.any((element) => !(element.active ?? true) && element.isSelect)) {
      includeInactive = true;
    } 
    if(isViewSubList) {
      if(widget.showIncludeInactiveButton && !includeInactive) {
        if(subList.where((element) => element.isSelect).isNotEmpty) {
          return listfilter.where((element) => element.active ?? true).toList();
        } 
        return list.where((element) => element.active ?? true).toList();
      } 
      if(subList.where((element) => element.isSelect).isNotEmpty) {
        return listfilter;
      }
      return list;
    }
    if(widget.showIncludeInactiveButton && !includeInactive) {
      return list.where((element) => element.active ?? true).toList();   
    }
    return list;
  }

  void toggleIncludeInactiveValue() {
    List<UFUMultiSelectModel> list = userListOnActiveStatus;
    if(includeInactive) {
      for (var i = 0; i < list.length; i++) {
        if(list[i].active == false && list[i].isSelect) {
          list[i].isSelect = false;
          if (widget.type == UFUMultiSelectType.network) {
            selectedItems.removeWhere((element) => element.id == list[i].id);
          } else {
            selectedItems[i].isSelect = false;
            if (i != -1) {
              tempSelectedItems.removeWhere((element) =>element.id == listfilter[i].id);
            }
          }
        }
      }
      for(int i = 0; i < listfilter.length; i++) {
        if(listfilter[i].active == false && listfilter[i].isSelect) {
          listfilter[i].isSelect = false;
          if (widget.type == UFUMultiSelectType.network) {
            selectedItems.removeWhere((element) => element.id == listfilter[i].id);
          } else {
            selectedItems[i].isSelect = false;
            if (i != -1) {
              tempSelectedItems.removeWhere((element) =>element.id == listfilter[i].id);
            }
          }
        }
      }
    }
    includeInactive = !includeInactive;
    setState(() {});
  }

  List<UFUMultiSelectModel> get filterListOnActiveBase {
    if(widget.showIncludeInactiveButton && !includeInactive) {
      return listfilter.where((element) => element.active ?? true).toList();
    }
    return listfilter;
  }

  void tempListselectAndClearAll() {
    List <UFUMultiSelectModel> listfilter = filterListOnActiveBase;
    List <UFUMultiSelectModel> list  = userListOnActiveStatus;
    List <UFUMultiSelectModel> selectedItems = selectedUserListOnActiveStatus;
    if (tempSelectedItems.where((element) => element.isSelect).isNotEmpty) {
      for (var i = 0; i < listfilter.length; i++) {
        listfilter[i].isSelect = false;
        if (widget.type == UFUMultiSelectType.local) {
          tempSelectedItems.removeWhere((element) => element.id == listfilter[i].id);
        } else {
          tempSelectedItems[i].isSelect = false;
        }
      }
      if (widget.type == UFUMultiSelectType.local) tempSelectedItems.clear();
    } else {
      for (var i = 0; i < listfilter.length; i++) {
        listfilter[i].isSelect = true;
        if (widget.type == UFUMultiSelectType.local) {
          tempSelectedItems.add(listfilter[i]);
        } else {
          tempSelectedItems[i].isSelect = true;
        }
      }
    }
    if (tempSelectedItems.isNotEmpty) {
      for (int i = 0; i < tempSelectedItems.length; i++) {
        int index = list.indexWhere((element) => element.id == tempSelectedItems[i].id);
        selectedItems[index].isSelect = true;
        list[index].isSelect = true;
      }
    } else {
      for (int i = 0; i < listfilter.length; i++) {
        int index = list.indexWhere((element) => element.id == listfilter[i].id);
        selectedItems[index].isSelect = false;
        list[index].isSelect = false;
      }
    }
  }

  // cloneList() : function is used to clone main-list -> list to avoid unnecessary state updates
  // params      : addToLists : value true will add data to list instead of wiping out all data
  void cloneList({bool addToLists = false}) async {
    list.clear();

    if (addToLists) {
      int skipCount = list.length;
      int skipSubCount = subList.length;
      list.addAll(widget.mainList.skip(skipCount).map((e) => UFUMultiSelectModel.clone(
              e..isSelect = selectedItems.any((element) => e.id == element.id))).toList());

      if(widget.showSubList != null) {
        subList.addAll(widget.subList!.skip(skipSubCount).map((e) =>
            UFUMultiSelectModel.clone(e
              ..isSelect = selectedSubListItems.any((element) =>
              e.id == element.id))).toList());
      }
    } else {
      list = widget.mainList.map((e) => UFUMultiSelectModel.clone(e)).toList();
      subList = widget.subList?.map((e) => UFUMultiSelectModel.clone(e)).toList() ?? [];
    }
  }

  // onSearch() : is used to differentiate working for local list and network list
  void onSearch(String value) async {
    if (widget.type == UFUMultiSelectType.network && widget.onSearch != null) {
      widget.onSearch!(value);
    } else {
      setState(() {});
    }
  }

  void onFilterTags(String subListId, String action) async {
    listfilter.clear();
    if (action == 'add') {
      selectedSubListId.add(subListId);
    } else {
      selectedSubListId.remove(subListId);
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].tags != null) {
        for (int j = 0; j < list[i].tags!.length; j++) {
          for (int k = 0; k < selectedSubListId.length; k++) {
            if (selectedSubListId[k] == list[i].tags![j].id.toString()) {
              listfilter.add(UFUMultiSelectModel(
                label: list[i].label,
                id: list[i].id,
                isSelect: list[i].isSelect,
                child: list[i].child,
                active: list[i].active,
              )
              );
            }
          }
        }
      }
    }
    var seen = <String>{};
    listfilter = listfilter.where((element) => seen.add(element.id.toString())).toList();
    tempSelectedItems = listfilter.where((element) => element.isSelect).toList();
  }

  // setUpSelectedValues() : is to initialize selectedItems list with selected values
  void setUpSelectedValues() {
    if (widget.type == UFUMultiSelectType.network) {
      widget.initialSelectionsForNetworkList?.forEach((element) {
        selectedItems.add(UFUMultiSelectModel.clone(element));
      });
    } else {
      for (var element in widget.mainList) {
          selectedItems.add(UFUMultiSelectModel.clone(element));
        }
      }
      for (var element in widget.mainList) {
        selectedSubListItems.add(UFUMultiSelectModel.clone(element));
      }
    }
  

  void listCount(){
    tempSelectedItemsCount = (listfilter.length >= tempSelectedItems.length) ? tempSelectedItems.length : listfilter.length;
    filterListItemsCount = (isViewSubList) ? listfilter.length : 0 ;
    setState(() {});
  }

  void onDone() {
    if (widget.type == UFUMultiSelectType.network) {
      widget.onDone!(selectedItems);
    } else {
      widget.onDone!(selectedItems);
    }
  }

  bool isMaxSelectionsReached() {
    if (widget.maxSelection != null) {
      int selectedItems = list.where((element) => element.isSelect).length;
      return selectedItems >= widget.maxSelection!;
    }
    return false;
  }
}
