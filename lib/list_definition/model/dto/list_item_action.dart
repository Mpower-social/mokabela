import 'dart:convert';

List<ListItemAction> listItemActionsFromJson(String str) =>
    List<ListItemAction>.from(
        json.decode(str).map((x) => ListItemAction.fromJson(x)));

String listItemActionToJson(List<ListItemAction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListItemAction {
  ListItemAction({
    this.formId,
    this.formName,
    this.actionType,
    this.actionName,
    this.dataMapping,
  });

  int? formId;
  String? formName;
  String? actionType;
  String? actionName;
  Map? dataMapping;

  factory ListItemAction.fromJson(Map<String, dynamic> json) => ListItemAction(
        formId: json["form_id"],
        formName: json["form_name"],
        actionType: json["action_type"],
        actionName: json["action_name"],
        dataMapping: json["data_mapping"],
      );

  Map<String, dynamic> toJson() => {
        "form_id": formId,
        "form_name": formName,
        "action_type": actionType,
        "action_name": actionName,
        "data_mapping": dataMapping,
      };
}
