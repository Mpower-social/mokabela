import 'package:app_builder/database/database_helper.dart';
import 'package:app_builder/list_definition/model/dto/list_definition.dart';
import 'package:app_builder/list_definition/model/dto/list_item.dart';
import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
import 'package:app_builder/list_definition/model/dto/list_item_content.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  var expandList = List<RxBool>.empty(growable: true);
  var listItems = List<ListItem>.empty().obs;
  final int listId;

  ListController({required this.listId});

  @override
  void onInit() {
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
            listItem.actions.add(ListItemAction(
              formId: action.xformId,
              formName: action.formTitle,
              actionType: action.actionType,
              actionName: action.label?.english ?? "",
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

        items.add(ListItem(
          actions: listItem.actions,
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
}
