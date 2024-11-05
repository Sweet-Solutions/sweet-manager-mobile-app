import 'package:flutter/material.dart';
import 'package:sweetmanager/Monitoring/models/booking.dart';
import 'package:sweetmanager/Monitoring/services/bookingservice.dart';

class EditBookingDialog extends StatefulWidget {
  final int id;
  final String bookingState;

  const EditBookingDialog({
    super.key,
    required this.id,
    required this.bookingState,
  });

  @override
  _EditBookingDialogState createState() => _EditBookingDialogState();
}

class _EditBookingDialogState extends State<EditBookingDialog> {
  late BookingService bookingService = BookingService();
  late TextEditingController idController;
  late TextEditingController bookingStateController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.id.toString());
    bookingStateController = TextEditingController(text: widget.bookingState);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update booking state"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: idController,
            decoration: const InputDecoration(labelText: 'Id'),
            readOnly: true,
          ),
          TextFormField(
            controller: bookingStateController,
            decoration: const InputDecoration(labelText: 'BookingState'),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Accept"),
          onPressed: () {

            final String updatedBookingState = bookingStateController.text;

            bookingService.updateBooking(
              widget.id,
              Booking(
                id: widget.id,
                paymentCustomerId: 0,
                roomId: 0,
                description: '',
                startDate: DateTime.now(),
                finalDate: DateTime.now(),
                priceRoom: 0,
                nightCount: 0,
                amount: 0,
                bookingState: updatedBookingState,
              ),
            );

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    idController.dispose();
    bookingStateController.dispose();
    super.dispose();
  }
}
