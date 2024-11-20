import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sweetmanager/Monitoring/models/typeroom.dart';
import 'package:http/http.dart' as http;

class TypeRoomService {

  final String baseUrl = 'https://sweetmanager-api.ryzeon.me/api/types-rooms/';

  final storage = const FlutterSecureStorage();

  Future<List<TypeRoom>> getRooms(String hotelId) async {

    final token = await storage.read(key: 'token');

    final response = await http.get(
        Uri.parse('${baseUrl}get-all-types-rooms?hotelId=$hotelId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {

      List<dynamic> data = json.decode(response.body);

      return data.map((roomJson) => TypeRoom(
          id: roomJson['id'],
          name: roomJson['name']
      )).toList();

    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}