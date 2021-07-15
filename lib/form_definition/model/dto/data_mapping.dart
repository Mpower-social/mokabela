class DataMapping {
  DataMapping({
    this.column,
    this.formField,
  });

  String? column;
  String? formField;

  factory DataMapping.fromJson(Map<String, dynamic> json) => DataMapping(
        column: json["column"],
        formField: json["form_field"],
      );

  Map<String, dynamic> toJson() => {
        "column": column,
        "form_field": formField,
      };
}
