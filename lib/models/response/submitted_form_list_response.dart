class SubmittedFormListResponse {
  int? id;
  String? formName;
  String? formIdString;
  int? projectId;
  String? dateCreated;
  String? dateUpdated;
  String? instanceId;
  SubmittedBy? submittedBy;
  String? xml;

  SubmittedFormListResponse(
      {this.id,
        this.formName,
        this.formIdString,
        this.projectId,
        this.dateCreated,
        this.submittedBy,
        this.xml});

  SubmittedFormListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formName = json['form_name'];
    formIdString = json['form_id_string'];
    projectId = json['project_id'];
    dateCreated = json['date_created'];
    dateUpdated = json['date_modified'];
    instanceId = json['uuid'];
    submittedBy = json['submitted_by'] != null
        ? new SubmittedBy.fromJson(json['submitted_by'])
        : null;
    xml = json['xml'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['form_name'] = this.formName;
    data['form_id_string'] = this.formIdString;
    data['project_id'] = this.projectId;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateUpdated;
    data['uuid'] = this.instanceId;
    if (this.submittedBy != null) {
      data['submitted_by'] = this.submittedBy!.toJson();
    }
    data['xml'] = this.xml;
    return data;
  }
}

class SubmittedBy {
  int? id;
  String? username;
  String? firstName;
  String? lastName;

  SubmittedBy({this.id, this.username, this.firstName, this.lastName});

  SubmittedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}