import 'dart:convert';

// Booking Service Response Model
BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

String bookingResponseToJson(BookingResponse data) =>
    json.encode(data.toJson());

class BookingResponse {
  String? message;
  BookingData? data;

  BookingResponse({this.message, this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        message: json["message"],
        data: json["data"] == null ? null : BookingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class BookingData {
  int? id;
  String? bookingDate;
  String? vehicleType;
  String? description;
  int? userId;
  String? updatedAt;
  String? createdAt;

  BookingData({
    this.id,
    this.bookingDate,
    this.vehicleType,
    this.description,
    this.userId,
    this.updatedAt,
    this.createdAt,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
        id: _parseToInt(json["id"]),
        bookingDate: json["booking_date"],
        vehicleType: json["vehicle_type"],
        description: json["description"],
        userId: _parseToInt(json["user_id"]),
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_date": bookingDate,
        "vehicle_type": vehicleType,
        "description": description,
        "user_id": userId,
        "updated_at": updatedAt,
        "created_at": createdAt,
      };

  // Helper method to safely parse int from dynamic
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

// Booking List Response Model
BookingListResponse bookingListResponseFromJson(String str) =>
    BookingListResponse.fromJson(json.decode(str));

String bookingListResponseToJson(BookingListResponse data) =>
    json.encode(data.toJson());

class BookingListResponse {
  String? message;
  List<BookingData>? data;

  BookingListResponse({this.message, this.data});

  factory BookingListResponse.fromJson(Map<String, dynamic> json) =>
      BookingListResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<BookingData>.from(
                json["data"].map((x) => BookingData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

// Service Response Model
ServiceResponse serviceResponseFromJson(String str) =>
    ServiceResponse.fromJson(json.decode(str));

String serviceResponseToJson(ServiceResponse data) =>
    json.encode(data.toJson());

class ServiceResponse {
  String? message;
  dynamic data; // Can be single ServiceData or List<ServiceData>

  ServiceResponse({this.message, this.data});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      ServiceResponse(
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}

// Service List Response Model
ServiceListResponse serviceListResponseFromJson(String str) =>
    ServiceListResponse.fromJson(json.decode(str));

String serviceListResponseToJson(ServiceListResponse data) =>
    json.encode(data.toJson());

class ServiceListResponse {
  String? message;
  List<ServiceData>? data;

  ServiceListResponse({this.message, this.data});

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) =>
      ServiceListResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ServiceData>.from(
                json["data"].map((x) => ServiceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ServiceData {
  int? id;
  int? userId;
  int? bookingId; // FIELD BARU untuk tracking booking
  String? vehicleType;
  String? complaint;
  String? status;
  String? createdAt;
  String? updatedAt;

  ServiceData({
    this.id,
    this.userId,
    this.bookingId,
    this.vehicleType,
    this.complaint,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
        id: _parseToInt(json["id"]),
        userId: _parseToInt(json["user_id"]),
        bookingId: _parseToInt(json["booking_id"]), // PARSING AMAN
        vehicleType: json["vehicle_type"],
        complaint: json["complaint"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "booking_id": bookingId,
        "vehicle_type": vehicleType,
        "complaint": complaint,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  Map<String, Object?> toMap() => {
        "id": id,
        "user_id": userId,
        "booking_id": bookingId,
        "vehicle_type": vehicleType,
        "complaint": complaint,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  factory ServiceData.fromMap(Map<String, dynamic> map) => ServiceData(
        id: _parseToInt(map["id"]),
        userId: _parseToInt(map["user_id"]),
        bookingId: _parseToInt(map["booking_id"]),
        vehicleType: map["vehicle_type"],
        complaint: map["complaint"],
        status: map["status"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"],
      );

  // HELPER METHOD UNTUK PARSING AMAN - INI YANG PENTING!
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

// Service Status Response Model
ServiceStatusResponse serviceStatusResponseFinalFromJson(String str) =>
    ServiceStatusResponse.fromJson(json.decode(str));

String serviceStatusResponseFinalToJson(ServiceStatusResponse data) =>
    json.encode(data.toJson());

class ServiceStatusResponse {
  String? message;
  ServiceStatusData? data;

  ServiceStatusResponse({this.message, this.data});

  factory ServiceStatusResponse.fromJson(Map<String, dynamic> json) =>
      ServiceStatusResponse(
        message: json["message"],
        data: json["data"] == null
            ? null
            : ServiceStatusData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class ServiceStatusData {
  String? status;

  ServiceStatusData({this.status});

  factory ServiceStatusData.fromJson(Map<String, dynamic> json) =>
      ServiceStatusData(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
