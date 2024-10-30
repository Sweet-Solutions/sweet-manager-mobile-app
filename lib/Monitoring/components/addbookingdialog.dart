import 'package:flutter/material.dart';
import 'package:sweetmanager/Monitoring/models/booking.dart';
import 'package:sweetmanager/Monitoring/services/bookingservice.dart';

class AddBookingDialog extends StatefulWidget {

  const AddBookingDialog({super.key});

  @override
  _AddBookingDialogState createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {

  late BookingService bookingService = BookingService();
  late TextEditingController paymentCustomerId;
  late TextEditingController roomId;
  late TextEditingController description;
  late TextEditingController priceRoom;
  late TextEditingController nightCount;

  DateTime? startDate;
  DateTime? finalDate;

  @override
  void initState() {
    super.initState();
    paymentCustomerId = TextEditingController();
    roomId = TextEditingController();
    description = TextEditingController();
    priceRoom = TextEditingController();
    nightCount = TextEditingController();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != (isStartDate ? startDate : finalDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          finalDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text("Add new booking"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: paymentCustomerId,
            decoration: const InputDecoration(labelText: 'ClientId'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: roomId,
            decoration: const InputDecoration(labelText: 'RoomId'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: description,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'StartDate',
              hintText: startDate != null ? "${startDate!.toLocal()}".split(' ')[0] : 'Select date',
            ),
            onTap: () => _selectDate(context, true),
          ),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'FinalDate',
              hintText: finalDate != null ? "${finalDate!.toLocal()}".split(' ')[0] : 'Select date',
            ),
            onTap: () => _selectDate(context, false),
          ),
          TextFormField(
            controller: priceRoom,
            decoration: const InputDecoration(labelText: 'Price room'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: nightCount,
            decoration: const InputDecoration(labelText: 'NightCount'),
            keyboardType: TextInputType.number,
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

            if (startDate == null || finalDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please, select date')),
              );
              return;
            }

            final int newPaymentCustomerId = int.parse(paymentCustomerId.text);
            final int newRoomId = int.parse(roomId.text);
            final String newDescription = description.text;
            final double newPriceRoom = double.parse(priceRoom.text);
            final int newNightCount = int.parse(nightCount.text);

            bookingService.createBooking(
              Booking(
                id: 0,
                paymentCustomerId: newPaymentCustomerId,
                roomId: newRoomId,
                description: newDescription,
                startDate: startDate!,
                finalDate: finalDate!,
                priceRoom: newPriceRoom,
                nightCount: newNightCount,
                amount: 0,
                bookingState: ''
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
    paymentCustomerId.dispose();
    roomId.dispose();
    description.dispose();
    priceRoom.dispose();
    nightCount.dispose();
    super.dispose();
  }
}