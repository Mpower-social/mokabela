class UserInfoResponse {
  UserInfoResponse({
    this.data,
  });

  Data? data;

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) => UserInfoResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.type,
    this.id,
    this.attributes,
  });

  String? type;
  String? id;
  Attributes? attributes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.contactNo,
    this.password,
    this.keyCloakReferenceId,
    this.organization,
    this.roles,
  });

  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNo;
  String? password;
  String? keyCloakReferenceId;
  Organization? organization;
  List<Role>? roles;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    id: json["id"] ?? '',
    username: json["username"] ?? '',
    firstName: json["firstName"] ?? '',
    lastName: json["lastName"] ?? '',
    email: json["email"] ?? '',
    contactNo: json["contactNo"] ?? '',
    password: json["password"] ?? '',
    keyCloakReferenceId: json["keyCloakReferenceId"] ?? '',
    organization: json["organization"] == null ? null : Organization.fromJson(json["organization"]),
    roles: json["roles"] == null ? null : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "username": username ?? '',
    "firstName": firstName ?? '',
    "lastName": lastName ?? '',
    "email": email ?? '',
    "contactNo": contactNo ?? '',
    "password": password ?? '',
    "keyCloakReferenceId": keyCloakReferenceId ?? '',
    "organization": organization == null ? null : organization!.toJson(),
    "roles": roles == null ? null : List<dynamic>.from(roles!.map((x) => x.toJson())),
  };
}

class Organization {
  Organization({
    this.id,
    this.name,
    this.website,
    this.organizationSize,
    this.address,
  });

  int? id;
  String? name;
  String? website;
  int? organizationSize;
  String? address;

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    website: json["website"] ?? '',
    organizationSize: json["organizationSize"] ?? 0,
    address: json["address"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? 0,
    "name": name ?? '',
    "website": website ?? '',
    "organizationSize": organizationSize ?? 0,
    "address": address ?? '',
  };
}

class Role {
  Role({
    this.id,
    this.name,
    this.keyCloakReferenceId,
    this.userRole,
  });

  int? id;
  String? name;
  String? keyCloakReferenceId;
  UserRole? userRole;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    keyCloakReferenceId: json["keyCloakReferenceId"] ?? '',
    userRole: json["UserRole"] == null ? null : UserRole.fromJson(json["UserRole"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "name": name ?? '',
    "keyCloakReferenceId": keyCloakReferenceId ?? '',
    "UserRole": userRole == null ? null : userRole!.toJson(),
  };
}

class UserRole {
  UserRole({
    this.roleId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  int? roleId;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
    roleId: json["roleId"] ?? '',
    userId: json["userId"] ?? '',
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId ?? '',
    "userId": userId ?? '',
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
