import 'package:flutter/material.dart';

void main() {
  runApp(AlertaApp());
}

class AlertaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlertaScreen(),
    );
  }
}

class AlertaScreen extends StatefulWidget {
  @override
  _AlertaScreenState createState() => _AlertaScreenState();
}

class _AlertaScreenState extends State<AlertaScreen> {
  String _selectedSeverity = 'Important';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text('REGISTRO DE ALERTAS'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF183952), // Color for the AppBar title
          fontSize: 16, // Smaller font size for "REGISTRO DE ALERTAS"
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView( // Added scroll view to handle overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Alerta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black color for "Alerta"
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de Usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
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
                'SU ALERTA SERÁ ENVIADA A TODOS LOS TRABAJADORES Y ADMINISTRADORES',
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
                  color: Color(0xFF183952), // Ensure visibility on white background
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
                  title: Text('Important', style: TextStyle(color: Color(0xFF183952))), // Ensure text visibility
                ),
                RadioListTile(
                  value: 'Extreme',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: Text('Extreme', style: TextStyle(color: Color(0xFF183952))), // Ensure text visibility
                ),
                RadioListTile(
                  value: 'Warning',
                  groupValue: _selectedSeverity,
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value.toString();
                    });
                  },
                  title: Text('Warning', style: TextStyle(color: Color(0xFF183952))), // Ensure text visibility
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2C5282), // Color of the button
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ENVIAR',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}