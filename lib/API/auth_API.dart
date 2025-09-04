import 'dart:convert';

import 'package:aplikasi_bengkel_motor/API/endpoint/bengkel_endpoint.dart';
import 'package:aplikasi_bengkel_motor/model/api_response.dart';
import 'package:aplikasi_bengkel_motor/model/booking_model.dart';
import 'package:aplikasi_bengkel_motor/model/service_model.dart';
import 'package:aplikasi_bengkel_motor/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BengkelAPI {
  // Debug method untuk mengecek endpoint
  static void _debugEndpoint(String endpoint, String baseUrl) {
    print('🔗 $endpoint: $baseUrl');
  }

  // Helper method untuk mendapatkan headers
  static Map<String, String> getBaseHeaders() {
    return {"Accept": "application/json", "Content-Type": "application/json"};
  }

  // Helper method untuk mendapatkan headers dengan token
  static Future<Map<String, String>> _getHeaders() async {
    final headers = getBaseHeaders();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  // ============ AUTH METHODS ============ //

  // REGISTER - CREATE
  static Future<ApiResponse<UserAuthResponse>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final baseUrl = Endpoints.register;
    _debugEndpoint('REGISTER', baseUrl);

    try {
      final requestBody = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      };

      print('📤 Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: getBaseHeaders(),
        body: json.encode(requestBody),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Registration successful',
          data: UserAuthResponse.fromJson(responseData['data'] ?? responseData),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            errorData["error"] ??
            "Register gagal: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Register Error: $e');
      rethrow;
    }
  }

  // LOGIN - CREATE (Session)
  static Future<ApiResponse<UserAuthResponse>> loginUser({
    required String email,
    required String password,
  }) async {
    final baseUrl = Endpoints.login;
    _debugEndpoint('LOGIN', baseUrl);

    try {
      final requestBody = {"email": email, "password": password};

      print('📤 Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: getBaseHeaders(),
        body: json.encode(requestBody),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Login successful',
          data: UserAuthResponse.fromJson(responseData['data'] ?? responseData),
        );
      } else if (response.statusCode == 401) {
        throw Exception("Email atau password salah");
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            errorData["error"] ??
            "Login gagal: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Login Error: $e');
      rethrow;
    }
  }

  // GET USER PROFILE
  static Future<ApiResponse<UserModel>> getUserProfile() async {
    final baseUrl = Endpoints.profile;
    _debugEndpoint('GET USER PROFILE', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Profile retrieved successfully',
          data: UserModel.fromJson(data['data'] ?? data),
        );
      } else if (response.statusCode == 401) {
        throw Exception("Token expired atau invalid");
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil profil user: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get User Profile Error: $e');
      rethrow;
    }
  }

  // CHECK AUTH STATUS
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  // LOGOUT
  static Future<void> logout() async {
    try {
      final headers = await _getHeaders();
      await http.post(Uri.parse(Endpoints.logout), headers: headers);
    } catch (e) {
      print('⚠️ Logout API error: $e');
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
      print('✅ Logout berhasil, token dihapus');
    }
  }

  // ============ SERVIS METHODS ============ //

  // GET ALL SERVIS - READ
  static Future<ApiResponse<List<ServiceModel>>> getServis() async {
    final baseUrl = Endpoints.servis;
    _debugEndpoint('GET SERVIS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<ServiceModel> services = (data['data'] as List)
            .map((item) => ServiceModel.fromJson(item))
            .toList();

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Services retrieved successfully',
          data: services,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil data servis: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get Servis Error: $e');
      rethrow;
    }
  }

  // CREATE SERVIS - CREATE
  static Future<ApiResponse<ServiceModel>> createServis({
    required String name,
    required String description,
    required double price,
    required int durationMinutes,
  }) async {
    final baseUrl = Endpoints.servis;
    _debugEndpoint('CREATE SERVIS', baseUrl);

    try {
      final headers = await _getHeaders();
      final requestBody = {
        "name": name,
        "description": description,
        "price": price,
        "duration_minutes": durationMinutes,
      };

      print('📤 Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Service created successfully',
          data: ServiceModel.fromJson(data['data'] ?? data),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal membuat servis: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Create Servis Error: $e');
      rethrow;
    }
  }

  // UPDATE SERVIS - UPDATE
  static Future<ApiResponse<ServiceModel>> updateServis({
    required int serviceId,
    required String name,
    required String description,
    required double price,
    required int durationMinutes,
  }) async {
    final baseUrl = Endpoints.updateServis(serviceId);
    _debugEndpoint('UPDATE SERVIS', baseUrl);

    try {
      final headers = await _getHeaders();
      final requestBody = {
        "name": name,
        "description": description,
        "price": price,
        "duration_minutes": durationMinutes,
      };

      print('📤 Request Body: $requestBody');

      final response = await http.put(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Service updated successfully',
          data: ServiceModel.fromJson(data['data'] ?? data),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal update servis: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Update Servis Error: $e');
      rethrow;
    }
  }

  // UPDATE SERVIS STATUS - UPDATE
  static Future<ApiResponse<ServiceModel>> updateServisStatus({
    required int id,
    required String status,
  }) async {
    final baseUrl = Endpoints.servisStatus(id);
    _debugEndpoint('UPDATE SERVIS STATUS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode({"status": status}),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Service status updated successfully',
          data: ServiceModel.fromJson(data['data'] ?? data),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal update status servis: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Update Servis Status Error: $e');
      rethrow;
    }
  }

  // DELETE SERVIS - DELETE
  static Future<ApiResponse> deleteServis(int id) async {
    final baseUrl = Endpoints.deleteServis(id);
    _debugEndpoint('DELETE SERVIS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Servis berhasil dihapus',
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal menghapus servis: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Delete Servis Error: $e');
      rethrow;
    }
  }

  // ============ BOOKING METHODS ============ //

  // GET ALL BOOKINGS - READ (Admin)
  static Future<ApiResponse<List<BookingModel>>> getAllBookings() async {
    final baseUrl = Endpoints.adminAllBookings;
    _debugEndpoint('GET ALL BOOKINGS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<BookingModel> bookings = (data['data'] as List)
            .map((item) => BookingModel.fromJson(item))
            .toList();

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Bookings retrieved successfully',
          data: bookings,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil semua booking: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get All Bookings Error: $e');
      rethrow;
    }
  }

  // GET USER BOOKINGS - READ (User)
  static Future<ApiResponse<List<BookingModel>>> getUserBookings() async {
    final baseUrl = Endpoints.bookingServis;
    _debugEndpoint('GET USER BOOKINGS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<BookingModel> bookings = (data['data'] as List)
            .map((item) => BookingModel.fromJson(item))
            .toList();

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'User bookings retrieved successfully',
          data: bookings,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil booking user: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get User Bookings Error: $e');
      rethrow;
    }
  }

  // GET RIWAYAT SERVIS - READ
  static Future<ApiResponse<List<BookingModel>>> getRiwayatServis() async {
    final baseUrl = Endpoints.riwayatServis;
    _debugEndpoint('GET RIWAYAT SERVIS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<BookingModel> bookings = (data['data'] as List)
            .map((item) => BookingModel.fromJson(item))
            .toList();

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Service history retrieved successfully',
          data: bookings,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil riwayat servis: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get Riwayat Servis Error: $e');
      rethrow;
    }
  }

  // CREATE BOOKING - CREATE
  static Future<ApiResponse<BookingModel>> createBooking({
    required String vehicleType,
    required String licensePlate,
    required String serviceType,
    required DateTime scheduledDate,
    String? additionalNotes,
  }) async {
    final baseUrl = Endpoints.bookingServis;
    _debugEndpoint('CREATE BOOKING', baseUrl);

    try {
      final headers = await _getHeaders();
      final requestBody = {
        "vehicle_type": vehicleType,
        "license_plate": licensePlate,
        "service_type": serviceType,
        "scheduled_date": scheduledDate.toIso8601String(),
        "additional_notes": additionalNotes,
      };

      print('📤 Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Booking created successfully',
          data: BookingModel.fromJson(data['data'] ?? data),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal membuat booking: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Create Booking Error: $e');
      rethrow;
    }
  }

  // UPDATE BOOKING STATUS - UPDATE (Admin)
  static Future<ApiResponse<BookingModel>> updateBookingStatus({
    required int bookingId,
    required String status,
  }) async {
    final baseUrl = Endpoints.updateBookingStatus(bookingId);
    _debugEndpoint('UPDATE BOOKING STATUS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode({"status": status}),
      );

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Booking status updated successfully',
          data: BookingModel.fromJson(data['data'] ?? data),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal update status booking: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Update Booking Status Error: $e');
      rethrow;
    }
  }

  // DELETE BOOKING - DELETE
  static Future<ApiResponse> deleteBooking(int bookingId) async {
    final baseUrl = Endpoints.deleteBooking(bookingId);
    _debugEndpoint('DELETE BOOKING', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Booking berhasil dihapus',
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal menghapus booking: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Delete Booking Error: $e');
      rethrow;
    }
  }

  // ============ ADMIN METHODS ============ //

  // GET ADMIN STATS
  static Future<ApiResponse<Map<String, dynamic>>> getAdminStats() async {
    final baseUrl = Endpoints.adminStats;
    _debugEndpoint('GET ADMIN STATS', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Admin stats retrieved successfully',
          data: data['data'] ?? data,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil stats admin: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get Admin Stats Error: $e');
      rethrow;
    }
  }

  // GET ALL SERVICES (Admin)
  static Future<ApiResponse<List<ServiceModel>>> getAllServices() async {
    final baseUrl = Endpoints.adminAllServices;
    _debugEndpoint('GET ALL SERVICES', baseUrl);

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(baseUrl), headers: headers);

      print('📤 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<ServiceModel> services = (data['data'] as List)
            .map((item) => ServiceModel.fromJson(item))
            .toList();

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'All services retrieved successfully',
          data: services,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData["message"] ??
            "Gagal mengambil semua services: ${response.statusCode}";
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Get All Services Error: $e');
      rethrow;
    }
  }
}
