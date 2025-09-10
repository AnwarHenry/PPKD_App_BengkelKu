import 'dart:convert';

import 'package:aplikasi_bengkel_motor/api/endpoint/endpoint.dart';
import 'package:aplikasi_bengkel_motor/models/service_model.dart';
import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class ServiceApi {
  // =================== BOOKING OPERATIONS ===================

  // Book a Service
  static Future<BookingResponse> bookingService({
    required String bookingDate,
    required String vehicleType,
    required String description,
  }) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.bookingServis);

      print("🔍 Booking API Call:");
      print("URL: $url");
      print("Token: ${token != null ? 'Available' : 'Missing'}");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "booking_date": bookingDate,
          "vehicle_type": vehicleType,
          "description": description,
        }),
      );

      print("📊 Booking Response Status: ${response.statusCode}");
      print("📊 Booking Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Booking gagal");
      }
    } catch (e) {
      print("❌ Booking Error: $e");
      throw Exception("Connection error: $e");
    }
  }

  // NEW: Get All Bookings
  static Future<BookingListResponse> getAllBookings() async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.bookingServis);

      print("🔍 Get All Bookings API Call:");
      print("URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📊 Bookings Response Status: ${response.statusCode}");
      print("📊 Bookings Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return BookingListResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil data booking");
      }
    } catch (e) {
      print("❌ Get Bookings Error: $e");
      throw Exception("Connection error: $e");
    }
  }

  // NEW: Update Booking
  static Future<BookingResponse> updateBooking({
    required int bookingId,
    required String bookingDate,
    required String vehicleType,
    required String description,
  }) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.updateBooking(bookingId));

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "booking_date": bookingDate,
          "vehicle_type": vehicleType,
          "description": description,
        }),
      );

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengupdate booking");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }

  // NEW: Delete Booking
  static Future<ServiceResponse> deleteBooking(int bookingId) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.deleteBooking(bookingId));

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return ServiceResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal menghapus booking");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }

  // NEW: Convert Booking to Service
  static Future<ServiceResponse> convertBookingToService(int bookingId) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.convertBookingToService(bookingId));

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return ServiceResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(
          error["message"] ?? "Gagal konversi booking ke service",
        );
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }

  // =================== SERVICE OPERATIONS ===================

  // Create Service
  static Future<ServiceResponse> createService({
    required String vehicleType,
    required String complaint,
  }) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.servis);

      print("🔍 Create Service API Call:");
      print("URL: $url");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "vehicle_type": vehicleType,
          "complaint": complaint,
        }),
      );

      print("📊 Create Service Response Status: ${response.statusCode}");
      print("📊 Create Service Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return ServiceResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal membuat servis");
      }
    } catch (e) {
      print("❌ Create Service Error: $e");
      throw Exception("Connection error: $e");
    }
  }

  // Get All Services
  static Future<ServiceListResponse> getAllServices() async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.servis);

      print("🔍 Get All Services API Call:");
      print("URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📊 Services Response Status: ${response.statusCode}");
      print("📊 Services Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return ServiceListResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil data servis");
      }
    } catch (e) {
      print("❌ Get Services Error: $e");
      throw Exception("Connection error: $e");
    }
  }

  // Update Service Status
  static Future<ServiceResponse> updateServiceStatus({
    required int serviceId,
    required String status,
  }) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.servisStatus(serviceId));

      print("🔍 Update Status API Call:");
      print("URL: $url");
      print("Status: $status");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({"status": status}),
      );

      print("📊 Update Status Response Status: ${response.statusCode}");
      print("📊 Update Status Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return ServiceResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengupdate status servis");
      }
    } catch (e) {
      print("❌ Update Status Error: $e");
      throw Exception("Connection error: $e");
    }
  }

  // Get Service Status
  static Future<ServiceStatusResponse> getServiceStatus(int serviceId) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.servisStatus(serviceId));

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return ServiceStatusResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil status servis");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }

  // Get Service History
  static Future<ServiceListResponse> getServiceHistory() async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.riwayatServis);

      print("🔍 Get Service History API Call:");
      print("URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📊 History Response Status: ${response.statusCode}");
      print("📊 History Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return ServiceListResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil riwayat servis");
      }
    } catch (e) {
      print("❌ Get History Error: $e");
      throw Exception("Connection error: $e");
    }
  }

  // Delete Service
  static Future<ServiceResponse> deleteService(int serviceId) async {
    try {
      final token = await SharedPreference.getToken();
      final url = Uri.parse(Endpoint.deleteServis(serviceId));

      print("🔍 Delete Service API Call:");
      print("URL: $url");
      print("Service ID: $serviceId");

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📊 Delete Service Response Status: ${response.statusCode}");
      print("📊 Delete Service Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return ServiceResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal menghapus servis");
      }
    } catch (e) {
      print("❌ Delete Service Error: $e");
      throw Exception("Connection error: $e");
    }
  }
}
