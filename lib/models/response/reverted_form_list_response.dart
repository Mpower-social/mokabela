import 'dart:convert';

RevertedFormListResponse revertedFormListResponseFromJson(String str) => RevertedFormListResponse.fromJson(json.decode(str));

String revertedFormListResponseToJson(RevertedFormListResponse data) => json.encode(data.toJson());

class RevertedFormListResponse {
  RevertedFormListResponse({
    this.data,
  });

  List<RevertedDatum>? data;

  factory RevertedFormListResponse.fromJson(Map<String, dynamic> json) => RevertedFormListResponse(
    data: json["data"] == null ? null : List<RevertedDatum>.from(json["data"].map((x) => RevertedDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class RevertedDatum {
  RevertedDatum({
    this.type,
    this.id,
    this.attributes,
  });

  String? type;
  String? id;
  RevertedAttributes? attributes;

  factory RevertedDatum.fromJson(Map<String, dynamic> json) => RevertedDatum(
    type: json["type"] == null ? null : json["type"],
    id: json["id"] == null ? null : json["id"],
    attributes: json["attributes"] == null ? null : RevertedAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "id": id == null ? null : id,
    "attributes": attributes == null ? null : attributes!.toJson(),
  };
}

class RevertedAttributes {
  RevertedAttributes({
    this.instanceId,
    this.instanceUuid,
    this.feedback,
    this.updatedAt,
    this.status,
    this.assignedBy,
    this.xform,
  });

  int? instanceId;
  String? instanceUuid;
  String? feedback;
  DateTime? updatedAt;
  String? status;
  AssignedBy? assignedBy;
  Xform? xform;

  factory RevertedAttributes.fromJson(Map<String, dynamic> json) => RevertedAttributes(
    instanceId: json["instanceId"] == null ? null : json["instanceId"],
    instanceUuid: json["instanceUuid"] == null ? null : json["instanceUuid"],
    feedback: json["feedback"] == null ? null : json["feedback"],
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    status: json["status"] == null ? null : json["status"],
    assignedBy: json["assignedBy"] == null ? null : AssignedBy.fromJson(json["assignedBy"]),
    xform: json["xform"] == null ? null : Xform.fromJson(json["xform"]),
  );

  Map<String, dynamic> toJson() => {
    "instanceId": instanceId == null ? null : instanceId,
    "instanceUuid": instanceUuid == null ? null : instanceUuid,
    "feedback": feedback == null ? null : feedback,
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "status": status == null ? null : status,
    "assignedBy": assignedBy == null ? null : assignedBy!.toJson(),
    "xform": xform == null ? null : xform!.toJson(),
  };
}

class AssignedBy {
  AssignedBy({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
  });

  int? id;
  String? username;
  String? firstName;
  String? lastName;

  factory AssignedBy.fromJson(Map<String, dynamic> json) => AssignedBy(
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
  };
}

class Xform {
  Xform({
    this.id,
    this.xformId,
    this.projectId,
    this.idString,
    this.title,
  });

  int? id;
  String? xformId;
  int? projectId;
  String? idString;
  String? title;

  factory Xform.fromJson(Map<String, dynamic> json) => Xform(
    id: json["id"] == null ? null : json["id"],
    xformId: json["xformId"] == null ? null : json["xformId"],
    projectId: json["projectId"] == null ? null : json["projectId"],
    idString: json["idString"] == null ? null : json["idString"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "xformId": xformId == null ? null : xformId,
    "projectId": projectId == null ? null : projectId,
    "idString": idString == null ? null : idString,
    "title": title == null ? null : title,
  };
}
