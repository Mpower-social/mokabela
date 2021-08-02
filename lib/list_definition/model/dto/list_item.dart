import 'package:app_builder/list_definition/model/dto/list_item_action.dart';
import 'package:app_builder/list_definition/model/dto/list_item_content.dart';

ListItem listItemFromJson(dynamic str) => str.map((x) => ListItem.fromJson(x));

class ListItem {
  ListItem({
    required this.actions,
    required this.contents,
  });

  List<ListItemAction> actions;
  List<ListItemContent> contents;

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        actions: json["actions"] == null
            ? []
            : List<ListItemAction>.from(
                json["actions"].map((x) => ListItemAction.fromJson(x))),
        contents: json["contents"] == null
            ? []
            : List<ListItemContent>.from(
                json["contents"].map((x) => ListItemContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
      };
}
