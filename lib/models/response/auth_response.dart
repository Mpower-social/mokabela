import 'dart:convert';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  AuthResponse({
    this.refreshToken,
    this.token,
    this.clientId,
    this.header,
    this.content,
    this.signature,
    this.signed,
  });
  RefreshToken? refreshToken;
  String? token;
  String? clientId;
  Header? header;
  Content? content;
  Signature? signature;
  String? signed;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    refreshToken: json["refresh_token"] == null ? null : RefreshToken.fromJson(json["refresh_token"]),
    token: json["token"] ?? '',
    clientId: json["clientId"]??'',
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    signature: json["signature"] == null ? null : Signature.fromJson(json["signature"]),
    signed: json["signed"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "token": token ?? '',
    "clientId": clientId ?? '',
    "header": header == null ? null : header!.toJson(),
    "content": content == null ? null : content!.toJson(),
    "signature": signature == null ? null : signature!.toJson(),
    "signed": signed ?? '',
  };
}

class Content {
  Content({
    this.exp,
    this.iat,
    this.jti,
    this.iss,
    this.aud,
    this.sub,
    this.typ,
    this.azp,
    this.sessionState,
    this.acr,
    this.allowedOrigins,
    this.realmAccess,
    this.resourceAccess,
    this.scope,
    this.emailVerified,
    this.name,
    this.preferredUsername,
    this.givenName,
    this.familyName,
    this.email,
  });

  int? exp;
  int? iat;
  String? jti;
  String? iss;
  String? aud;
  String? sub;
  String? typ;
  String? azp;
  String? sessionState;
  String? acr;
  List<String>? allowedOrigins;
  RealmAccess? realmAccess;
  ResourceAccess? resourceAccess;
  String? scope;
  bool? emailVerified;
  String? name;
  String? preferredUsername;
  String? givenName;
  String? familyName;
  String? email;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    exp: json["exp"] ?? 0,
    iat: json["iat"] ?? 0,
    jti: json["jti"] ?? '',
    iss: json["iss"] ?? '',
    aud: json["aud"] ?? '',
    sub: json["sub"] ?? '',
    typ: json["typ"] ?? '',
    azp: json["azp"] ?? '',
    sessionState: json["session_state"] ?? '',
    acr: json["acr"] ?? '',
    allowedOrigins: json["allowed-origins"] == null ? null : List<String>.from(json["allowed-origins"].map((x) => x)),
    realmAccess: json["realm_access"] == null ? null : RealmAccess.fromJson(json["realm_access"]),
    resourceAccess: json["resource_access"] == null ? null : ResourceAccess.fromJson(json["resource_access"]),
    scope: json["scope"] ?? '',
    emailVerified: json["email_verified"] ?? false,
    name: json["name"] ?? '',
    preferredUsername: json["preferred_username"] ?? '',
    givenName: json["given_name"] ?? '',
    familyName: json["family_name"] ?? '',
    email: json["email"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "exp": exp ?? 0,
    "iat": iat ?? 0,
    "jti": jti ?? '',
    "iss": iss ?? '',
    "aud": aud ?? '',
    "sub": sub ?? '',
    "typ": typ ?? '',
    "azp": azp ?? '',
    "session_state": sessionState ?? '',
    "acr": acr ?? '',
    "allowed-origins": allowedOrigins == null ? null : List<dynamic>.from(allowedOrigins!.map((x) => x)),
    "realm_access": realmAccess == null ? null : realmAccess!.toJson(),
    "resource_access": resourceAccess == null ? null : resourceAccess!.toJson(),
    "scope": scope ?? '',
    "email_verified": emailVerified ?? '',
    "name": name ?? '',
    "preferred_username": preferredUsername ?? '',
    "given_name": givenName ?? '',
    "family_name": familyName ?? '',
    "email": email ?? '',
  };
}

class RealmAccess {
  RealmAccess({
    this.roles,
  });

  List<String>? roles;

  factory RealmAccess.fromJson(Map<String, dynamic> json) => RealmAccess(
    roles: json["roles"] == null ? null : List<String>.from(json["roles"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "roles": roles == null ? null : List<dynamic>.from(roles!.map((x) => x)),
  };
}

class ResourceAccess {
  ResourceAccess({
    this.account,
  });

  RealmAccess? account;

  factory ResourceAccess.fromJson(Map<String, dynamic> json) => ResourceAccess(
    account: json["account"] == null ? null : RealmAccess.fromJson(json["account"]),
  );

  Map<String, dynamic> toJson() => {
    "account": account == null ? null : account!.toJson(),
  };
}

class RefreshToken {
  RefreshToken({
    this.token,
  });

  String? token;

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
  };
}

class Header {
  Header({
    this.alg,
    this.typ,
    this.kid,
  });

  String? alg;
  String? typ;
  String? kid;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    alg: json["alg"] ?? '',
    typ: json["typ"] ?? '',
    kid: json["kid"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "alg": alg ?? '',
    "typ": typ ?? '',
    "kid": kid ?? '',
  };
}

class Signature {
  Signature({
    this.type,
    this.data,
  });

  String? type;
  List<int>? data;

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
    type: json["type"] ?? '',
    data: json["data"] == null ? null : List<int>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type ?? '',
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
  };
}
