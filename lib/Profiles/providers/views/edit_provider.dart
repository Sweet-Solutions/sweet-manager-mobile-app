import 'package:flutter/material.dart';
import '../models/provider_model.dart';

class EditProviderPage extends StatefulWidget {
  final Provider provider; // Use the correct name for the Provider model
  final String role; // Add user role

  EditProviderPage({required this.provider, required this.role}); // Constructor that receives the provider and the role

  @override
  _EditProviderPageState createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditProviderPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String contact;
  late String address;
  late String product;

  @override
  void initState() {
    super.initState();
    name = widget.provider.name;
    contact = widget.provider.contact;
    address = widget.provider.address;
    product = widget.provider.product;
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user has the owner role
    if (widget.role != 'ROLE_OWNER') {
      return Scaffold(
        body: Center(
          child: Text(
            'You do not have permission to edit this provider.',
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
              'Edit Provider',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  TextFormField(
                    initialValue: address,
                    decoration: InputDecoration(labelText: 'Address'),
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: product,
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
                        setState(() {
                          widget.provider.name = name;
                          widget.provider.contact = contact;
                          widget.provider.address = address;
                          widget.provider.product = product;
                        });
                        Navigator.pop(context, 'Provider updated successfully');
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
