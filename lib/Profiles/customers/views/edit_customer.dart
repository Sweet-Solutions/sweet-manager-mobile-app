import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/customers/models/customer_model.dart';

class EditCustomerPage extends StatefulWidget {
  final Customer customer;
  final String role; // Added to handle user role

  EditCustomerPage({required this.customer, required this.role});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late String idNumber;
  late String name;
  late String contact;

  @override
  void initState() {
    super.initState();
    idNumber = widget.customer.idNumber;
    name = widget.customer.name;
    contact = widget.customer.contact;
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user has the owner role
    if (widget.role != 'ROLE_OWNER') {
      return Scaffold(
        body: Center(
          child: Text(
            'You do not have permission to edit this customer.',
            style: TextStyle(fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Text(
              'Edit Customer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Space between title and form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: idNumber,
                    decoration: InputDecoration(labelText: 'ID Number'),
                    onChanged: (value) {
                      setState(() {
                        idNumber = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: contact,
                    decoration: InputDecoration(labelText: 'Contact'),
                    onChanged: (value) {
                      setState(() {
                        contact = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.customer.idNumber = idNumber;
                        widget.customer.name = name;
                        widget.customer.contact = contact;
                      });
                      Navigator.pop(context, 'Customer updated successfully');
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
