import 'package:flutter/material.dart';
import 'package:sweetmanager/Monitoring/models/room.dart';
import 'package:sweetmanager/Monitoring/services/roomservice.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  _AddRoomDialogState createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {

  late RoomService roomService = RoomService();
  late TextEditingController typeRoomId;
  late TextEditingController hotelId;
  late TextEditingController roomState;

  @override
  void initState() {
    super.initState();
    typeRoomId = TextEditingController();
    hotelId = TextEditingController();
    roomState = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new room"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: typeRoomId,
            decoration: const InputDecoration(labelText: 'Type Room ID'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: hotelId,
            decoration: const InputDecoration(labelText: 'Hotel ID'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: roomState,
            decoration: const InputDecoration(labelText: 'Room State'),
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

            final int newTypeRoomId = int.parse(typeRoomId.text);
            final int newHotelId = int.parse(hotelId.text);
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
    typeRoomId.dispose();
    hotelId.dispose();
    roomState.dispose();
    super.dispose();
  }
}
