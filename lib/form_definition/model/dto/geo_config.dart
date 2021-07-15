class GeoConfig {
  GeoConfig({
    this.datasourceTitle,
    this.attributeName,
    this.csvName,
    this.datasourceId,
  });

  String? datasourceTitle;
  String? attributeName;
  String? csvName;
  String? datasourceId;

  factory GeoConfig.fromJson(Map<String, dynamic> json) => GeoConfig(
        datasourceTitle: json["datasource_title"],
        attributeName: json["attribute_name"],
        csvName: json["csv_name"],
        datasourceId: json["datasource_id"],
      );

  Map<String, dynamic> toJson() => {
        "datasource_title": datasourceTitle,
        "attribute_name": attributeName,
        "csv_name": csvName,
        "datasource_id": datasourceId,
      };
}
