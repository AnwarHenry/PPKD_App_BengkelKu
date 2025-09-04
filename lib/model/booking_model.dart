class BookingModel {
  final int id;
  final int userId;
  final String userName;
  final String vehicleType;
  final String licensePlate;
  final String serviceType;
  final String status;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String? additionalNotes;
  final double totalCost;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.vehicleType,
    required this.licensePlate,
    required this.serviceType,
    required this.status,
    required this.scheduledDate,
    this.completedDate,
    this.additionalNotes,
    required this.totalCost,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? json['user']['name'] ?? 'Unknown',
      vehicleType: json['vehicle_type'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      serviceType: json['service_type'] ?? json['service']['name'] ?? '',
      status: json['status'] ?? 'pending',
      scheduledDate: DateTime.parse(
        json['scheduled_date'] ?? DateTime.now().toIso8601String(),
      ),
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'])
          : null,
      additionalNotes: json['additional_notes'],
      totalCost: double.parse((json['total_cost'] ?? 0).toString()),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'vehicle_type': vehicleType,
      'license_plate': licensePlate,
      'service_type': serviceType,
      'status': status,
      'scheduled_date': scheduledDate.toIso8601String(),
      'completed_date': completedDate?.toIso8601String(),
      'additional_notes': additionalNotes,
      'total_cost': totalCost,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
