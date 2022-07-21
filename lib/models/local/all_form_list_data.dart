class AllFormsData {
  String? id;
  String? xFormId;
  String? title;
  String? idString;
  String? createdAt;
  int? target;
  int? projectId;
  String? projectName;
  String? projectDes;


  AllFormsData(
      { this.id,
        this.xFormId,
        this.title,
        this.idString,
        this.createdAt,
        this.target,
        this.projectId,
        this.projectName,
        this.projectDes});

  AllFormsData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    xFormId = json['xformId']??'';
    title = json['title']??'';
    idString = json['idString']??'';
    projectId = json['projectId']??'';
    createdAt = json['createdAt']??'';
    target = json['target']??0;
    projectId = json['projectId']??0;
    projectName = json['projectName']??'';
    projectDes = json['projectDes']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['xFormId'] = this.xFormId;
    data['title'] = this.title;
    data['idString'] = this.idString;
    data['projectId'] = this.projectId;
    data['createdAt'] = this.createdAt;
    data['target'] = this.target;
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['projectDes'] = this.projectDes;
    return data;
  }
}