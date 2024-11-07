import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Workerservice {
  final String baseUrl = 'https://sweetmanager-api.ryzeon.me';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Workerservice();

  // Helper function to get headers with the token
  Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read(key: 'token');
    if (token == null || JwtDecoder.isExpired(token)) {
      throw Exception('Token is missing or expired. Please log in again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // POST
  Future<dynamic> createWorker(Map<String, dynamic> workerData) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/authentication/sign-up-worker'),
      headers: headers,
      body: json.encode(workerData),
    );

    print('POST /api/v1/authentication/sign-up-worker response status: ${response.statusCode}');
    print('POST /api/v1/authentication/sign-up-worker response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body.isNotEmpty ? json.decode(response.body) : {};
    } else {
      throw Exception('Failed to create worker: ${response.statusCode} - ${response.body}');
    }
  }

  // GET /api/v1/user/get-all-admins con hotelId como parámetro de consulta
  Future<List<dynamic>> getWorkersByHotelId(int hotelId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/user/get-all-workers?hotelId=$hotelId'),
      headers: headers,
    );

    print('GET /api/v1/user/get-all-workers response status: ${response.statusCode}');
    print('GET /api/v1/user/get-all-workers response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load admins by Hotel ID: ${response.statusCode} - ${response.body}');
    }
  }
}
