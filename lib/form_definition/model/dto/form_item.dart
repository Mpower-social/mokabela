import 'dart:convert' as jsonConvert;
import 'package:app_builder/form_definition/model/dto/form_definition_child.dart';
import 'choice_list.dart';
import 'form_definition.dart';

List<FormItem> formItemsFromJson(String str) => List<FormItem>.from(
    jsonConvert.json.decode(str).map((x) => FormItem.fromJson(x)));

String formItemsToJson(List<FormItem> data) =>
    jsonConvert.json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormItem {
  FormItem({
    required this.formUuid,
    required this.name,
    required this.fieldNames,
    this.tableMapping = const [],
    this.choiceList,
    this.formDefinition,
    required this.id,
  });

  String formUuid;
  String name;
  String fieldNames;
  List<String> tableMapping;
  ChoiceList? choiceList;
  FormDefinition? formDefinition;
  int id;

  factory FormItem.fromJson(Map<String, dynamic> json) => FormItem(
        formUuid: json["form_uuid"],
        name: json["name"],
        fieldNames: json["field_names"] ?? '',
        tableMapping: List<String>.from(json["table_mapping"].map((x) => x)),
        choiceList: json["choice_list"] == null
            ? null
            : ChoiceList.fromJson(json["choice_list"]),
        formDefinition: json["form_definition"] == null
            ? null
            : FormDefinition.fromJson(json["form_definition"]),
        id: json["id"],
      );

  factory FormItem.fromLocalJson(Map<String, dynamic> json) => FormItem(
        formUuid: json["form_uuid"],
        name: json["name"],
        fieldNames: json["field_names"] ?? '',
        tableMapping: List<String>.from(
            jsonConvert.json.decode(json["table_mapping"]).map((x) => x)),
        choiceList: json["choice_list"] == null
            ? null
            : ChoiceList.fromJson(jsonConvert.json.decode(json["choice_list"])),
        formDefinition: json["form_definition"] == null
            ? null
            : FormDefinition.fromJson(
                jsonConvert.json.decode(json["form_definition"])),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "form_uuid": formUuid,
        "name": name,
        "table_mapping": jsonConvert.json.encode(tableMapping),
        "choice_list": jsonConvert.json.encode(choiceList?.toJson()),
        "form_definition": jsonConvert.json.encode(formDefinition?.toJson()),
        "field_names": formDefinition == null
            ? ''
            : parseFieldName(formDefinition!.children),
        "id": id,
      };

  String parseFieldName(List<FormDefinitionChild> children) {
    var parentName = "";
    var fieldNames = [];
    findPossibleFieldNames(parentName, fieldNames, children);

    return jsonConvert.json.encode(fieldNames);
  }

  findPossibleFieldNames(
    String parentName,
    List fieldNames,
    List<FormDefinitionChild> children,
  ) {
    children.forEach((child) {
      switch (child.type) {
        case 'group':
        case 'repeat':
          fieldNames.add(parentName + child.name);
          findPossibleFieldNames(
            '${parentName + child.name}/',
            fieldNames,
            child.children,
          );
          break;
        case 'time':
        case 'decimal':
        case 'note':
        case 'select all that apply':
        case 'calculate':
        case 'text':
        case 'date':
        case 'select one':
        case 'integer':
          fieldNames.add(parentName + child.name);
          break;
        default:
          break;
      }
    });
  }
}
