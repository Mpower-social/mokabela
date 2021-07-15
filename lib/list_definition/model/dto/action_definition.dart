import 'package:app_builder/form_definition/model/dto/data_mapping.dart';
import 'package:app_builder/module/model/dto/label.dart';

class ActionDefinition {
  ActionDefinition({
    this.detailsPk,
    required this.xformId,
    this.label,
    this.formTitle,
    this.actionType,
    this.dataMapping = const [],
  });

  String? detailsPk;
  int xformId;
  Label? label;
  String? formTitle;
  String? actionType;
  List<DataMapping> dataMapping;

  factory ActionDefinition.fromJson(Map<String, dynamic> json) =>
      ActionDefinition(
        detailsPk: json["details_pk"].toString(),
        xformId: json["xform_id"],
        label: Label.fromJson(json["label"]),
        formTitle: json["form_title"],
        actionType: json["action_type"],
        dataMapping: List<DataMapping>.from(
            json["data_mapping"].map((x) => DataMapping.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "details_pk": detailsPk,
        "xform_id": xformId,
        "label": label?.toJson(),
        "form_title": formTitle,
        "action_type": actionType,
        "data_mapping": List<dynamic>.from(dataMapping.map((x) => x.toJson())),
      };
}
