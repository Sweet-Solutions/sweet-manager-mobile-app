import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

import '../components/editroomdialog.dart';
import '../models/room.dart';
import '../services/roomservice.dart';

class TableRoom extends StatelessWidget {

  final storage = const FlutterSecureStorage();

  const TableRoom({super.key});

  Future<String?> _getRole() async
  {
    String? token = await storage.read(key: 'token');

    Map<String,dynamic> decodedToken = JwtDecoder.decode(token!);

    return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
  }

  Widget getContentView(BuildContext context) {

    return Scaffold(
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            String? role = snapshot.data;

            return BaseLayout(
                role: role,
                childScreen: getContentView(context)
            );
          }

          return const Center(child: Text('Unable to get information', textAlign: TextAlign.center,));
        }
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