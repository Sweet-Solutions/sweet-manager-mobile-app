import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';

class CustomerService {
  final String baseUrl = 'https://sweetmanager-api.ryzeon.me/api/v1/'; // Base URL

  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('${baseUrl}clients'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((customerJson) => Customer(
        idNumber: customerJson['dni'],
        name: customerJson['nombre'],
        contact: customerJson['contacto'],
      )).toList();
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Customer> getCustomerById(String idNumber) async {
    // Validation for ID number
    if (idNumber.isEmpty) {
      throw Exception('ID number cannot be empty.');
    }

    final response = await http.get(Uri.parse('${baseUrl}clients/$idNumber'));

    if (response.statusCode == 200) {
      var customerJson = json.decode(response.body);
      return Customer(
        idNumber: customerJson['dni'],
        name: customerJson['nombre'],
        contact: customerJson['contacto'],
      );
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    // Validation for customer data
    if (customer.idNumber.isEmpty || customer.name.isEmpty || customer.contact.isEmpty) {
      throw Exception('All fields are required.');
    }

    final response = await http.post(
      Uri.parse('${baseUrl}clients'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'dni': customer.idNumber,
        'nombre': customer.name,
        'contacto': customer.contact,
      }),
    );

    if (response.statusCode == 201) {
      var customerJson = json.decode(response.body);
      return Customer(
        idNumber: customerJson['dni'],
        name: customerJson['nombre'],
        contact: customerJson['contacto'],
      );
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Customer> updateCustomer(String idNumber, Customer customer) async {
    // Validation for ID number
    if (idNumber.isEmpty) {
      throw Exception('ID number cannot be empty.');
    }
    // Validation for customer data
    if (customer.name.isEmpty || customer.contact.isEmpty) {
      throw Exception('All fields are required.');
    }

    final response = await http.put(
      Uri.parse('${baseUrl}clients/$idNumber'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'dni': customer.idNumber,
        'nombre': customer.name,
        'contacto': customer.contact,
      }),
    );

    if (response.statusCode == 200) {
      var customerJson = json.decode(response.body);
      return Customer(
        idNumber: customerJson['dni'],
        name: customerJson['nombre'],
        contact: customerJson['contacto'],
      );
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
