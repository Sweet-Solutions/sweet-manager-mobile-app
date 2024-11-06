import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

import '../components/editbookingdialog.dart';
import '../components/addbookingdialog.dart';
import '../models/booking.dart';
import '../services/bookingservice.dart';

class TableBooking extends StatefulWidget {

  const TableBooking({super.key});

  @override
  _TableBooking createState() => _TableBooking();
}

class _TableBooking extends State<TableBooking> {

  final storage = const FlutterSecureStorage();

  late Future<String?> role;
  late Future<String?> hotelId;
  late DataTableBooking dataTableSource;

  @override
  void initState() {
    super.initState();
    role = _getRole();
    hotelId = _getHotelId();
    dataTableSource = DataTableBooking
      (context, _getHotelId() as String, _getRole() == 'ROLE_WORKER');
  }

  Future<String?> _getRole() async {
    String? token = await storage.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
  }

  Future<String?> _getHotelId() async {
    String? token = await storage.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality']?.toString();
  }

  void _refreshTable() {
    setState(() {
      dataTableSource = DataTableBooking
        (context, _getHotelId() as String, _getRole() == 'ROLE_WORKER');
    });
  }

  Widget getContentView(BuildContext context, String hotelId, String? role) {

    bool isWorker = role == 'ROLE_WORKER';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (isWorker)
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddBookingDialog();
                        },
                      );

                      if (result == true) {
                        _refreshTable();
                      }
                    },
                    child: const Text('Add booking'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PaginatedDataTable(
                header: const Text('Bookings'),
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    return Colors.blue[800]!;
                  },
                ),
                rowsPerPage: 7,
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('ClientId')),
                  DataColumn(label: Text('RoomId')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('StartDate')),
                  DataColumn(label: Text('FinalDate')),
                  DataColumn(label: Text('State')),
                  DataColumn(label: Text('Options')),
                ],
                source: DataTableBooking(context, hotelId, isWorker),
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
      future: Future.wait([_getRole(), _getHotelId()]),
      builder: (context, AsyncSnapshot<List<String?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          String? role = snapshot.data![0];
          String? hotelId = snapshot.data![1];
          return BaseLayout(role: role, childScreen: getContentView(context, hotelId!, role));
        }

        return const Center(child: Text('Unable to get information', textAlign: TextAlign.center));
      },
    );
  }
}

class DataTableBooking extends DataTableSource {

  late BookingService bookingService;
  late List<Booking> _data = [];
  final BuildContext context;
  final String hotelId;
  final bool isWorker;

  DataTableBooking(this.context, this.hotelId, this.isWorker) {

    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    bookingService = BookingService();
    _data = await bookingService.getBookingsByHotelId(hotelId as int);
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {

    final data = _data[index];

    return DataRow(cells: [
      DataCell(Text(data.id.toString())),
      DataCell(Text(data.paymentCustomerId.toString())),
      DataCell(Text(data.roomId.toString())),
      DataCell(Text(data.description)),
      DataCell(Text(data.startDate.toString())),
      DataCell(Text(data.finalDate.toString())),
      DataCell(Text(data.bookingState)),
      DataCell(
        isWorker
            ? TextButton(
          onPressed: () async {
            final result = showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditBookingDialog(
                  id: data.id,
                  bookingState: data.bookingState,
                );
              },
            );

            if (result == true){
              _fetchBookings();
            }
          },
          child: const Text('Modification'),
        )
            : const Text('No permitted'),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
}