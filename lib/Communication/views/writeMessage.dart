// writeMessage.dart
import 'package:flutter/material.dart';
import 'package:sweetmanager/Communication/services/NotificationService.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService for token management
import '../models/notification.dart';
import 'messageScreen.dart'; // Import MessagesScreen

class WriteMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ComposeMessage(),
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class ComposeMessage extends StatefulWidget {
  @override
  _ComposeMessageState createState() => _ComposeMessageState();
}

class _ComposeMessageState extends State<ComposeMessage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers to capture form values
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); // Instantiate AuthService
    notificationService = NotificationService();
  }

  // Submit the message notification
  Future<void> _submitMessage() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Set typesNotificationsId to 1 by default
      int typesNotificationsId = 1;
      int ownersId = int.tryParse(_fromController.text) ?? 0;
      int adminsId = int.tryParse(_subjectController.text) ?? 0;
      int workersId = int.tryParse(_messageController.text) ?? 0;

      // Create a new notification instance
      Notifications newMessage = Notifications(
        typesNotificationsId,
        ownersId,
        adminsId,
        workersId,
        _titleController.text,
        _descriptionController.text, // Description of the notification
      );

      try {
        // Call the service to send the message
        bool success = await notificationService.createNotification(newMessage);
        if (success) {
          _showSuccessDialog();
          // Clear form fields after submission
          _fromController.clear();
          _subjectController.clear();
          _messageController.clear();
          _titleController.clear();
          _descriptionController.clear();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message Created'),
          content: Text('Your message has been created successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(true); // Return true to indicate success
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MessagesScreen()),
            );
          },
        ),
        title: const Text(
          'Write Message',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('From (ownersId):'),
              _buildTextField(
                  hintText: 'Enter your owner ID',
                  controller: _fromController,
                  icon: Icons.email_outlined),
              const SizedBox(height: 16),
              _buildLabel('Admins (adminsId):'),
              _buildTextField(
                  hintText: 'Enter admin ID',
                  controller: _subjectController,
                  icon: Icons.admin_panel_settings),
              const SizedBox(height: 16),
              _buildLabel('Workers (workersId):'),
              _buildTextField(
                  hintText: 'Enter worker ID',
                  controller: _messageController,
                  icon: Icons.people),
              const SizedBox(height: 16),
              _buildLabel('Title:'),
              _buildTextField(
                  hintText: 'Enter title',
                  controller: _titleController,
                  icon: Icons.title),
              const SizedBox(height: 16),
              _buildLabel('Description:'),
              _buildTextField(
                  hintText: 'Enter description',
                  controller: _descriptionController,
                  icon: Icons.description),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _submitMessage,
                  child: const Text('Send',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
        required TextEditingController controller,
        required IconData icon}) {
    return TextFormField(
      controller: controller,
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
}