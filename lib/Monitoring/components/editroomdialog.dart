import 'package:flutter/material.dart';
import 'package:sweetmanager/Monitoring/models/room.dart';
import 'package:sweetmanager/Monitoring/services/roomservice.dart';

class EditRoomDialog extends StatefulWidget {

  final int id;
  final int typeRoomId;
  final int hotelId;
  final String roomState;

  EditRoomDialog({
    super.key,
    required this.id,
    required this.typeRoomId,
    required this.hotelId,
    required this.roomState,
  });

  @override
  _EditRoomDialogState createState() => _EditRoomDialogState();
}

class _EditRoomDialogState extends State<EditRoomDialog> {


  late RoomService roomService = RoomService();

  late TextEditingController id;
  late TextEditingController typeRoomId;
  late TextEditingController hotelId;
  late TextEditingController roomState;

  @override
  void initState() {
    super.initState();
    id = TextEditingController(text: widget.id.toString());
    typeRoomId = TextEditingController(text: widget.typeRoomId.toString());
    hotelId = TextEditingController(text: widget.hotelId.toString());
    roomState = TextEditingController(text: widget.roomState);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar habitación"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: id,
            decoration: const InputDecoration(labelText: 'ID'),
            readOnly: true,
          ),
          TextFormField(
            controller: typeRoomId,
            decoration: const InputDecoration(labelText: 'Type Room ID'),
          ),
          TextFormField(
            controller: hotelId,
            decoration: const InputDecoration(labelText: 'Hotel ID'),
          ),
          TextFormField(
            controller: roomState,
            decoration: const InputDecoration(labelText: 'Room State'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Aceptar"),
          onPressed: () {

            final String updatedTypeRoomId = typeRoomId.text;
            final String updatedHotelId = hotelId.text;
            final String updatedRoomState = roomState.text;

            roomService.updateRoom(widget.id,
                Room(id: widget.id,typeRoomId: int.parse(updatedTypeRoomId),
                    hotelId: int.parse(updatedHotelId),
                    roomState: updatedRoomState)
            );

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    id.dispose();
    typeRoomId.dispose();
    hotelId.dispose();
    roomState.dispose();
    super.dispose();
  }
}