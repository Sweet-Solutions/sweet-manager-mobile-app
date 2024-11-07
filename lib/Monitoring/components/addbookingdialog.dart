import 'package:flutter/material.dart';
import 'package:sweetmanager/Monitoring/models/booking.dart';
import 'package:sweetmanager/Monitoring/models/customerr.dart';
import 'package:sweetmanager/Monitoring/services/bookingservice.dart';

class AddBookingDialog extends StatefulWidget {

  const AddBookingDialog({super.key});

  @override
  _AddBookingDialogState createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {

  late BookingService bookingService = BookingService();
  late TextEditingController customerId;
  late TextEditingController username;
  late TextEditingController name;
  late TextEditingController surname;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController state;
  late TextEditingController roomId;
  late TextEditingController description;
  late TextEditingController priceRoom;
  late TextEditingController nightCount;

  DateTime? startDate;
  DateTime? finalDate;

  @override
  void initState() {
    super.initState();
    customerId = TextEditingController();
    username = TextEditingController();
    name = TextEditingController();
    surname = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    state = TextEditingController();
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
            controller: customerId,
            decoration: const InputDecoration(labelText: 'ClientId'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: username,
            decoration: const InputDecoration(labelText: 'Username')
          ),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Name')
          ),
          TextFormField(
            controller: surname,
            decoration: const InputDecoration(labelText: 'Surname')
          ),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(labelText: 'Email')
          ),
          TextFormField(
            controller: phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.number
          ),
          TextFormField(
            controller: state,
            decoration: const InputDecoration(labelText: 'State')
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
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text("Accept"),
          onPressed: () async {

            if (startDate == null || finalDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please, select date')),
              );
              return;
            }

            await bookingService.createBooking(
              Booking(
                id: 0,
                paymentCustomerId: 0,
                roomId: int.parse(roomId.text),
                description: description.text,
                startDate: startDate!,
                finalDate: finalDate!,
                priceRoom: double.parse(priceRoom.text),
                nightCount: int.parse(nightCount.text),
                amount: 0,
                bookingState: ''
              ),
              Customerr(
                id : int.parse(customerId.text),
                username: username.text,
                name: name.text,
                surname: surname.text,
                email: email.text,
                phone: int.parse(phone.text),
                state: state.text
              )
            );

            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    customerId.dispose();
    roomId.dispose();
    description.dispose();
    priceRoom.dispose();
    nightCount.dispose();
    super.dispose();
  }
}