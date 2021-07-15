import 'dart:convert' as jsonConvert;
import 'package:app_builder/form_definition/model/dto/form_definition_child.dart';

class FormDefinition {
  FormDefinition({
    this.name,
    this.title,
    this.smsKeyword,
    this.defaultLanguage,
    this.idString,
    this.type,
    this.children = const [],
    this.style,
    this.choices,
    this.version,
  });

  String? name;
  String? title;
  String? smsKeyword;
  String? defaultLanguage;
  String? idString;
  String? type;
  List<FormDefinitionChild> children;
  String? style;
  String? choices;
  String? version;

  factory FormDefinition.fromJson(Map<String, dynamic> json) => FormDefinition(
        name: json["name"],
        title: json["title"],
        smsKeyword: json["sms_keyword"],
        defaultLanguage: json["default_language"],
        idString: json["id_string"],
        type: json["type"],
        children: List<FormDefinitionChild>.from(
            json["children"].map((x) => FormDefinitionChild.fromJson(x))),
        style: json["style"],
        choices: json["choices"] == null
            ? null
            : jsonConvert.json.encode(json["choices"]),
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "sms_keyword": smsKeyword,
        "default_language": defaultLanguage,
        "id_string": idString,
        "type": type,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "style": style,
        "choices": choices,
        "version": version,
      };
}
