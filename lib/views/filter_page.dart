import 'package:app_builder/controllers/filter_controller.dart';
import 'package:app_builder/list_definition/model/dto/filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterPage extends StatelessWidget {
  late final FilterController filterController;
  final selectedItems = [].obs;

  FilterPage(List<FilterItem> filterItems) {
    filterController = Get.put(FilterController(filterItems: filterItems));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDiscardConfirmation(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          toolbarHeight: 90,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Choose filter',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: filterController.filterItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () => showSelectionDialog(
                            filterController.filterItems[index]),
                        title: Text(
                          filterController.filterItems[index].name!,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        subtitle: Obx(() {
                          return Text(
                            filterController.filterItems[index].selectedValues
                                    .isNotEmpty
                                ? filterController
                                    .filterItems[index].selectedValues
                                    .join(", ")
                                : 'Choose ${filterController.filterItems[index].name}',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          );
                        }),
                      ),
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () => showResetConfirmation(context),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Reset',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async => filterController.isDirty.value
                        ? await showApplyConfirmation(context)
                            ? Get.back()
                            : null
                        : null,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Apply',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.done_all,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showSelectionDialog(FilterItem filterItem) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Obx(() {
          return Wrap(
            spacing: 5,
            runSpacing: 3,
            children: List.generate(
              filterItem.currentValues.length,
              (int index) {
                return FilterChip(
                  label: Text(filterItem.currentValues[index].name!),
                  selected: filterItem.selectedValues
                      .contains(filterItem.currentValues[index].name!),
                  selectedColor: Colors.green,
                  onSelected: (bool selected) {
                    filterController.isDirty.value = true;

                    if (selected) {
                      if (filterItem.type == 'multiple_select') {
                        filterItem.selectedValues
                            .add(filterItem.currentValues[index].name!);
                      } else {
                        filterItem.selectedValues.clear();
                        filterItem.selectedValues
                            .add(filterItem.currentValues[index].name!);
                      }
                    } else {
                      if (filterItem.type == 'multiple_select') {
                        filterItem.selectedValues
                            .remove(filterItem.currentValues[index].name!);
                      } else {
                        filterItem.selectedValues.clear();
                      }
                    }
                  },
                );
              },
            ).toList(),
          );
        }),
      ),
    ).then((value) => filterController.onUpdateDependencies(filterItem));
  }

  Future<bool> showDiscardConfirmation(BuildContext context) async {
    if (!filterController.isDirty.value) return true;

    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Warning!'),
        content: new Text('Do you want to discard the changes?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              filterController.onDiscardFilter();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> showResetConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Warning!'),
        content: new Text('Do you want to reset the filters?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              filterController.onResetFilter();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<bool> showApplyConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Info!'),
        content: new Text('Do you want to apply the filters?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              filterController.onApplyFilter();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}
