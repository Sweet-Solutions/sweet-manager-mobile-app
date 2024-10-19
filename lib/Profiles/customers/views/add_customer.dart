import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/customers/models/customer_model.dart';

class AddCustomerPage extends StatefulWidget {
  final String role; // Added to handle user role

  AddCustomerPage({required this.role});

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  String idNumber = '';
  String name = '';
  String contact = '';

  @override
  Widget build(BuildContext context) {
    // Check if the user has the owner role
    if (widget.role != 'ROLE_OWNER') {
      return Scaffold(
        body: Center(
          child: Text(
            'You do not have permission to add a customer.',
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
              'Add Customer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Space between title and form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ID Number'),
                    onChanged: (value) {
                      setState(() {
                        idNumber = value;
                      });
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'This field is required' : null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'This field is required' : null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Contact'),
                    onChanged: (value) {
                      setState(() {
                        contact = value;
                      });
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'This field is required' : null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Customer newCustomer = Customer(
                          idNumber: idNumber,
                          name: name,
                          contact: contact,
                        );
                        customers.add(newCustomer);
                        Navigator.pop(context, 'Customer added successfully');
                      }
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
