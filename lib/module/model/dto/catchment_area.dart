/// name : "CHITTAGONG"
/// parent : -1
/// value : 20
/// loc_name : "Division"
/// loc_type : 1
/// id : 32

class CatchmentArea {
  String? name;
  int? parent;
  int? value;
  String? locName;
  int? locType;
  int? id;

  CatchmentArea({
      this.name, 
      this.parent, 
      this.value, 
      this.locName, 
      this.locType, 
      this.id});

  CatchmentArea.fromJson(dynamic json) {
    name = json["name"];
    parent = json["parent"];
    value = json["value"];
    locName = json["loc_name"];
    locType = json["loc_type"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["parent"] = parent;
    map["value"] = value;
    map["loc_name"] = locName;
    map["loc_type"] = locType;
    map["id"] = id;
    return map;
  }

}