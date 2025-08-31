import 'dart:convert';

import 'package:aplikasi_bengkel_motor/model/service_model.dart';
import 'package:http/http.dart' as http;

class BengkelAPI {
  static const String baseUrl =
      "http://localhost:3000"; // ganti sesuai endpoint

  // Add Service
  static Future<bool> addService(String vehicleType, String complaint) async {
    final url = Uri.parse("$baseUrl/addService");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"vehicle_type": vehicleType, "complaint": complaint}),
    );

    return response.statusCode == 200;
  }

  // Get History
  static Future<List<ServiceModel>> getHistory() async {
    final url = Uri.parse("$baseUrl/history");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch history");
    }
  }

  // Get Detail by ID
  static Future<ServiceModel> getDetail(int id) async {
    final url = Uri.parse("$baseUrl/history/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ServiceModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch detail");
    }
  }
}
