import 'dart:ffi';

import 'package:http/http.dart' as http;

import 'dart:convert';

// Package = dependency

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService{
  final String baseUrl = 'https://sweetmanager-api.ryzeon.me/api/v1/authentication';

  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password, Int roleId) async
  {
    final response = await http.post(Uri.parse('$baseUrl/sign-in'),
    body: {
      'email': email,
      'password': password,
      'rolesId': roleId
    });

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      await storage.write(key: 'token', value: data['token']);

      return true;
    }

    return false;
  }

  Future<void> logout() async{
    await storage.delete(key: 'token');
  }

  Future<bool> isAuthenticated() async{
    final token = await storage.read(key: 'token');

    return token == null? false: true;
  }

}