class ProjectListResponse {
  ProjectListResponse({
    this.meta,
    this.data,
  });

  Meta? meta;
  List<Datum>? data;

  factory ProjectListResponse.fromJson(Map<String, dynamic> json) => ProjectListResponse(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta == null ? null : meta!.toJson(),
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.type,
    this.id,
    this.attributes,
  });

  String? type;
  String? id;
  Attributes? attributes;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: json["type"] ?? '',
    id: json["id"] ?? '',
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type ?? '',
    "id": id ?? '',
    "attributes": attributes == null ? null : attributes!.toJson(),
  };
}

class Attributes {
  Attributes({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.partnerOrganization,
    this.projectStatus,
  });

  int? id;
  String? name;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  List<PartnerOrganization>? partnerOrganization;
  ProjectStatus? projectStatus;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    description: json["description"] ?? '',
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    partnerOrganization: json["partnerOrganization"] == null ? null : List<PartnerOrganization>.from(json["partnerOrganization"].map((x) => PartnerOrganization.fromJson(x))),
    projectStatus: ProjectStatus.fromJson(json["projectStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "name": name ?? '',
    "description": description ?? '',
    "startDate": startDate == null ? null : "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "endDate": endDate == null ? null : "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "partnerOrganization": partnerOrganization == null ? null : List<dynamic>.from(partnerOrganization!.map((x) => x.toJson())),
    "projectStatus": projectStatus,
  };
}

class ProjectStatus {
  ProjectStatus({
    this.id,
    this.name
  });

  int? id;
  String? name;

  factory ProjectStatus.fromJson(Map<String, dynamic> json) => ProjectStatus(
    id: json["id"] ?? '',
      name: json["name"] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "name": name ?? ''
  };
}

class PartnerOrganization {
  PartnerOrganization({
    this.id,
    this.name,
    this.website,
    this.organizationSize,
    this.address,
    this.projectPartner,
  });

  int? id;
  String? name;
  String? website;
  int? organizationSize;
  String? address;
  ProjectPartner? projectPartner;

  factory PartnerOrganization.fromJson(Map<String, dynamic> json) => PartnerOrganization(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    website: json["website"] ?? '',
    organizationSize: json["organizationSize"] ?? '',
    address: json["address"] ?? '',
    projectPartner: json["ProjectPartner"] == null ? null : ProjectPartner.fromJson(json["ProjectPartner"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "name": name ?? '',
    "website": website ?? '',
    "organizationSize": organizationSize ?? '',
    "address": address ?? '',
    "ProjectPartner": projectPartner == null ? null : projectPartner!.toJson(),
  };
}

class ProjectPartner {
  ProjectPartner({
    this.projectId,
    this.orgId,
    this.createdAt,
    this.updatedAt,
  });

  int? projectId;
  int? orgId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ProjectPartner.fromJson(Map<String, dynamic> json) => ProjectPartner(
    projectId: json["projectId"] ?? '',
    orgId: json["orgId"] ?? '',
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "projectId": projectId ?? '',
    "orgId": orgId??'',
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

class Meta {
  Meta({
    this.count,
  });

  int? count;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    count: json["count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "count": count ?? 0,
  };

}
