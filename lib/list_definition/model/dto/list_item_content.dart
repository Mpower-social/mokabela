import 'dart:convert';

List<ListItemContent> listItemContentsFromJson(String str) =>
    List<ListItemContent>.from(
        json.decode(str).map((x) => ListItemContent.fromJson(x)));

String listItemContentToJson(List<ListItemContent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListItemContent {
  ListItemContent({
    this.key,
    this.type,
    this.name,
    this.value,
    this.sortable,
  });

  String? key;
  String? type;
  String? name;
  dynamic? value;
  bool? sortable;

  factory ListItemContent.fromJson(Map<String, dynamic> json) =>
      ListItemContent(
        key: json["key"],
        type: json["type"],
        name: json["name"],
        value: json["value"],
        sortable: json["sortable"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "type": type,
        "name": name,
        "value": value,
        "sortable": sortable,
      };
}
