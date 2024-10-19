import 'dart:convert';
import 'package:http/http.dart' as http;

//revisar commits de mauri para ver el tema de token
//usar el flutter storage
//no pushear el pubspec.yaml

class SupplyService {
  final String baseUrl;

  SupplyService(this.baseUrl);


  Future<List<dynamic>> getSupplies() async {
    final response = await http.get(Uri.parse('$baseUrl/api/supply'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supplies');
    }
  }


  Future<dynamic> getSupplyById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/supply/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supply');
    }
  }


  Future<List<dynamic>> getSuppliesByHotelId(int hotelId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/supply/hotelid/$hotelId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supplies by Hotel ID');
    }
  }


  Future<List<dynamic>> getSuppliesByProviderId(int providerId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/supply/provider/$providerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load supplies by Provider ID');
    }
  }


  Future<dynamic> createSupply(Map<String, dynamic> supply) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/supply'),
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
      Uri.parse('$baseUrl/api/supply/$id'),
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
    final response = await http.delete(Uri.parse('$baseUrl/api/supply/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete supply');
    }
  }
}
