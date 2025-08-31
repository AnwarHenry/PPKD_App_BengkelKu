class RegisterModel {
  final bool success;
  final String message;
  final String? token;

  RegisterModel({required this.success, required this.message, this.token});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "message": message, "token": token};
  }
}
