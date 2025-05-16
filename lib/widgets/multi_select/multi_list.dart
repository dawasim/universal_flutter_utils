import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'list.dart';

class UFUMultiListMultiSelect extends StatefulWidget {

  const UFUMultiListMultiSelect({
    super.key,
    required this.data,
    required this.onDone,
    this.title = 'Select option',
    this.searchHint = 'Search here'
  });

  final List<UFUMultiSelectMultiListModel> data;
  final Function(List<UFUMultiSelectMultiListModel>) onDone;
  final String title;
  final String searchHint;

  @override
  State<UFUMultiListMultiSelect> createState() => _UFUMultiListMultiSelectState();
}

class _UFUMultiListMultiSelectState extends State<UFUMultiListMultiSelect> {

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchInputCtrl = TextEditingController();

  List<UFUMultiSelectMultiListModel> multiListData = [];

  int selectedItemsCount = 0;
  int totalCount = 0;

  bool isAnyItemVisible = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (UFUMultiSelectMultiListModel data in widget.data) {
        multiListData.add(UFUMultiSelectMultiListModel.clone(data));
        totalCount += data.list.length;
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        top: UFUScreen.height * 0.05
      ),
      child: ClipRRect(
        borderRadius: UFUResponsiveDesign.bottomSheetRadius,
        child: Material(
          borderRadius: UFUResponsiveDesign.bottomSheetRadius,
          color: AppTheme.themeColors.base,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(
                maxHeight: UFUScreen.height * 0.85, minHeight: 100),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UFUMultiSelectHeader(
                    title: widget.title,
                    isViewSubList: false,
                    inputHintText: widget.searchHint,
                    canShowSearchBar: true,
                    searchInputCtrl: searchInputCtrl,
                    onSearch: (val) => onSearch(),
                  ),
                  UFUMultiSelectSubHeader(
                    mainListLength: totalCount,
                    selectedItemCount: selectedItemsCount,
                  ),
                  Flexible(
                    child: isAnyItemVisible
                        ? SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              multiListData.length,
                                  (index) {
                                return Visibility(
                                  visible: multiListData[index].displayCount > 0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      getTitle(index),
                                      UFUMultiSelectList(
                                        controller: scrollController,
                                        list: multiListData[index].list,
                                        onItemTap: (optionId) => onTapItem(index, optionId),
                                        searchKeyWord: searchInputCtrl.text,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: UFUText(
                            text: 'No record found',
                            textSize: UFUTextSize.heading4,
                        ),
                      ),
                  ),
                  UFUMultiSelectFooter(
                      callBack: (val) {
                        if(val == 'done') {
                          onDone();
                        }
                        Navigator.pop(context);
                      },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitle(int index) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: UFUText(
              text: multiListData[index].label + " (${multiListData[index].displayCount})",
              fontWeight: UFUFontWeight.medium,
            ),
          ),
        ),
      ],
    );
  }

  void updateCount(bool isSelected) {
    int incrementBy = isSelected ? 1 : -1;
    selectedItemsCount += incrementBy;
    setState(() {});
  }

  void onTapItem(int index, String optionId) {
    final item = multiListData[index].list.firstWhere((option) => option.id == optionId);
    item.isSelect = !item.isSelect;
    updateCount(item.isSelect);
  }

  void onSearch() {

    int tempCount = 0;

    for (var data in multiListData) {
     final count = data.list.where((option) =>
         option.label.toLowerCase().contains(searchInputCtrl.text.toLowerCase())).length;
     data.displayCount = count;
     tempCount += count;
    }

    isAnyItemVisible = tempCount > 0;

    setState(() {});
  }

  void onDone() {
    widget.onDone(multiListData);
  }
}
