import 'package:flutter/material.dart';

void main() => runApp(ComposeEmailApp());

class ComposeEmailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComposeEmail(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class ComposeEmail extends StatefulWidget {
  @override
  _ComposeEmailState createState() => _ComposeEmailState();
}

class _ComposeEmailState extends State<ComposeEmail> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compose Email',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('To:'),
              _buildTextField(hintText: 'Enter recipient', icon: Icons.email),
              SizedBox(height: 16),
              _buildLabel('From:'),
              _buildTextField(hintText: 'Enter your email address', icon: Icons.email_outlined),
              SizedBox(height: 16),
              _buildLabel('Subject:'),
              _buildTextField(hintText: 'Enter subject', icon: Icons.subject),
              SizedBox(height: 16),
              _buildLabel('Message:'),
              _buildMessageField(),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Logic to send the email
                    }
                  },
                  child: Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({required String hintText, required IconData icon}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue[900]),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Compose email',
        prefixIcon: Icon(Icons.message, color: Colors.blue[900]),
      ),
      maxLines: 6,
      minLines: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
