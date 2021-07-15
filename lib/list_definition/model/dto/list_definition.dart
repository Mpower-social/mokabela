import 'dart:convert' as jsonConvert;

import 'package:app_builder/module/model/dto/label.dart';

import 'column_definition.dart';
import 'data_source.dart';
import 'filter_definition.dart';

List<ListDefinition> listDefinitionsFromJson(String str) =>
    List<ListDefinition>.from(
        jsonConvert.json.decode(str).map((x) => ListDefinition.fromJson(x)));

String listDefinitionsToJson(List<ListDefinition> data) =>
    jsonConvert.json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListDefinition {
  ListDefinition({
    this.listHeader,
    this.datasource,
    this.columnDefinition = const [],
    this.listName,
    required this.id,
    this.filterDefinition = const [],
  });

  Label? listHeader;
  Datasource? datasource;
  List<ColumnDefinition> columnDefinition;
  String? listName;
  int id;
  List<FilterDefinition> filterDefinition;

  factory ListDefinition.fromJson(Map<String, dynamic> json) => ListDefinition(
        listHeader: json["list_header"] == null
            ? null
            : Label.fromJson(json["list_header"]),
        datasource: json["datasource"] == null
            ? null
            : Datasource.fromJson(json["datasource"]),
        columnDefinition: List<ColumnDefinition>.from(
            json["column_definition"].map((x) => ColumnDefinition.fromJson(x))),
        listName: json["list_name"],
        id: json["id"],
        filterDefinition: List<FilterDefinition>.from(
            json["filter_definition"].map((x) => FilterDefinition.fromJson(x))),
      );

  factory ListDefinition.fromLocalJson(Map<String, dynamic> json) =>
      ListDefinition(
        listHeader: json["list_header"] == null
            ? null
            : Label.fromJson(jsonConvert.json.decode(json["list_header"])),
        datasource: json["datasource"] == null
            ? null
            : Datasource.fromJson(jsonConvert.json.decode(json["datasource"])),
        columnDefinition: List<ColumnDefinition>.from(jsonConvert.json
            .decode(json["column_definition"])
            .map((x) => ColumnDefinition.fromJson(x))),
        listName: json["list_name"],
        id: json["id"],
        filterDefinition: List<FilterDefinition>.from(jsonConvert.json
            .decode(json["filter_definition"])
            .map((x) => FilterDefinition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list_header": jsonConvert.json.encode(listHeader?.toJson()),
        "datasource": jsonConvert.json.encode(datasource?.toJson()),
        "column_definition": jsonConvert.json.encode(
            List<dynamic>.from(columnDefinition.map((x) => x.toJson()))),
        "list_name": listName,
        "id": id,
        "filter_definition": jsonConvert.json.encode(
            List<dynamic>.from(filterDefinition.map((x) => x.toJson()))),
      };
}
