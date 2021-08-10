import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:app_builder/list_definition/model/dto/filter_value.dart';
import 'package:app_builder/utils/form_util.dart';
import 'package:collection/collection.dart';
import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/form_definition/model/dto/geo_definition.dart';
import 'package:app_builder/list_definition/model/dto/filter_item.dart';
import 'package:app_builder/list_definition/model/dto/list_definition.dart';
import 'package:app_builder/list_definition/model/dto/list_item.dart';
import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
import 'package:app_builder/list_definition/model/dto/list_item_content.dart';
import 'package:app_builder/service/remote_service.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ListController extends GetxController {
  var expandList = List<RxBool>.empty(growable: true);
  var filterItems = List<FilterItem>.empty().obs;
  var filteredListItems = List<ListItem>.empty().obs;
  var listItems = List<ListItem>.empty().obs;
  var communicationWithServer = false.obs;
  final int listId;

  ListController({required this.listId});

  @override
  void onInit() async {
    super.onInit();
    initializeListContent();
  }

  Future<void> initializeListContent() async {
    var db = await DatabaseHelper.instance.database;
    var dbLists = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_LIST_ITEM WHERE id = $listId LIMIT 1');

    if (dbLists.isNotEmpty) {
      var listDefinition = ListDefinition.fromLocalJson(dbLists.first);
      var listItem = ListItem(actions: [], contents: []);

      listDefinition.columnDefinition.forEach((column) {
        if (column.dataType == "action") {
          column.actionDefinition.forEach((action) {
            var mapping = HashMap();
            action.dataMapping.forEach((element) {
              mapping[element.formField?.split("/").last] = element.column;
            });

            listItem.actions.add(ListItemAction(
              formId: action.xformId,
              formName: action.formTitle,
              actionType: action.actionType,
              actionName: action.label?.english ?? "",
              dataMapping: mapping,
            ));
          });
        } else if (column.label != null && column.label!.english != null) {
          listItem.contents.add(ListItemContent(
            key: column.fieldName,
            type: "content",
            name: column.label!.english,
            sortable: column.sortable,
          ));
        }
      });

      var filters = List<FilterItem>.empty(growable: true);
      listDefinition.filterDefinition.forEach((filter) {
        filters.add(FilterItem(
            key: filter.name,
            type: filter.type,
            name: filter.label?.english,
            values: [],
            dependencies: filter.dependency));
      });

      List<ListItem> items = [];
      var dbListValues = await db.rawQuery(listDefinition.datasource!.query!);
      dbListValues.forEach((listValue) {
        var listContents =
            listItemContentsFromJson(listItemContentToJson(listItem.contents));

        listContents.forEach((content) {
          content.value = listValue[content.key];
        });

        var listActions =
            listItemActionsFromJson(listItemActionToJson(listItem.actions));

        listActions.forEach((action) {
          action.dataMapping?.forEach((key, value) {
            action.dataMapping?[key] = listValue[value];
          });
        });

        items.add(ListItem(
          actions: listActions,
          contents: listContents,
        ));

        filters.forEach((filter) {
          if (filter.dependencies.isEmpty) {
            var value = listValue[filter.key];
            var item = filter.values.firstWhereOrNull((filterValue) =>
                filterValue.name?.toLowerCase() ==
                value.toString().toLowerCase());

            if (item == null) {
              filter.values.add(FilterValue(
                name: value.toString(),
              ));
            }
          } else {
            filter.dependencies.forEach((dependency) {
              var value = listValue[filter.key];
              var parent = listValue[dependency];
              var item = filter.values.firstWhereOrNull((filterValue) =>
                  filterValue.name?.toLowerCase() ==
                      value.toString().toLowerCase() &&
                  filterValue.parent?.toLowerCase() ==
                      parent.toString().toLowerCase());

              if (item == null) {
                filter.values.add(FilterValue(
                  name: value.toString(),
                  parent: parent.toString(),
                ));
              }
            });
          }
        });
      });

      items.sort((itemA, itemB) {
        try {
          return int.parse(itemA.contents[0].value)
              .compareTo(int.parse(itemB.contents[0].value));
        } catch (e) {
          if (itemA.contents[0].value == null ||
              itemB.contents[0].value == null) return 0;

          return itemA.contents[0].value.compareTo(itemB.contents[0].value);
        }
      });

      items.forEach((_) {
        expandList.add(RxBool(false));
      });

      listItems.assignAll(items);
      filteredListItems.assignAll(items);
      filterItems.assignAll(filters);
    }
  }

  openForm(ListItemAction? value) async {
    var db = await DatabaseHelper.instance.database;
    var dbForms = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_FORM_ITEM WHERE id = ${value?.formId} LIMIT 1');

    if (value != null && dbForms.isNotEmpty && dbForms.first['name'] != null) {
      var formItem = FormItem.fromLocalJson(dbForms.first);

      var instancePath = await ConstantUtil.PLATFORM.invokeMethod(
        'openForms',
        {
          "formId": formItem.name,
          "arguments": value.dataMapping,
        },
      );

      FormUtil().parseFormAndSaveToTable(instancePath, formItem);
    } else {
      Get.snackbar(
        'Warning!',
        'Related form not found.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  fetchDataAndUpdate() async {
    if (communicationWithServer.value) return;

    communicationWithServer.value = true;

    var formUtil = FormUtil();
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await formUtil.fetchDataFromServer();
      await initializeListContent();
      await formUtil.fetchFormItemsAndGenerateCsv();
    } else {
      Get.snackbar(
        'Warning!',
        'Check your internet connection and try again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }

    communicationWithServer.value = false;
  }

  void onFilterApply() {
    List<ListItem> localItems = List.from(listItems);
    filterItems.forEach((filterItem) {
      if (filterItem.selectedValues.isEmpty) return;

      localItems = localItems
          .where((localItem) => localItem.contents
              .where((localContent) =>
                  localContent.key == filterItem.key &&
                  filterItem.selectedValues.contains(localContent.value))
              .isNotEmpty)
          .toList();
    });

    expandList.clear();
    localItems.forEach((_) {
      expandList.add(RxBool(false));
    });

    filteredListItems.assignAll(localItems);
  }
}
