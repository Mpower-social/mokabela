import 'dart:convert' as jsonConvert;

List<DataItem> dataItemsFromJson(String str) => List<DataItem>.from(
    jsonConvert.json.decode(str).map((x) => DataItem.fromJson(x)));

String dataItemsToJson(List<DataItem> data) =>
    jsonConvert.json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataItem {
  DataItem({
    required this.id,
    required this.xformId,
    required this.json,
    this.userId,
    required this.updatedAt,
  });

  int id;
  int xformId;
  String json;
  String? userId;
  int updatedAt;

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
        id: json["id"],
        xformId: json["xform_id"],
        json: jsonConvert.json.encode(json["json"]),
        userId: json["user_id"].toString(),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": 1,
        "xform_id": xformId,
        "json": json,
        "updated_at": updatedAt,
      };
}