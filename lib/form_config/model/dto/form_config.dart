/// sql_script : "CREATE TABLE bahis_household_reg_table \n(id INTEGER PRIMARY KEY AUTOINCREMENT,\nusername TEXT,\ndistricts TEXT,\nupazila TEXT,\nunion_name TEXT,\nhh_serial TEXT,\nhh_main_name TEXT,\naddress TEXT,\nhh_size TEXT,\nmeta_instanceID TEXT,\ninstanceid TEXT,\nxform_id TEXT);"
/// id : 225.0
/// updated_at : 1616394777389

class FormConfig {
  String? sqlScript;
  double? id;
  int? updatedAt;

  FormConfig({
      this.sqlScript, 
      this.id, 
      this.updatedAt});

  FormConfig.fromJson(dynamic json) {
    sqlScript = json["sql_script"];
    id = json["id"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sql_script"] = sqlScript;
    map["id"] = id;
    map["updated_at"] = updatedAt;
    return map;
  }

}