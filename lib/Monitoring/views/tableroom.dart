import 'package:flutter/material.dart';

import '../components/editroomdialog.dart';
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

  late RoomService roomService;
  late List<Room> _data = [];
  final BuildContext context;

  DataTableRoom(this.context);

  Future<void> initState() async {

    roomService = RoomService();
    _data = await roomService.getRooms();
  }

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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditRoomDialog(
                id: data.id,
                typeRoomId: data.typeRoomId,
                hotelId: data.hotelId,
                roomState: data.roomState,
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