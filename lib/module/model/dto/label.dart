/// Bangla : "Main Project"
/// English : "Main Project"

class Label {
  Label({
    this.bangla,
    this.english,
  });

  String? bangla;
  String? english;

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        bangla: json["Bangla"],
        english: json["English"],
      );

  Map<String, dynamic> toJson() => {
        "Bangla": bangla,
        "English": english,
      };
}
