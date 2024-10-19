import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/provider_model.dart';

class ProviderService {
  final String baseUrl = 'https://sweetmanager-api.ryzeon.me/api/v1/';

  Future<List<Provider>> getProviders() async {
    final response = await http.get(Uri.parse('${baseUrl}providers'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((providerJson) => Provider(
        name: providerJson['nombre'],
        contact: providerJson['contacto'],
        address: providerJson['direccion'],
        product: providerJson['producto'],
      )).toList();
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Provider> getProviderById(String name) async {
    // Validate the name
    if (name.isEmpty) {
      throw Exception('The provider name cannot be empty.');
    }

    final response = await http.get(Uri.parse('${baseUrl}providers/$name'));

    if (response.statusCode == 200) {
      var providerJson = json.decode(response.body);
      return Provider(
        name: providerJson['nombre'],
        contact: providerJson['contacto'],
        address: providerJson['direccion'],
        product: providerJson['producto'],
      );
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Provider> createProvider(Provider provider) async {
    // Validate provider data
    if (provider.name.isEmpty || provider.contact.isEmpty || provider.address.isEmpty || provider.product.isEmpty) {
      throw Exception('All fields are required.');
    }

    final response = await http.post(
      Uri.parse('${baseUrl}providers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': provider.name,
        'contacto': provider.contact,
        'direccion': provider.address,
        'producto': provider.product,
      }),
    );

    if (response.statusCode == 201) {
      var providerJson = json.decode(response.body);
      return Provider(
        name: providerJson['nombre'],
        contact: providerJson['contacto'],
        address: providerJson['direccion'],
        product: providerJson['producto'],
      );
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Provider> updateProvider(String name, Provider provider) async {
    // Validate the name
    if (name.isEmpty) {
      throw Exception('The provider name cannot be empty.');
    }
    // Validate provider data
    if (provider.contact.isEmpty || provider.address.isEmpty || provider.product.isEmpty) {
      throw Exception('All fields are required.');
    }

    final response = await http.put(
      Uri.parse('${baseUrl}providers/$name'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': provider.name,
        'contacto': provider.contact,
        'direccion': provider.address,
        'producto': provider.product,
      }),
    );

    if (response.statusCode == 200) {
      var providerJson = json.decode(response.body);
      return Provider(
        name: providerJson['nombre'],
        contact: providerJson['contacto'],
        address: providerJson['direccion'],
        product: providerJson['producto'],
      );
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> deleteProvider(String name) async {
    // Validate the name
    if (name.isEmpty) {
      throw Exception('The provider name cannot be empty.');
    }

    final response = await http.delete(Uri.parse('${baseUrl}providers/$name'));

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
