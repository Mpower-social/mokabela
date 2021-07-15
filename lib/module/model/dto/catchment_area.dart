/// name : "CHITTAGONG"
/// parent : -1
/// value : 20
/// loc_name : "Division"
/// loc_type : 1
/// id : 32

class CatchmentArea {
  CatchmentArea({
    required this.name,
    required this.parent,
    required this.value,
    required this.locName,
    required this.locType,
    required this.id,
  });

  String name;
  int parent;
  int value;
  String locName;
  int locType;
  int id;

  factory CatchmentArea.fromJson(Map<String, dynamic> json) => CatchmentArea(
        name: json["name"],
        parent: json["parent"],
        value: json["value"],
        locName: json["loc_name"],
        locType: json["loc_type"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "parent": parent,
        "value": value,
        "loc_name": locName,
        "loc_type": locType,
        "id": id,
      };
}
