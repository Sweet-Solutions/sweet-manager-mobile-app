import 'package:flutter/material.dart';

import '../services/room-service.dart';

class TableRoom extends StatelessWidget {

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
                source: RoomService(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}