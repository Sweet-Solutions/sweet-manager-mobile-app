import 'package:flutter/material.dart';
import '../models/notification.dart';

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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: Colors.white),
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

  // Controladores para capturar el valor de los campos de texto
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compose Notification',
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
              _buildLabel('To (typesNotificationsId):'),
              _buildTextField(
                  hintText: 'Enter notification type ID',
                  controller: _toController,
                  icon: Icons.email),
              SizedBox(height: 16),
              _buildLabel('From (ownersId):'),
              _buildTextField(
                  hintText: 'Enter your owner ID',
                  controller: _fromController,
                  icon: Icons.email_outlined),
              SizedBox(height: 16),
              _buildLabel('Admins (adminsId):'),
              _buildTextField(
                  hintText: 'Enter admin ID',
                  controller: _subjectController,
                  icon: Icons.admin_panel_settings),
              SizedBox(height: 16),
              _buildLabel('Workers (workersId):'),
              _buildTextField(
                  hintText: 'Enter worker ID',
                  controller: _messageController,
                  icon: Icons.people),
              SizedBox(height: 16),
              _buildLabel('Title:'),
              _buildTextField(
                  hintText: 'Enter title',
                  controller: _subjectController,
                  icon: Icons.title),
              SizedBox(height: 16),
              _buildLabel('Description:'),
              _buildTextField(
                  hintText: 'Enter description',
                  controller: _messageController,
                  icon: Icons.description),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Convertir los valores del formulario en tipos necesarios
                      int typesNotificationsId =
                          int.tryParse(_toController.text) ?? 0;
                      int ownersId = int.tryParse(_fromController.text) ?? 0;
                      int adminsId = int.tryParse(_subjectController.text) ?? 0;
                      int workersId = int.tryParse(_messageController.text) ?? 0;

                      // Crear la instancia de Notifications
                      Notifications notification = Notifications(
                        typesNotificationsId,
                        ownersId,
                        adminsId,
                        workersId,
                        _subjectController.text,
                        _messageController.text,
                      );

                      // Lógica adicional para enviar/almacenar la notificación
                      print('Notification created: ${notification.title}');
                    }
                  },
                  child: Text('Send',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
