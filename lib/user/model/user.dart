import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.name,
    required this.role,
    this.branch,
    this.organization,
    required this.userName,
    required this.email,
  });

  String name;
  String role;
  int? branch;
  int? organization;
  String userName;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        role: json["role"],
        branch: json["branch"],
        organization: json["organization"],
        userName: json["user_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "branch": branch,
        "organization": organization,
        "user_name": userName,
        "email": email,
      };
}
