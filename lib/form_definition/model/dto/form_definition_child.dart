import 'dart:convert' as jsonConvert;

import 'package:app_builder/module/model/dto/label.dart';

class FormDefinitionChild {
  FormDefinitionChild({
    this.control,
    required this.name,
    this.bind,
    this.label,
    required this.type,
    this.children = const [],
    this.choiceFilter,
    this.itemset,
  });

  String? control;
  String name;
  String? bind;
  String? label;
  String type;
  List<FormDefinitionChild> children;
  String? choiceFilter;
  String? itemset;

  factory FormDefinitionChild.fromJson(Map<String, dynamic> json) =>
      FormDefinitionChild(
        control: json["control"] == null
            ? null
            : jsonConvert.json.encode(json["control"]),
        name: json["name"],
        bind:
            json["bind"] == null ? null : jsonConvert.json.encode(json["bind"]),
        label: json["label"] == null
            ? null
            : jsonConvert.json.encode(json["label"]),
        type: json["type"],
        children: json["children"] == null
            ? []
            : List<FormDefinitionChild>.from(
                json["children"].map((x) => FormDefinitionChild.fromJson(x))),
        choiceFilter: json["choice_filter"],
        itemset: json["itemset"],
      );

  Map<String, dynamic> toJson() => {
        "control": control,
        "name": name,
        "bind": bind,
        "label": label,
        "type": type,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "choice_filter": choiceFilter,
        "itemset": itemset,
      };
}
