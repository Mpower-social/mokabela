class Datasource {
  Datasource({
    this.configJson,
    this.query,
    this.type,
  });

  String? configJson;
  String? query;
  int? type;

  factory Datasource.fromJson(Map<String, dynamic> json) => Datasource(
        configJson: json["config_json"],
        query: json["query"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "config_json": configJson,
        "query": query,
        "type": type,
      };
}
