/// Bangla : "Main Project"
/// English : "Main Project"

class Label {
  String? bangla;
  String? english;

  Label({
      this.bangla, 
      this.english});

  Label.fromJson(dynamic json) {
    bangla = json["Bangla"];
    english = json["English"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Bangla"] = bangla;
    map["English"] = english;
    return map;
  }

}