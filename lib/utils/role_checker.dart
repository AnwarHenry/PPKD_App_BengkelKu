import 'dart:convert';

import 'package:aplikasi_bengkel_motor/preference/shared_preference.dart';

class RoleChecker {
  static Future<String?> getUserRole() async {
    final userJson = await PreferenceHandler.getUser();
    if (userJson == null) return null;

    try {
      final userData = json.decode(userJson);
      return userData['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  static Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'admin';
  }

  static Future<bool> isUser() async {
    final role = await getUserRole();
    return role == 'user';
  }

  // Method untuk mendapatkan data user lengkap
  static Future<Map<String, dynamic>?> getUserData() async {
    final userJson = await PreferenceHandler.getUser();
    if (userJson == null) return null;

    try {
      return json.decode(userJson);
    } catch (e) {
      return null;
    }
  }
}
