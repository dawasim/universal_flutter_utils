import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:universal_flutter_utils/widgets/listview/index.dart';

class ListViewSample extends StatelessWidget {
  const ListViewSample({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListViewSampleController>(
      global: false,
      init: ListViewSampleController(),
      builder:(controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: UFUText(text: "List View Samples (With Pagination)", textSize: UFUTextSize.heading1),
        ),
        body: SafeArea(
          top: false,
          child: UFUListView(
            listCount: controller.intList.length,
            onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
            onRefresh: controller.refreshList,
            itemBuilder: (context, index) {
              if(index < controller.intList.length) {
                return ListTile(
                  title: UFUText(text: controller.intList[index].toString()),
                );
              } else if (controller.canShowLoadMore){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(child: FadingCircle(color: AppTheme.themeColors.primary, size: 25)),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          ),
        ),
      ),
    );
  }
}


class ListViewSampleController extends GetxController {
  int page = 0;
  int maxPage = 2;
  List<int> intList = [];
  bool isLoadMore = false;
  bool canShowLoadMore = false;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    if(page > 0) {
      await Future.delayed(Duration(seconds: 3));
    } else {
      intList = [];
    }

    if (!isLoadMore) {
      intList = [];
    }

    int temp = intList.length;

    for(int i = temp; i < temp + 15; i++) {
      intList.add(i);
    }

    page++;
    canShowLoadMore = page < maxPage;

    update();
  }

  Future<void> refreshList({bool? showLoading}) async {
    page = 0;

    /// show shimmer if showLoading = true
    update();
    await loadData();
  }

  Future<void> loadMore() async {
    page += 1;
    isLoadMore = true;
    await loadData();
  }

}
