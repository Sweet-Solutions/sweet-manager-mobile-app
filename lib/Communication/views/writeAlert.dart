import 'package:flutter/material.dart';
import 'package:sweetmanager/Communication/services/NotificationService.dart';
import '../models/notification.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService for token management

class WriteAlertScreen extends StatefulWidget {
  @override
  _WriteAlertScreenState createState() => _WriteAlertScreenState();
}

class _WriteAlertScreenState extends State<WriteAlertScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedSeverity = 'Important';

  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); // Instantiate AuthService
    notificationService = NotificationService(
      baseUrl: 'http://localhost:5181', // Adjust this to your API's base URL
      authService: authService,
    );
  }

  // Submit the alert notification
  Future<void> _submitNotification() async {
  if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
    try {
      // Obtén todas las IDs de admins y workers
      List<int> adminIds = await notificationService.getAllAdminIds();
      List<int> workerIds = await notificationService.getAllWorkerIds();
      final ownersId = await notificationService.authService.getOwnersId();
  if (ownersId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unable to get owner ID. Please log in again.')),
    );
    return;
  }

      // Crea y envía una notificación para cada admin y worker
      for (int adminId in adminIds) {
        for (int workerId in workerIds) {
          Notifications newNotification = Notifications(
            2, // typesNotificationsId para alertas
            ownersId,
            adminId, // ID del administrador
            workerId, // ID del trabajador
            _titleController.text,
            _descriptionController.text,
          );
          bool success = await notificationService.createAlert(newNotification);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Alert sent successfully!')),
            );
          }
        }
      }

      // Limpiar campos después de enviar
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedSeverity = 'Important';
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send alert: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please complete all fields.')),
    );
  }


}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('REGISTER ALERT'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color(0xFF183952),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Alert',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C5282),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'YOUR ALERT WILL BE SENT TO ALL WORKERS AND ADMINISTRATORS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Severity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF183952),
                ),
              ),
            ),
            Column(
              children: [
                RadioListTile(
                  value: 'Important',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: const Text('Important', style: TextStyle(color: Color(0xFF183952))),
                ),
                RadioListTile(
                  value: 'Extreme',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: const Text('Extreme', style: TextStyle(color: Color(0xFF183952))),
                ),
                RadioListTile(
                  value: 'Warning',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: const Text('Warning', style: TextStyle(color: Color(0xFF183952))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Describe the incident',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C5282),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'SEND',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
