import 'package:m_survey/models/local/project_list_data.dart';

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
  bool? isActive;
  bool? isPublished;
  String? feedback;
  String? xml;


  AllFormsData(
      { this.id,
        this.xFormId,
        this.title,
        this.idString,
        this.createdAt,
        this.updatedAt,
        this.instanceId,
        this.target,
        this.totalSubmission,
        this.projectId,
        this.projectName,
        this.projectDes,
        this.isActive,
        this.isPublished,
        this.feedback,
        this.xml});

  AllFormsData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    xFormId = json['xformId']??'';
    title = json['title']??'';
    idString = json['idString']??'';
    projectId = json['projectId']??'';
    createdAt = json['createdAt']??'';
    updatedAt = json['updatedAt']??'';
    instanceId = json['instanceId']??'';
    target = json['target']??0;
    totalSubmission = json['totalSubmission']??0;
    projectId = json['projectId']??0;
    projectName = json['projectName']??'';
    projectDes = json['projectDes']??'';
    isActive = boolean[json['isActive']??0];
    isPublished = boolean[json['isPublished']??0];
    feedback = json['feedback']??'';
    xml = json['xml']??'';
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
    data['isActive'] = this.isActive;
    data['isPublished'] = this.isPublished;
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
    data['status'] = this.isActive;
    data['feedback'] = this.feedback;
    return data;
  }
}