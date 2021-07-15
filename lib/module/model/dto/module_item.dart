import 'dart:convert';
import 'catchment_area.dart';
import 'label.dart';

ModuleItem moduleItemFromJson(String str) =>
    ModuleItem.fromJson(json.decode(str));

String moduleItemToJson(ModuleItem data) => json.encode(data.toJson());

class ModuleItem {
  ModuleItem({
    this.xformId,
    required this.name,
    this.imgId,
    this.children = const [],
    required this.label,
    this.catchmentArea = const [],
    this.listId,
    required this.type,
    required this.id,
  });

  int? xformId;
  String name;
  String? imgId;
  List<ModuleItem> children;
  Label label;
  List<CatchmentArea> catchmentArea;
  int? listId;
  String type;
  int id;

  factory ModuleItem.fromJson(Map<String, dynamic> json) => ModuleItem(
        xformId: (json["xform_id"] is String || json["xform_id"] == null)
            ? null
            : json["xform_id"].toInt(),
        name: json["name"],
        imgId: json["img_id"],
        children: List<ModuleItem>.from(
            json["children"].map((x) => ModuleItem.fromJson(x))),
        label: Label.fromJson(json["label"]),
        catchmentArea: List<CatchmentArea>.from(
            json["catchment_area"].map((x) => CatchmentArea.fromJson(x))),
        listId: (json["list_id"] is String || json["list_id"] == null)
            ? null
            : json["list_id"].toInt(),
        type: json["type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "xform_id": xformId,
        "name": name,
        "img_id": imgId,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "label": label.toJson(),
        "catchment_area":
            List<dynamic>.from(catchmentArea.map((x) => x.toJson())),
        "list_id": listId,
        "type": type,
        "id": id,
      };
}
