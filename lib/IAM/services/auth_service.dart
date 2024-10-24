import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Cambia la URL base para apuntar a tu API local
  final String baseUrl = 'http://localhost:5181/api/v1/authentication'; // Ruta correcta de tu API

  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password, int roleId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sign-in'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'rolesId': roleId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['token']);
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

   // Método de signup modificado para almacenar el ownersId
  Future<bool> signup(
      int id, String username, String name, String surname, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sign-up-owner'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'username': username,
          'name': name,
          'surname': surname,
          'email': email,
          'phone': phone,
          'state': 'ACTIVE',
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extrae el ownersId y token desde la respuesta
        int ownersId = data['id']; // Asume que 'id' es el ownersId que retorna el API
        String token = data['token']; // El token generado para el usuario

        // Almacena el token y el ownersId
        await storage.write(key: 'token', value: token);
        await storage.write(key: 'ownersId', value: ownersId.toString()); // Guarda el ownersId como string

        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  Future<int?> getOwnersId() async {
    final ownersId = await storage.read(key: 'ownersId');
    return ownersId != null ? int.tryParse(ownersId) : null;
  }


  

}


