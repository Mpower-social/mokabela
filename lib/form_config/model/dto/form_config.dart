/// sql_script : "CREATE TABLE bahis_household_reg_table \n(id INTEGER PRIMARY KEY AUTOINCREMENT,\nusername TEXT,\ndistricts TEXT,\nupazila TEXT,\nunion_name TEXT,\nhh_serial TEXT,\nhh_main_name TEXT,\naddress TEXT,\nhh_size TEXT,\nmeta_instanceID TEXT,\ninstanceid TEXT,\nxform_id TEXT);"
/// id : 225.0
/// updated_at : 1616394777389

import 'dart:convert';

List<FormConfig> formConfigFromJson(String str) =>
    List<FormConfig>.from(json.decode(str).map((x) => FormConfig.fromJson(x)));

String formConfigToJson(List<FormConfig> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormConfig {
  FormConfig({
    required this.sqlScript,
    required this.id,
    required this.updatedAt,
  });

  String sqlScript;
  int id;
  int updatedAt;

  factory FormConfig.fromJson(Map<String, dynamic> json) => FormConfig(
        sqlScript: json["sql_script"],
        id: json["id"] is double ? json["id"].toInt() : json["id"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "sql_script": sqlScript,
        "id": id,
        "updated_at": updatedAt,
      };
}
