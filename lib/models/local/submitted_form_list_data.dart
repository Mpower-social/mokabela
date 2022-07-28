class SubmittedFormListData {
  SubmittedFormListData({
    this.id,
    this.formName,
    this.formIdString,
    this.projectId,
    this.dateCreated,
    this.submittedById,
    this.submittedByUsername,
    this.submittedByFirstLame,
    this.submittedByLastName,
    this.instanceId,
    this.xml,
  });

  int? id;
  String? formName;
  String? formIdString;
  int? projectId;
  String? dateCreated;
  int? submittedById;
  String? submittedByUsername;
  String? submittedByFirstLame;
  String? submittedByLastName;
  String? instanceId;

  String? xml;

  factory SubmittedFormListData.fromJson(Map<String, dynamic> json) => SubmittedFormListData(
    id: json["id"]??0,
    formName: json["form_name"]??'',
    formIdString: json["form_id_string"]??'',
    projectId: json["project_id"]??0,
    dateCreated: json["date_created"]??'',
    submittedById: json["submitted_by_id"]??0,
    submittedByUsername: json["submitted_by_username"]??'',
    submittedByFirstLame: json["submitted_by_f_name"] ??'',
    submittedByLastName: json["submitted_by_l_name"]??'',
    instanceId: json["instanceId"]??'',
    xml: json["xml"] == null ? null : json["xml"],
  );



  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_name": formName??'',
    "form_id_string": formIdString??'',
    "project_id": projectId??0,
    "date_created": dateCreated??'',
    "submitted_by_id": submittedById??0,
    "submitted_by_username": submittedByUsername??'',
    "submitted_by_f_name": submittedByFirstLame??'',
    "submitted_by_l_name": submittedByLastName??'',
    "instanceId": instanceId??'',
    "xml": xml == null ? null : xml,
  };
}