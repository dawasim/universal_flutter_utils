/// this modal is used in user modal
/// we are using limited keys values in relation
class TagLimitedModel {
   int? id;
   String? name;

  TagLimitedModel({
    required this.id,
    required this.name
  });

    factory TagLimitedModel.clone(TagLimitedModel source) {
    return TagLimitedModel(
      id: source.id,
      name: source.name
    );
  }

  @override
  bool operator == (other) {
    return (other is TagLimitedModel)
        && other.id == id
        && other.name == name
    ;
  }

  @override
  int get hashCode => 1;
}

