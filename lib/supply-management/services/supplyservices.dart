import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart';

class SupplyService {
  final String baseUrl;
  final AuthService authService;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  SupplyService(this.baseUrl, this.authService);

  // Helper function to get the headers with the token
  Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token is missing. Please log in again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> createSupply(Map<String, dynamic> supply) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/supply'),
      headers: headers,
      body: json.encode(supply),
    );

    print('POST /api/supply response status: ${response.statusCode}');
    print('POST /api/supply response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return {}; // o algún valor por defecto
      }
    } else {
      throw Exception('Failed to create supply: ${response.statusCode} - ${response.body}');
    }
  }

  Future<dynamic> updateSupply(int id, Map<String, dynamic> supply) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/api/supply/$id'),
      headers: headers,
      body: json.encode(supply),
    );

    print('PUT /api/supply/$id response status: ${response.statusCode}');
    print('PUT /api/supply/$id response body: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return {}; // o algún valor por defecto
      }
    } else {
      throw Exception('Failed to update supply: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteSupply(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/supply/$id'),
      headers: headers,
    );

    print('DELETE /api/supply/$id response status: ${response.statusCode}');
    print('DELETE /api/supply/$id response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete supply: ${response.statusCode} - ${response.body}');
    }
  }

  Future<dynamic> getSupplyById(int id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/supply/$id'),
      headers: headers,
    );

    print('GET /api/supply/$id response status: ${response.statusCode}');
    print('GET /api/supply/$id response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supply: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<dynamic>> getSuppliesByHotelId(int hotelId) async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/api/supply/hotelid/$hotelId'),
    headers: headers,
  );

  print('GET /api/supply/hotelid/$hotelId response status: ${response.statusCode}');
  print('GET /api/supply/hotelid/$hotelId response body: ${response.body}');

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load supplies by Hotel ID: ${response.statusCode} - ${response.body}');
  }
}


  Future<List<dynamic>> getSuppliesByProviderId(int providerId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/supply/provider/$providerId'),
      headers: headers,
    );

    print('GET /api/supply/provider/$providerId response status: ${response.statusCode}');
    print('GET /api/supply/provider/$providerId response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supplies by Provider ID: ${response.statusCode} - ${response.body}');
    }
  }
}
