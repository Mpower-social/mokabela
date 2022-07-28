import 'dart:convert';

List<FormData> formDataFromJson(String str) => List<FormData>.from(json.decode(str).map((x) => FormData.fromJson(x)));

String formDataToJson(List<FormData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FormData {
  FormData({
    this.displayName,
    this.formId,
    this.id,
    this.instanceFilePath,
    this.instanceId,
    this.lastChangeDate,
    this.projectId,
    this.projectName,
    this.xml,
    this.status,
    this.feedback
  });

  String? displayName;
  String? formId;
  int? id;
  String? instanceFilePath;
  String? instanceId;
  int? lastChangeDate;
  String? projectId;
  String? projectName;
  String? xml;
  String? status;
  String? feedback;

  factory FormData.fromJson(Map<String, dynamic> json) => FormData(
    displayName: json["displayName"]??'',
    formId: json["formId"]??'',
    id: json["id"]??0,
    instanceFilePath: json["instanceFilePath"]??'',
    instanceId: json["instanceId"]??'',
    lastChangeDate: json["lastChangeDate"]??0,
    projectId: json["projectId"]??'',
    projectName: json["projectName"]??'N/A',
    xml: json["xml"]??'',
    status: json["status"] ?? 'false',
    feedback: json["feedback"]??'N/A',
  );

  Map<String, dynamic> toJson() => {
    "displayName": displayName??'',
    "formId": formId??'',
    "id": id??0,
    "instanceFilePath": instanceFilePath ??'',
    "instanceId": instanceId??'',
    "lastChangeDate": lastChangeDate ??0,
    "projectId": projectId??'',
    "projectName": projectName??'N/A',
    "xml": xml??'',
    "status": status ?? 'false',
    "feedback": feedback??'',
  };
}
