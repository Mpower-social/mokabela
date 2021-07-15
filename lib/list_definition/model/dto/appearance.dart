class Appearance {
  Appearance({
    required this.searchable,
  });

  bool searchable;

  factory Appearance.fromJson(Map<String, dynamic> json) => Appearance(
        searchable: json["searchable"] == null ? false : json["searchable"],
      );

  Map<String, dynamic> toJson() => {
        "searchable": searchable,
      };
}
