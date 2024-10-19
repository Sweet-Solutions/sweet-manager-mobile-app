import 'package:flutter/material.dart';
import '../models/provider_model.dart';

class AddProviderPage extends StatefulWidget {
  final String role; // Add user role

  AddProviderPage({required this.role}); // Constructor that receives the role

  @override
  _AddProviderPageState createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String contact = '';
  String address = '';
  String product = '';

  @override
  Widget build(BuildContext context) {
    // Check if the user has the owner role
    if (widget.role != 'ROLE_OWNER') {
      return Scaffold(
        body: Center(
          child: Text(
            'You do not have permission to add a provider.',
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
              'Add Provider',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Space between title and form
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address'),
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Product'),
                    onChanged: (value) {
                      setState(() {
                        product = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider newProvider = Provider(
                          name: name,
                          contact: contact,
                          address: address,
                          product: product,
                        );
                        providers.add(newProvider);
                        Navigator.pop(context, 'Provider added successfully');
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
