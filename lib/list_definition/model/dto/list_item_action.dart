class ListItemAction {
  ListItemAction({
    this.formId,
    this.formName,
    this.actionType,
    this.actionName,
  });

  int? formId;
  String? formName;
  String? actionType;
  String? actionName;

  factory ListItemAction.fromJson(Map<String, dynamic> json) => ListItemAction(
        formId: json["form_id"],
        formName: json["form_name"],
        actionType: json["action_type"],
        actionName: json["action_name"],
      );

  Map<String, dynamic> toJson() => {
        "form_id": formId,
        "form_name": formName,
        "action_type": actionType,
        "action_name": actionName,
      };
}
