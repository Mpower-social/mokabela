class AllFormsData {
  String? id;
  String? xFormId;
  String? title;
  String? idString;
  String? createdAt;
  String? updatedAt;
  String? instanceId;
  int? target;
  int? totalSubmission;
  int? projectId;
  String? projectName;
  String? projectDes;
  String? status;
  String? feedback;


  AllFormsData(
      { this.id,
        this.xFormId,
        this.title,
        this.idString,
        this.createdAt,
        this.updatedAt,
        this.instanceId,
        this.target,
        this.projectId,
        this.projectName,
        this.projectDes,
	this.status,
	this.feedback,
	});

  AllFormsData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    xFormId = json['xformId'] ?? '';
    title = json['title'] ?? '';
    idString = json['idString'] ?? '';
    projectId = json['projectId'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt']??'';
    instanceId = json['instanceId']??'';
    target = json['target'] ?? 0;
    projectId = json['projectId'] ?? 0;
    projectName = json['projectName'] ?? '';
    projectDes = json['projectDes'] ?? '';
    status = json['status']??'false';
    feedback = json['feedback']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['xFormId'] = this.xFormId;
    data['title'] = this.title;
    data['idString'] = this.idString;
    data['projectId'] = this.projectId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['target'] = this.target;
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['projectDes'] = this.projectDes;
    data['status'] = this.status;
    return data;
  }

  Map<String, dynamic> toJsonRevertedForm() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['xFormId'] = this.xFormId;
    data['title'] = this.title;
    data['instanceId'] = this.instanceId;
    data['idString'] = this.idString;
    data['projectId'] = this.projectId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['projectId'] = this.projectId;
    data['status'] = this.status;
    data['feedback'] = this.feedback;
    return data;
  }
}