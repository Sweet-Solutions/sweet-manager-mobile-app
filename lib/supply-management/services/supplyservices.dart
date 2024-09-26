import 'dart:convert';
import 'package:http/http.dart' as http;

class SupplyService {
  final String baseUrl;

  SupplyService(this.baseUrl);

  Future<List<dynamic>> getSupplies() async {
    final response = await http.get(Uri.parse('$baseUrl/supplies'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supplies');
    }
  }

  Future<dynamic> getSupplybyId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/supplies/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supply');
    }
  }

  Future<dynamic> getSupplybyProviderId(int providerId) async {
    final response = await http.get(Uri.parse('$baseUrl/supplies/$providerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supply');
    }
  }

  Future<dynamic> createSupply(Map<String, dynamic> supply) async {
    final response = await http.post(
      Uri.parse('$baseUrl/supplies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(supply),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create supply');
    }
  }

  Future<dynamic> updateSupply(int id, Map<String, dynamic> supply) async {
    final response = await http.put(
      Uri.parse('$baseUrl/supplies/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(supply),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update supply');
    }
  }

  Future<void> deleteSupply(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/supplies/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete supply');
    }
  }
}