import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) =>
    GeneralResponse.fromJson(json.decode(str));

class GeneralResponse {
  GeneralResponse({
    required this.id,
    required this.message,
    required this.status,
    required this.dateCreated,
  });

  int id;
  String message;
  int status;
  String dateCreated;

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
        id: json["id"],
        message: json["message"],
        status: json["status"],
        dateCreated: json["date_created"],
      );
}
