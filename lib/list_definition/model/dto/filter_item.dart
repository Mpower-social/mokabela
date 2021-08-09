import 'package:app_builder/list_definition/model/dto/filter_value.dart';
import 'package:get/get_rx/get_rx.dart';

class FilterItem {
  FilterItem({
    this.key,
    this.type,
    this.name,
    required this.values,
    required this.dependencies,
  }) {
    currentValues.value = dependencies.isEmpty ? values : [];
  }

  String? key;
  String? name;
  String? type;
  List<FilterValue> values;
  List<String> dependencies;

  var selectedValues = [].obs;
  var currentValues = List<FilterValue>.empty().obs;

  var lastSelectedValues = [];
}
