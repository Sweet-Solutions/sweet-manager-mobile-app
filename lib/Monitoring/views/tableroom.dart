import 'package:flutter/material.dart';

import '../models/room.dart';
import '../services/roomservice.dart';

class TableRoom extends StatelessWidget {

  const TableRoom({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sweet Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: PaginatedDataTable(
                header: const Text('Gestion de habitaciones'),
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return Colors.blue[800]!;
                        },
                ),
                rowsPerPage: 7,
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Tipo habitacion')),
                  DataColumn(label: Text('Hotel')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Opciones'))
                ],
                source: DataTableRoom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataTableRoom extends DataTableSource {

  final BuildContext context;

  DataTableRoom(this.context);

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