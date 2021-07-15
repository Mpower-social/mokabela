import 'geo_config.dart';

class GeoDefinition {
  GeoDefinition({
    this.configJson,
    this.query,
  });

  GeoConfig? configJson;
  String? query;

  factory GeoDefinition.fromJson(Map<String, dynamic> json) => GeoDefinition(
        configJson: json["config_json"] == null
            ? null
            : GeoConfig.fromJson(json["config_json"]),
        query: json["query"],
      );

  Map<String, dynamic> toJson() => {
        "config_json": configJson?.toJson(),
        "query": query,
      };
}
