import 'modal.dart';

class UFUMultiSelectMultiListModel {

  String label;
  List<UFUMultiSelectModel> list;
  late int displayCount;

  UFUMultiSelectMultiListModel({
    required this.label,
    this.list = const [],
  });

  factory UFUMultiSelectMultiListModel.clone(UFUMultiSelectMultiListModel source) {

    final list = source.list.map((e) => UFUMultiSelectModel.clone(e)).toList();

    return UFUMultiSelectMultiListModel(
      label: source.label,
      list: list,
    )..displayCount = list.length;
  }

  static List<UFUMultiSelectModel> getSelectedItems(UFUMultiSelectMultiListModel data) {

    List<UFUMultiSelectModel> selectedOptions = [];

    selectedOptions = data.list.where((option) => option.isSelect).toList();

    return selectedOptions;
  }

}
