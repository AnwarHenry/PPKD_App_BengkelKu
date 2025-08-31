class ServiceModel {
  final int id;
  final String vehicleType;
  final String complaint;
  final String? imageUrl;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.vehicleType,
    required this.complaint,
    this.imageUrl,
    required this.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      vehicleType: json['vehicle_type'],
      complaint: json['complaint'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
