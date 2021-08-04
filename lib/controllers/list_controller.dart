import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/form_definition/model/dto/form_item.dart';
import 'package:app_builder/form_definition/model/dto/geo_definition.dart';
import 'package:app_builder/list_definition/model/dto/list_definition.dart';
import 'package:app_builder/list_definition/model/dto/list_item.dart';
import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
import 'package:app_builder/list_definition/model/dto/list_item_content.dart';
import 'package:app_builder/utils/constant_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ListController extends GetxController {
  var expandList = List<RxBool>.empty(growable: true);
  var listItems = List<ListItem>.empty().obs;
  late Database db;
  final int listId;

  ListController({required this.listId});

  @override
  void onInit() async {
    super.onInit();
    db = await DatabaseHelper.instance.database;
    initializeListContent();
  }

  Future<void> initializeListContent() async {
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
              mapping[element.formField] = element.column;
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
      });

      items.sort((itemA, itemB) {
        try {
          return int.parse(itemA.contents[0].value)
              .compareTo(int.parse(itemB.contents[0].value));
        } catch (e) {
          return itemA.contents[0].value.compareTo(itemB.contents[0].value);
        }
      });

      items.forEach((_) {
        expandList.add(RxBool(false));
      });

      listItems.assignAll(items);
    }
  }

  openForm(ListItemAction? value) async {
    var dbForms = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_FORM_ITEM WHERE id = ${value?.formId} LIMIT 1');

    if (value != null && dbForms.isNotEmpty && dbForms.first['name'] != null) {
      var formItem = FormItem.fromLocalJson(dbForms.first);

      //await prepareAndGenerateCsv(formItem);

      ConstantUtil.PLATFORM.invokeMethod(
        'openForms',
        {
          "formId": formItem.name,
          "arguments": value.dataMapping,
        },
      );
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

  prepareAndGenerateCsv(FormItem formItem) async {
    var directory = await getExternalStorageDirectory();

    if (directory != null) {
      var path =
          '${directory.path}/forms/${formItem.formDefinition?.title}-media';
      var rootDirectory = Directory(path);
      if (!rootDirectory.existsSync()) rootDirectory.createSync();

      if (formItem.choiceList?.division != null)
        await createCsv(rootDirectory, formItem.choiceList!.division!);

      if (formItem.choiceList?.geo != null)
        await createCsv(rootDirectory, formItem.choiceList!.geo!);

      if (formItem.choiceList?.geoDivision != null)
        await createCsv(rootDirectory, formItem.choiceList!.geoDivision!);

      if (formItem.choiceList?.geoDistrict != null)
        await createCsv(rootDirectory, formItem.choiceList!.geoDistrict!);

      if (formItem.choiceList?.staff != null)
        await createCsv(rootDirectory, formItem.choiceList!.staff!);

      if (formItem.choiceList?.medicine != null)
        await createCsv(rootDirectory, formItem.choiceList!.medicine!);
    }
  }

  createCsv(Directory rootDirectory, GeoDefinition geo) async {
    var csvFile = File('${rootDirectory.path}/${geo.configJson!.csvName}.csv');

    if (csvFile.existsSync()) csvFile.deleteSync();
    csvFile.createSync();

    var csvContents = await db.rawQuery(geo.query!);
    if (csvContents.isNotEmpty) {
      csvFile.writeAsStringSync('${csvContents.first.keys.join(",")}\n',
          mode: FileMode.append);

      csvContents.forEach((content) {
        csvFile.writeAsStringSync('${content.values.join(",")}\n',
            mode: FileMode.append);
      });
    }
  }
}
