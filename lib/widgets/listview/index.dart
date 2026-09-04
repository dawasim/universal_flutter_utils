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

  final bool? isLoading;

  final Widget Function(BuildContext, int)? shimmerBuilder;

  final String? noDataText;

  final Widget? noDataWidget;

  /// When true, index 0 starts at the bottom (upside down).
  /// Load more fires at the visual top; pull-to-refresh at the visual bottom.
  final bool isReverse;

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
    this.isLoading,
    this.shimmerBuilder,
    this.noDataText,
    this.noDataWidget,
    this.isReverse = false,
  });

  @override
  UFUListViewState createState() => UFUListViewState();
}

class UFUListViewState extends State<UFUListView> {
  late final ScrollController infiniteScrollController;
  late final bool _ownsScrollController;

  bool isRefreshing = false;
  bool isLoadingMore = false;

  int count = 0;

  @override
  void initState() {
    _ownsScrollController = widget.scrollController == null;
    infiniteScrollController = widget.scrollController ?? ScrollController();
    super.initState();

    infiniteScrollController.addListener(_onScroll);
  }

  Future<void> _onScroll() async {
    if (!infiniteScrollController.hasClients) return;
    if (widget.onLoadMore == null || isLoadingMore || isRefreshing) return;

    final position = infiniteScrollController.position;
    if (position.maxScrollExtent <= 0) return;

    final threshold = UFUResponsiveDesign.floatingButtonSize + 50;
    final reachedLoadMoreEdge = widget.isReverse
        ? position.pixels >= (position.maxScrollExtent - threshold)
        : (position.pixels + threshold) >= position.maxScrollExtent;

    if (reachedLoadMoreEdge) {
      toggleIsLoadingMore();
      await widget.onLoadMore!();
      toggleIsLoadingMore();
    }
  }

  @override
  void dispose() {
    infiniteScrollController.removeListener(_onScroll);
    if (_ownsScrollController) {
      infiniteScrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading ?? false) {
      return widget.isGridView ? getGridShimmer() : getListShimmer();
    } else if (widget.listCount == 0) {
      return widget.noDataWidget ??
          UFUNoDataFound(title: widget.noDataText ?? "No Data Found");
    } else {
      final list = widget.isGridView ? getGridView() : getListView();
      if (widget.onRefresh == null) return list;
      return widget.isReverse
          ? _buildReverseRefresh(list)
          : _buildRefresh(list);
    }
  }

  Widget _buildRefresh(Widget child) {
    return RefreshIndicator(
      onRefresh: () async {
        if (isLoadingMore) return;
        toggleIsRefreshing();
        await widget.onRefresh!();
        toggleIsRefreshing();
      },
      notificationPredicate: (scroll) {
        return isLoadingMore ? false : !(widget.disableOnRefresh ?? false);
      },
      child: child,
    );
  }

  Widget _buildReverseRefresh(Widget child) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleReverseRefreshNotification,
      child: Stack(
        children: [
          Positioned.fill(child: child),
          if (isRefreshing)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppTheme.themeColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _reverseRefreshDrag = 0;

  bool _handleReverseRefreshNotification(ScrollNotification notification) {
    if (widget.disableOnRefresh ?? false) return false;
    if (isLoadingMore || isRefreshing) return false;
    if (widget.onRefresh == null) return false;

    if (notification is OverscrollNotification) {
      final atVisualBottom =
          notification.metrics.pixels <=
          notification.metrics.minScrollExtent + 1;
      final pullDown =
          (notification.dragDetails?.delta.dy ?? 0) > 0 ||
          notification.overscroll < 0;
      if (atVisualBottom && pullDown) {
        _reverseRefreshDrag +=
            notification.dragDetails?.delta.dy ?? -notification.overscroll;
        if (_reverseRefreshDrag > 80) {
          _startReverseRefresh();
        }
      }
    } else if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels > notification.metrics.minScrollExtent) {
        _reverseRefreshDrag = 0;
      }
    } else if (notification is ScrollEndNotification) {
      _reverseRefreshDrag = 0;
    }
    return false;
  }

  Future<void> _startReverseRefresh() async {
    if (isRefreshing || isLoadingMore) return;
    _reverseRefreshDrag = 0;
    setState(() => isRefreshing = true);
    await widget.onRefresh!();
    if (mounted) setState(() => isRefreshing = false);
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
        reverse: widget.isReverse,
        itemCount: widget.listCount + 1,
        itemBuilder: widget.itemBuilder,
        physics: _scrollPhysics,
        shrinkWrap: widget.shrinkWrap,
      ),
    );
  }

  Widget getGridView() {
    return MediaQuery.removeViewPadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        gridDelegate:
            widget.gridDelegate ??
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10, // Spacing between columns
              mainAxisSpacing: 10, // Spacing between rows
            ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: getListPadding(),
        controller: infiniteScrollController,
        scrollDirection: widget.scrollDirection,
        reverse: widget.isReverse,
        itemCount: widget.listCount + 1,
        itemBuilder: widget.itemBuilder,
        physics: _scrollPhysics,
        shrinkWrap: widget.shrinkWrap,
      ),
    );
  }

  ScrollPhysics? get _scrollPhysics {
    if (widget.physics != null) return widget.physics;
    if (widget.onRefresh != null) {
      return const AlwaysScrollableScrollPhysics();
    }
    return null;
  }

  EdgeInsets? getListPadding() {
    if (!widget.doAddFloatingButtonMargin) {
      return widget.padding;
    } else if (widget.padding != null) {
      return widget.padding?.copyWith(
        bottom: UFUResponsiveDesign.floatingButtonSize,
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

  Widget getListShimmer() => ListView.builder(
    physics: widget.physics,
    shrinkWrap: widget.shrinkWrap,
    scrollDirection: widget.scrollDirection,
    reverse: widget.isReverse,
    itemCount: 10,
    padding: getListPadding(),
    itemBuilder: (context, index) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          widget.shimmerBuilder?.call(context, index) ??
          const UFUShimmer(height: 150, width: double.maxFinite),
    ),
  );

  Widget getGridShimmer() => GridView.builder(
    physics: widget.physics,
    shrinkWrap: widget.shrinkWrap,
    scrollDirection: widget.scrollDirection,
    reverse: widget.isReverse,
    padding: getListPadding(),
    gridDelegate:
        widget.gridDelegate ??
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
        ),
    itemCount: 10,
    itemBuilder: (context, index) => Container(
      decoration: BoxDecoration(
        color: AppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          widget.shimmerBuilder?.call(context, index) ??
          const UFUShimmer(height: 150, width: double.maxFinite),
    ),
  );
}
