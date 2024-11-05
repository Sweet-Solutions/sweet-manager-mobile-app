import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Customerservice{
  final String baseUrl;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Customerservice(this.baseUrl);

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


  // POST /api/customer/create-customer
  Future<dynamic> createCustomer(Map<String, dynamic> customer) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/customer/create'),
      headers: headers,
      body: json.encode(customer),
    );

    print('POST /api/customer/create response status: ${response.statusCode}');
    print('POST /api/customer/create response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body.isNotEmpty ? json.decode(response.body) : {};
    } else {
      throw Exception('Failed to create customer: ${response.statusCode} - ${response.body}');
    }
  }

  // PUT /api/customer/update-customer
  Future<dynamic> updateCustomer(int id,Map<String, dynamic> customer) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/api/customer/$id'),
      headers: headers,
      body: json.encode(customer),
    );

    print('PUT /api/customer/$id response status: ${response.statusCode}');
    print('PUT /api/customer/$id response body: ${response.body}');

    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? json.decode(response.body) : {};
    } else {
      throw Exception('Failed to update customer: ${response.statusCode} - ${response.body}');
    }
  }

  // GET /api/customer/get-all/{hotelId}
  Future<List<dynamic>> getCustomerByHotelId(int hotelId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/customer/get-all-customers/$hotelId'),
      headers: headers,
    );

    print('GET /api/customer/get-all-customers/$hotelId response status: ${response.statusCode}');
    print('GET /api/customer/get-all-customers/$hotelId response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load customers by Hotel Id: ${response.statusCode} - ${response.body}');
    }
  }

}