import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class ProviderService {
  final String baseUrl = 'https://sweetmanager-api.ryzeon.me';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  ProviderService();

  // Helper function to get headers with a token
  Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read(key: 'token');
    if (token == null || JwtDecoder.isExpired(token)) {
      // Optionally: Redirect to login page if needed
      throw Exception('Token is missing or expired. Please log in again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // POST /api/provider/create-provider
  Future<Map<String, dynamic>> createProvider(Map<String, dynamic> provider) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/provider/create-provider'),
        headers: headers,
        body: json.encode(provider),
      );

      print('POST /api/provider/create-provider status: ${response.statusCode}');
      print('POST /api/provider/create-provider body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.body.isNotEmpty ? json.decode(response.body) : {};
      } else {
        throw Exception('Failed to create provider: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in createProvider: $e');
      rethrow;
    }
  }

  // PUT /api/provider/update-provider
  Future<Map<String, dynamic>> updateProvider(Map<String, dynamic> provider) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/provider/update-provider'),
        headers: headers,
        body: json.encode(provider),
      );

      print('PUT /api/provider/update-provider status: ${response.statusCode}');
      print('PUT /api/provider/update-provider body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body.isNotEmpty ? json.decode(response.body) : {};
      } else {
        throw Exception('Failed to update provider: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in updateProvider: $e');
      rethrow;
    }
  }

  // GET /api/provider/get-all/{hotelId}
  Future<List<dynamic>> getProvidersByHotelId(int hotelId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/provider/get-all/$hotelId'),
        headers: headers,
      );

      print('GET /api/provider/get-all/$hotelId status: ${response.statusCode}');
      print('GET /api/provider/get-all/$hotelId body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load providers by Hotel Id: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getProvidersByHotelId: $e');
      return [];  // Returning an empty list in case of error to avoid crashes
    }
  }
}


