import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notificationService.dart';

class WriteMessageScreen extends StatelessWidget {
  const WriteMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WriteMessage(),
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

class WriteMessage extends StatefulWidget {
  const WriteMessage({super.key});

  @override
  _WriteMessageState createState() => _WriteMessageState();
}

class _WriteMessageState extends State<WriteMessage> {
  final _formKey = GlobalKey<FormState>();
  final NotificationService _notificationService = NotificationService();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _adminsController = TextEditingController();
  final TextEditingController _workersController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Write Message',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
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
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Admins (adminsId):'),
                      _buildTextField(
                        hintText: 'Enter admin ID',
                        controller: _adminsController,
                        icon: Icons.admin_panel_settings,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Workers (workersId):'),
                      _buildTextField(
                        hintText: 'Enter worker ID',
                        controller: _workersController,
                        icon: Icons.people,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Title:'),
                      _buildTextField(
                        hintText: 'Enter title',
                        controller: _titleController,
                        icon: Icons.title,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Description:'),
                      _buildTextField(
                        hintText: 'Enter description',
                        controller: _descriptionController,
                        icon: Icons.description,
                      ),
                      const Spacer(),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Set typesNotificationsId to 1
                              int typesNotificationsId = 1;

                              int ownersId = 378;
                              int adminsId = 8;
                              int workersId = 7;

                              // Create the notification object
                              Notifications notification = Notifications(
                                typesNotificationsId,
                                ownersId,
                                adminsId,
                                workersId,
                                _titleController.text,
                                _descriptionController.text,
                              );

                              // Call the NotificationService to create the notification
                              try {
                                bool result = await _notificationService.createNotification(notification);
                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Notification sent successfully')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to send notification')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Send',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
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
