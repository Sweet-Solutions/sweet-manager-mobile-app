import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      home: OrganizationInfoScreen(),
    );
  }
}

class OrganizationInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C4257),
        title: Text(
          'Sweet Manager',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Acción del menú
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Logo de la organización
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Logo_de_Campoalegre_FC.svg/1024px-Logo_de_Campoalegre_FC.svg.png',
                    ),
                  ),
                  SizedBox(height: 16),
                  // Texto "My organization"
                  Text(
                    'My organization',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Nombre del negocio
            Text(
              'Business name: Peru Agro J&V S.A.C',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.black), // Línea debajo de Business name
            SizedBox(height: 16),
            // Sección de información del hotel
            Text(
              'HOTEL INFO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Divider(color: Colors.black), // Línea debajo de HOTEL INFO
            SizedBox(height: 8),
            _buildInfoRow('Name', 'Heden Golf'),
            _buildInfoRow('Address', 'Av. La mar'),
            _buildInfoRow('Phone Number', '941 691 025'),
            _buildInfoRow('Email', 'hedengolf@gmail.com'),
            _buildInfoRow('Timezone (Country)', 'Perú'),
            _buildInfoRow('Language', 'English'),
            _buildInfoRow('Description',
                'Ofrece habitaciones confortables con vistas al océano o acceso directo a la playa. Es ideal para disfrutar de una estancia relajante en un ambiente costero tranquilo.'),
          ],
        ),
      ),
    );
  }

  // Función auxiliar para construir cada fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
