import 'dart:convert';

// Register Response Model
RegisterResponse registerResponseFinalFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseFinalToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  String? message;
  RegisterDataFinal? data;

  RegisterResponse({this.message, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        message: json["message"],
        data: json["data"] == null
            ? null
            : RegisterDataFinal.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class RegisterDataFinal {
  String? token;
  UserFinal? user;

  RegisterDataFinal({this.token, this.user});

  factory RegisterDataFinal.fromJson(Map<String, dynamic> json) =>
      RegisterDataFinal(
        token: json["token"],
        user: json["user"] == null ? null : UserFinal.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

// Login Response Model
LoginResponse loginResponseFinalFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseFinalToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  String? message;
  LoginDataFinal? data;

  LoginResponse({this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json["message"],
        data:
            json["data"] == null ? null : LoginDataFinal.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class LoginDataFinal {
  String? token;
  UserFinal? user;

  LoginDataFinal({this.token, this.user});

  factory LoginDataFinal.fromJson(Map<String, dynamic> json) => LoginDataFinal(
        token: json["token"],
        user: json["user"] == null ? null : UserFinal.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

// User Model dengan Safe Parsing
class UserFinal {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UserFinal({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserFinal.fromJson(Map<String, dynamic> json) => UserFinal(
        id: _parseToInt(json["id"]), // PARSING AMAN
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  Map<String, Object?> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  factory UserFinal.fromMap(Map<String, dynamic> map) => UserFinal(
        id: _parseToInt(map["id"]), // PARSING AMAN
        name: map["name"],
        email: map["email"],
        emailVerifiedAt: map["email_verified_at"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"],
      );

  // HELPER METHOD UNTUK PARSING AMAN - MENGATASI STRING->INT ERROR
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
