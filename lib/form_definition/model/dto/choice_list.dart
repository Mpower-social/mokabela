import 'geo_definition.dart';

class ChoiceList {
  ChoiceList({
    this.division,
    this.geo,
    this.medicine,
    this.staff,
    this.geoDistrict,
    this.geoDivision,
  });

  GeoDefinition? division;
  GeoDefinition? geo;
  GeoDefinition? medicine;
  GeoDefinition? staff;
  GeoDefinition? geoDistrict;
  GeoDefinition? geoDivision;

  factory ChoiceList.fromJson(Map<String, dynamic> json) => ChoiceList(
        division: json["division"] == null
            ? null
            : GeoDefinition.fromJson(json["division"]),
        geo: json["geo"] == null ? null : GeoDefinition.fromJson(json["geo"]),
        medicine: json["medicine"] == null
            ? null
            : GeoDefinition.fromJson(json["medicine"]),
        staff: json["staff"] == null
            ? null
            : GeoDefinition.fromJson(json["staff"]),
        geoDistrict: json["geo_district"] == null
            ? null
            : GeoDefinition.fromJson(json["geo_district"]),
        geoDivision: json["geo_division"] == null
            ? null
            : GeoDefinition.fromJson(json["geo_division"]),
      );

  Map<String, dynamic> toJson() => {
        "division": division?.toJson(),
        "geo": geo?.toJson(),
        "medicine": medicine?.toJson(),
        "staff": staff?.toJson(),
        "geo_district": geoDistrict?.toJson(),
        "geo_division": geoDivision?.toJson(),
      };
}
