import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SupplyService {
  final String baseUrl = 'https://sweetmanager-api.ryzeon.me';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  SupplyService();

  // Helper function to get the headers with the token
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

  Future<dynamic> createSupply(Map<String, dynamic> paymentowner) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/create-payment-owner'),
      headers: headers,
      body: json.encode(paymentowner),
    );

    print('POST /create-payment-owner response status: ${response.statusCode}');
    print('POST /create-payment-owner response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body.isNotEmpty ? json.decode(response.body) : {};
    } else {
      throw Exception('Failed to create payment owner: ${response.statusCode} - ${response.body}');
    }
  }

} 