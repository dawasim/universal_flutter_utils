import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUListView extends StatefulWidget {
  final int listCount;

  final Future<void> Function()? onRefresh;

  final Future<void> Function()? onLoadMore;

  final Widget Function(BuildContext, int) itemBuilder;

  final bool? disableOnRefresh;
  
  final EdgeInsets? padding;

  final Axis scrollDirection;

  final ScrollPhysics? physics;

  final ScrollController? scrollController;

  final bool shrinkWrap;

  final bool doAddFloatingButtonMargin;

  final bool isGridView;

  final SliverGridDelegate? gridDelegate;

  const UFUListView({
    super.key,
    required this.listCount,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.disableOnRefresh,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.scrollController,
    this.shrinkWrap = true,
    this.doAddFloatingButtonMargin = false,
    this.isGridView = false,
    this.gridDelegate,
  });

  @override
  _UFUListViewState createState() => _UFUListViewState();
}

class _UFUListViewState extends State<UFUListView> {
  late final ScrollController infiniteScrollController;

  bool isRefreshing = false;
  bool isLoadingMore = false;

  int count = 0;

  @override
  void initState() {
    infiniteScrollController = widget.scrollController ?? ScrollController();
    super.initState();

    //Listening page scroll to detect is page reached to bottom or not
    //if reached bottom then calling load more function to load next page data in list
    infiniteScrollController.addListener(() async {
      if((infiniteScrollController.position.pixels + UFUResponsiveDesign.floatingButtonSize + 50)
        >= infiniteScrollController.position.maxScrollExtent
        && widget.onLoadMore != null
        && !isLoadingMore
        && !isRefreshing) {
        toggleIsLoadingMore();
        await widget.onLoadMore!();
        toggleIsLoadingMore();
      }
    });
  }

  @override
  void dispose() {
    infiniteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*Flexible(
      child: */widget.onRefresh != null ?  RefreshIndicator(
        onRefresh: () async {
          if(isLoadingMore) return;
          toggleIsRefreshing();
          await widget.onRefresh!();
          toggleIsRefreshing();
        },
        notificationPredicate: (scroll){
          return isLoadingMore
              ? false
              : !(widget.disableOnRefresh ?? false);
        },
        child: widget.isGridView ? getGridView() : getListView()
      ) : widget.isGridView ? getGridView() : getListView();
    // );
  }

  Widget getListView() {
    return MediaQuery.removeViewPadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: getListPadding(),
        controller: infiniteScrollController,
        scrollDirection: widget.scrollDirection,
        itemCount: widget.listCount + 1,
        itemBuilder: widget.itemBuilder,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
      ),
    );
  }

  Widget getGridView() {
    return MediaQuery.removeViewPadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        gridDelegate: widget.gridDelegate ?? const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: getListPadding(),
        controller: infiniteScrollController,
        scrollDirection: widget.scrollDirection,
        itemCount: widget.listCount + 1,
        itemBuilder: widget.itemBuilder,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
      ),
    );
  }

  EdgeInsets? getListPadding() {
    if(!widget.doAddFloatingButtonMargin) {
      return widget.padding;
    } else if(widget.padding != null) {
      return widget.padding?.copyWith(
          bottom: UFUResponsiveDesign.floatingButtonSize
      );
    } else {
      return UFUResponsiveDesign.floatingButtonPadding;
    }
  }

  void toggleIsRefreshing() {
    isRefreshing = !isRefreshing;
  }

  void toggleIsLoadingMore() {
    isLoadingMore = !isLoadingMore;
  }
}