import 'dart:convert';

List<Catchment> catchmentsFromJson(dynamic str) =>
    List<Catchment>.from(str.map((x) => Catchment.fromJson(x)));

String catchmentsToJson(List<Catchment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Catchment {
  Catchment({
    this.division,
    this.divisionLabel,
    this.district,
    this.distLabel,
    this.upazila,
    this.upazilaLabel,
  });

  String? division;
  String? divisionLabel;
  String? district;
  String? distLabel;
  String? upazila;
  String? upazilaLabel;

  factory Catchment.fromJson(Map<String, dynamic> json) => Catchment(
        division: json["division"],
        divisionLabel: json["division_label"],
        district: json["district"],
        distLabel: json["dist_label"],
        upazila: json["upazila"],
        upazilaLabel: json["upazila_label"],
      );

  Map<String, dynamic> toJson() => {
        "division": division,
        "division_label": divisionLabel,
        "district": district,
        "dist_label": distLabel,
        "upazila": upazila,
        "upazila_label": upazilaLabel,
      };
}
