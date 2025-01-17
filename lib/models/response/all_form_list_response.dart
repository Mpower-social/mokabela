class AllFormListResponse {
  List<Data>? data;

  AllFormListResponse({this.data});

  AllFormListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? type;
  String? id;
  Attributes? attributes;

  Data({this.type, this.id, this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  int? id;
  String? xformId;
  String? title;
  String? idString;
  int? projectId;
  String? createdAt;
  String? updatedAt;
  int? target;
  Project? project;
  bool? isActive;
  bool? isPublished;

  Attributes(
      {this.id,
        this.xformId,
        this.title,
        this.idString,
        this.projectId,
        this.createdAt,
        this.updatedAt,
        this.target,
        this.project,
        this.isActive,this.isPublished});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xformId = json['xformId'];
    title = json['title'];
    idString = json['idString'];
    projectId = json['projectId'];
    isActive = json['isActive']??false;
    isPublished = json['isPublished']??false;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    target = json['target'];
    project = json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xformId'] = this.xformId;
    data['title'] = this.title;
    data['idString'] = this.idString;
    data['projectId'] = this.projectId;
    data['isActive'] = this.isActive;
    data['isPublished'] = this.isPublished;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['target'] = this.target;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    return data;
  }
}

class Project {
  int? id;
  String? name;
  String? description;

  Project({this.id, this.name, this.description});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
