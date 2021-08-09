import 'package:app_builder/list_definition/model/dto/filter_item.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final List<FilterItem> filterItems;
  final isDirty = false.obs;

  FilterController({this.filterItems = const []});

  onUpdateDependencies(FilterItem filterItem) {
    isDirty.value = isDirty.value ||
        (filterItem.selectedValues.length !=
            filterItem.lastSelectedValues.length);

    if (filterItem.selectedValues.isEmpty) return;

    var dependentItems = filterItems
        .where((element) => element.dependencies.contains(filterItem.key));

    dependentItems.forEach((dependentItem) {
      dependentItem.selectedValues.value = [];
      var items = dependentItem.values.where((item) => filterItem.selectedValues
          .where((value) => value.toLowerCase() == item.parent?.toLowerCase())
          .isNotEmpty);

      dependentItem.currentValues.assignAll(items);
    });
  }

  onApplyFilter() {
    filterItems.forEach((filterItem) async {
      filterItem.lastSelectedValues =
          filterItem.selectedValues.join(",").split(",");
    });
  }

  onResetFilter() {
    isDirty.value = true;
    filterItems.forEach((filterItem) {
      filterItem.selectedValues.value = [];
      filterItem.currentValues.value =
          filterItem.dependencies.isEmpty ? filterItem.values : [];
    });
  }

  onDiscardFilter() {
    filterItems.forEach((filterItem) async {
      filterItem.selectedValues.value = filterItem.lastSelectedValues;
      await onUpdateDependencies(filterItem);
    });
  }
}
