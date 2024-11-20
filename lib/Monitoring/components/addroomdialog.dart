import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Monitoring/models/room.dart';
import 'package:sweetmanager/Monitoring/services/roomservice.dart';
import 'package:sweetmanager/Monitoring/services/typeroomservice.dart';

import '../models/typeroom.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  _AddRoomDialogState createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {

  final storage = const FlutterSecureStorage();
  late RoomService roomService = RoomService();
  late TypeRoomService typeRoomService = TypeRoomService();
  String? selectedTypeRoomId;
  List<TypeRoom> typeRooms = [];
  bool isLoading = true;
  late TextEditingController roomState;

  @override
  void initState() {
    super.initState();
    roomState = TextEditingController();

    fetchTypeRooms();
  }

  Future<void> fetchTypeRooms() async {
    try {
      final rooms = await typeRoomService
          .getTypesRooms(await _getHotelId() as String);
      setState(() {
        typeRooms = rooms;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar los tipos de habitaciones: $e');
    }
  }

  Future<String?> _getHotelId() async {
    String? token = await storage.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new room"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedTypeRoomId,
            onChanged: (value) {
              setState(() {
                selectedTypeRoomId = value;
              });
            },
            items: typeRooms.map((room) {
              return DropdownMenuItem<String>(
                value: room.id.toString(),
                child: Text(room.name),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Type Room ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: roomState,
            decoration: const InputDecoration(
              labelText: 'Room State',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text("Accept"),
          onPressed: () async {

            final int newTypeRoomId = int.parse(selectedTypeRoomId!);
            final int newHotelId = (await _getHotelId()) as int;
            final String newRoomState = roomState.text;

            await roomService.createRoom(
              Room(
                id: 0,
                typeRoomId: newTypeRoomId,
                hotelId: newHotelId,
                roomState: newRoomState,
              ),
            );

            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    roomState.dispose();
    super.dispose();
  }
}
