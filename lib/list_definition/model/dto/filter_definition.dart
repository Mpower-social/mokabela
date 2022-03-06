import 'package:app_builder/module/model/dto/label.dart';
import 'appearance.dart';

class FilterDefinition {
  FilterDefinition({
    this.type,
    this.appearance,
    this.name,
    this.label,
    this.dependency = const [],
    this.order,
  });

  String? type;
  Appearance? appearance;
  String? name;
  Label? label;
  List<String> dependency;
  int? order;

  factory FilterDefinition.fromJson(Map<String, dynamic> json) =>
      FilterDefinition(
        type: json["type"],
        appearance: json["appearance"] == null
            ? null
            : Appearance.fromJson(json["appearance"]),
        name: json["name"],
        label: json["label"] == null ? null : Label.fromJson(json["label"]),
        dependency: json["dependency"] == null
            ? []
            : List<String>.from(json["dependency"].map((x) => x)),
        order: json["order"] == null
            ? null
            : json["order"] is String
                ? int.parse(json["order"])
                : json["order"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "appearance": appearance?.toJson(),
        "name": name,
        "label": label?.toJson(),
        "dependency": List<dynamic>.from(dependency.map((x) => x)),
        "order": order,
      };
}
