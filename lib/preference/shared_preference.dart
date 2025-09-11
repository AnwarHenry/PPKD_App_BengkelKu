import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String loginKey = "is_logged_in";
  static const String tokenKey = "auth_token";
  static const String userIdKey = "user_id";
  static const String userNameKey = "user_name";
  static const String userEmailKey = "user_email";
  static const String latestServiceKey = "latest_service";
  static const String latestBookingKey = "latest_booking";

  // Login Methods
  static Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, true);
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
  }

  // Token Methods
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // User Data Methods
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, userName);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<void> saveUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, userEmail);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Update profile user
  static Future<void> saveUserProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile_image', imagePath);
  }

  static Future<String?> getUserProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_profile_image');
  }

  static Future<void> saveUserCreatedAt(String createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_created_at', createdAt);
  }

  static Future<String?> getUserCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_created_at');
  }

  // Service Data Methods
  static Future<void> saveLatestService(
    Map<String, dynamic> serviceData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(latestServiceKey, json.encode(serviceData));
  }

  static Future<Map<String, dynamic>?> getLatestService() async {
    final prefs = await SharedPreferences.getInstance();
    final serviceData = prefs.getString(latestServiceKey);
    if (serviceData != null) {
      try {
        return Map<String, dynamic>.from(json.decode(serviceData));
      } catch (e) {
        print('Error decoding service data: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> removeLatestService() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(latestServiceKey);
  }

  // Booking Data Methods
  static Future<void> saveLatestBooking(
    Map<String, dynamic> bookingData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(latestBookingKey, json.encode(bookingData));
  }

  static Future<Map<String, dynamic>?> getLatestBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingData = prefs.getString(latestBookingKey);
    if (bookingData != null) {
      try {
        return Map<String, dynamic>.from(json.decode(bookingData));
      } catch (e) {
        print('Error decoding booking data: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> removeLatestBooking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(latestBookingKey);
  }

  // Service History Methods
  static Future<void> saveServiceHistory(
    List<Map<String, dynamic>> history,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = json.encode(history);
    await prefs.setString('service_history', historyJson);
  }

  static Future<List<Map<String, dynamic>>?> getServiceHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('service_history');
    if (historyJson != null) {
      try {
        final List<dynamic> historyList = json.decode(historyJson);
        return historyList
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } catch (e) {
        print('Error decoding service history: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> addToServiceHistory(Map<String, dynamic> service) async {
    final existingHistory = await getServiceHistory() ?? [];
    existingHistory.insert(0, service); // Add to beginning of list
    await saveServiceHistory(existingHistory);
  }

  // Save complete user data
  static Future<void> saveUserData({
    required String token,
    required int userId,
    required String userName,
    required String userEmail,
  }) async {
    await saveLogin();
    await saveToken(token);
    await saveUserId(userId);
    await saveUserName(userName);
    await saveUserEmail(userEmail);
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Clear only service data (keep user data)
  static Future<void> clearServiceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(latestServiceKey);
    await prefs.remove(latestBookingKey);
    await prefs.remove('service_history');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final isLogin = await getLogin();
    final token = await getToken();
    return isLogin == true && token != null && token.isNotEmpty;
  }

  // Check if there is service data
  static Future<bool> hasServiceData() async {
    final serviceData = await getLatestService();
    return serviceData != null;
  }

  // Get service status
  static Future<String?> getServiceStatus() async {
    final serviceData = await getLatestService();
    return serviceData?['status']?.toString();
  }

  // Update service status
  static Future<void> updateServiceStatus(String newStatus) async {
    final serviceData = await getLatestService();
    if (serviceData != null) {
      serviceData['status'] = newStatus;
      await saveLatestService(serviceData);
    }
  }

  // Get vehicle information
  static Future<Map<String, dynamic>?> getVehicleInfo() async {
    final serviceData = await getLatestService();
    if (serviceData != null) {
      return {
        'vehicleType': serviceData['vehicleType'],
        'complaint': serviceData['complaint'],
        'bookingDate': serviceData['bookingDate'],
        'status': serviceData['status'],
        'technician': serviceData['technician'],
      };
    }
    return null;
  }

  // Save complete service data with validation
  static Future<void> saveCompleteServiceData({
    required String vehicleType,
    required String complaint,
    required String bookingDate,
    required String status,
    String? technician,
    String? estimatedCompletion,
    String? serviceNotes,
  }) async {
    final serviceData = {
      'vehicleType': vehicleType,
      'complaint': complaint,
      'bookingDate': bookingDate,
      'status': status,
      'technician': technician ?? 'Belum ditentukan',
      'estimatedCompletion': estimatedCompletion,
      'serviceNotes': serviceNotes,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await saveLatestService(serviceData);

    // Also add to history
    await addToServiceHistory(serviceData);
  }

  // Get formatted service data for display
  static Future<Map<String, dynamic>?> getFormattedServiceData() async {
    final serviceData = await getLatestService();
    if (serviceData != null) {
      return {
        'Jenis Kendaraan': serviceData['vehicleType'] ?? 'Tidak diketahui',
        'Keluhan': serviceData['complaint'] ?? 'Tidak ada keluhan',
        'Tanggal Booking': serviceData['bookingDate'] ?? 'Tidak diketahui',
        'Status': serviceData['status'] ?? 'menunggu',
        // 'Teknisi': serviceData['technician'] ?? 'Belum ditentukan',
        // 'Estimasi Selesai':
        //     serviceData['estimatedCompletion'] ?? 'Tidak diketahui',
        // 'Catatan Service': serviceData['serviceNotes'] ?? 'Tidak ada catatan',
      };
    }
    return null;
  }
}
