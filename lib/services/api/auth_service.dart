import 'dart:convert';

import 'package:aplikasi_bengkel_motor/api/endpoint/endpoint.dart';
import 'package:aplikasi_bengkel_motor/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Register User
  static Future<RegisterResponse> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(Endpoint.register);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return RegisterResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Registrasi gagal");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }

  // Login User
  static Future<LoginResponse> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(Endpoint.login);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception("Email atau password salah");
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Login gagal");
      }
    } catch (e) {
      if (e.toString().contains("Email atau password salah")) {
        throw Exception("Email atau password salah");
      }
      throw Exception("Connection error: $e");
    }
  }

  // Get Profile (if needed in future)
  static Future<UserFinal> getProfile(String token) async {
    try {
      final url = Uri.parse(Endpoint.profile);

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserFinal.fromJson(data["data"]);
      } else {
        final error = json.decode(response.body);
        throw Exception(error["message"] ?? "Gagal mengambil profil");
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }
}
