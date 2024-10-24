import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/room.dart';

class RoomService {

  final String baseUrl = 'https://sweetmanager-api.ryzeon.me/api/v1/';

  Future<bool> createRoom(Room room) async {

    if (room.typeRoomId == 0 || room.hotelId == 0 || room.roomState.isEmpty) {

      throw Exception('All fields are required.');
    }

    final response = await http.post(

      Uri.parse('${baseUrl}rooms'),

      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'typeRoomId': room.typeRoomId,
        'hotelId': room.hotelId,
        'roomState': room.roomState,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<bool> updateRoom(int id, Room room) async {

    if (room.typeRoomId == 0 || room.hotelId == 0 || room.roomState.isEmpty) {

      throw Exception('All fields are required.');
    }

    final response = await http.post(

      Uri.parse('${baseUrl}rooms/$id'),

      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'typeRoomId': room.typeRoomId,
        'hotelId': room.hotelId,
        'roomState': room.roomState,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<Room>> getRooms() async {

    final response = await http.get(Uri.parse('${baseUrl}rooms'));

    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);

      return data.map((roomJson) => Room(
        id: roomJson['id'],
        typeRoomId: roomJson['typeRoomId'],
        hotelId: roomJson['hotelId'],
        roomState: roomJson['roomState']
      )).toList();

    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<Room> getRoomById(int id) async {

    if (id == 0) {

      throw Exception('The provider id cannot be 0.');
    }

    final response = await http.get(Uri.parse('${baseUrl}rooms/$id'));

    if (response.statusCode == 200) {

      var roomJson = json.decode(response.body);

      return Room(
          id: roomJson['id'],
          typeRoomId: roomJson['typeRoomId'],
          hotelId: roomJson['hotelId'],
          roomState: roomJson['roomState']
      );
    }
    else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}