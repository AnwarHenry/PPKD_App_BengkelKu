class UpdateModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  UpdateModel({required this.success, required this.message, this.data});

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "message": message, "data": data};
  }
}
