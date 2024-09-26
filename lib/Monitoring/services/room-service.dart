import 'package:flutter/material.dart';
import 'package:sweetmanager/Monitoring/models/room.dart';

class RoomService extends DataTableSource{
  final BuildContext context;

  RoomService(this.context)

  final List<Room> _data = <Room>[
    Room(id: 1, typeRoomId: 2, hotelId: 101, roomState: "BUSY"),
    Room(id: 2, typeRoomId: 1, hotelId: 102, roomState: "FREE")
  ];

  @override
  DataRow? getRow(int index) {
    final data = _data[index];

    return DataRow(cells: [
      DataCell(Text(data.id.toString())),
      DataCell(Text(data.typeRoomId.toString())),
      DataCell(Text(data.hotelId.toString())),
      DataCell(Text(data.roomState.toString())),
      DataCell(TextButton(
        onPressed: (){
          final id = data.id;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Editar habitación"),
                content: Text("Se editará la información de la habitación $id"),
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
        child: const Text("Update")
      ))
    ]);

  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  

}