import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/list_definition/model/dto/list_definition.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  var tableContents = List<dynamic>.empty().obs;
  var tableHeaders = List<dynamic>.empty().obs;
  final int listId;

  ListController({required this.listId});

  @override
  void onInit() {
    super.onInit();
    initializeListContent();
  }

  Future<void> initializeListContent() async {
    var listContents = [];
    var listHeaders = [];
    var listKeys = [];

    var db = await DatabaseHelper.instance.database;
    var dbLists = await db.rawQuery(
        'SELECT * FROM $TABLE_NAME_LIST_ITEM WHERE id = $listId LIMIT 1');

    if (dbLists.isNotEmpty) {
      var listItem = ListDefinition.fromLocalJson(dbLists.first);
      listItem.columnDefinition.forEach((column) {
        if (column.label != null &&
            column.label!.english != null &&
            column.fieldName != null) {
          listKeys.add(column.fieldName);
          listHeaders.add(column.label!.english);
        }
      });

      var dbListValues = await db.rawQuery(listItem.datasource!.query!);
      dbListValues.forEach((listValue) {
        var listValues = [];

        listKeys.forEach((key) {
          listValues.add(listValue[key]);
        });

        listContents.add(listValues);
      });
    }

    tableHeaders.assignAll(listHeaders);
    tableContents.assignAll(listContents);
  }
}
