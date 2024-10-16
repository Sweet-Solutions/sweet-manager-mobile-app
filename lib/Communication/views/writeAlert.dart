import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../components/notificationCard.dart';


class WriteNotificationScreen extends StatefulWidget {
  @override
  _WriteNotificationScreenState createState() => _WriteNotificationScreenState();
}

class _WriteNotificationScreenState extends State<WriteNotificationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedSeverity = 'Important';

  // You can modify these default values as per your app's logic
  final int _typesNotificationsId = 1; // Placeholder for notification type
  final int _ownersId = 123; // Placeholder for owner ID
  final int _adminsId = 456; // Placeholder for admin ID
  final int _workersId = 789; // Placeholder for worker ID

  void _submitNotification() {
    if (_usernameController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      Notifications newNotification = Notifications(
        _typesNotificationsId,
        _ownersId,
        _adminsId,
        _workersId,
        _titleController.text,
        _descriptionController.text,
      );
      print('Nueva notificación creada: ${newNotification.title}, ${newNotification.description}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Notificación enviada con éxito!'),
        ),
      );
      _usernameController.clear();
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedSeverity = 'Important';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor complete todos los campos.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('REGISTRO DE NOTIFICACIONES'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
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
            Text(
              'Notificación',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de Usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF2C5282),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SU NOTIFICACIÓN SERÁ ENVIADA A TODOS LOS TRABAJADORES Y ADMINISTRADORES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gravedad',
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
                  title: Text('Important', style: TextStyle(color: Color(0xFF183952))),
                ),
                RadioListTile(
                  value: 'Extreme',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: Text('Extreme', style: TextStyle(color: Color(0xFF183952))),
                ),
                RadioListTile(
                  value: 'Warning',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: Text('Warning', style: TextStyle(color: Color(0xFF183952))),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Describa el incidente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2C5282),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ENVIAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
