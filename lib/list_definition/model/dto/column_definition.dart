import 'package:app_builder/module/model/dto/label.dart';
import 'action_definition.dart';

class ColumnDefinition {
  ColumnDefinition({
    this.exportable,
    this.dataType,
    this.format,
    this.label,
    this.sortable,
    this.hidden,
    this.fieldName,
    this.actionDefinition = const [],
    this.order,
  });

  bool? exportable;
  String? dataType;
  String? format;
  Label? label;
  bool? sortable;
  bool? hidden;
  String? fieldName;
  List<ActionDefinition> actionDefinition;
  String? order;

  factory ColumnDefinition.fromJson(Map<String, dynamic> json) =>
      ColumnDefinition(
        exportable: json["exportable"] == null ? null : json["exportable"],
        dataType: json["data_type"],
        format: json["format"] == null ? null : json["format"],
        label: json["label"] == null ? null : Label.fromJson(json["label"]),
        sortable: json["sortable"] == null ? null : json["sortable"],
        hidden: json["hidden"] == null ? null : json["hidden"],
        fieldName: json["field_name"] == null ? null : json["field_name"],
        actionDefinition: json["action_definition"] == null
            ? []
            : List<ActionDefinition>.from(json["action_definition"]
                .map((x) => ActionDefinition.fromJson(x))),
        order: json["order"] == null ? null : json["order"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "exportable": exportable,
        "data_type": dataType,
        "format": format,
        "label": label?.toJson(),
        "sortable": sortable,
        "hidden": hidden,
        "field_name": fieldName,
        "action_definition":
            List<dynamic>.from(actionDefinition.map((x) => x.toJson())),
        "order": order,
      };
}
