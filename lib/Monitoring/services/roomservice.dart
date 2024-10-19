import 'package:flutter/material.dart';

import '../models/room.dart';

class RoomService extends DataTableSource {

  final BuildContext context;

  RoomService(this.context);

  final List<Room> _data = [
    Room(id: 1, typeRoomId: 2, hotelId: 101, roomState: 'OCUPADO'),
    Room(id: 2, typeRoomId: 1, hotelId: 102, roomState: 'LIBRE'),
  ];

  @override
  DataRow getRow(int index) {

    final data = _data[index];

    return DataRow(cells: [

      DataCell(Text(data.id.toString())),
      DataCell(Text(data.typeRoomId.toString())),
      DataCell(Text(data.hotelId.toString())),
      DataCell(Text(data.roomState.toString())),
      DataCell(TextButton(
        onPressed: () {
          final id = data.id;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Editar habitación"),
                content: Text("Se modificara la información de la habitación $id"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Aceptar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Modificar'),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
}