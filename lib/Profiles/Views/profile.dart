import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(role: 'ROLE_OWNER'), // Cambia el rol a 'ROLE_OWNER' o 'ROLE_ADMIN' para probar
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String role; // Propiedad para el rol del usuario

  ProfilePage({required this.role}); // Constructor que acepta el rol

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permitir el desplazamiento
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono de usuario, nombre y botón View organization alineados
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jane Doe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      // "View organization" está disponible para ambos roles
                      TextButton(
                        onPressed: () {
                          // Navegar a la pantalla de organización
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrganizationInfoScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'View organization',
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Secciones de cambio de información con campos alineados y botones debajo
              buildEditableField('Name', 'Jane Doe', 'Change name'),
              buildEditableField('Username', 'Jane Doe wiwi', 'Change username'),
              buildEditableField('Email', 'janedoe@peruagro.com', 'Change email'),
              buildEditableField('Phone', '77777777', 'Change phone'),

              // Mostrar el campo "Supervision Areas" solo si el rol es "owner"
              if (widget.role == 'ROLE_OWNER')
                buildEditableField('Supervision Areas', 'SECURITY STAFF', 'Change supervision areas'),

              // Mostrar el campo "Assigned Area" solo si el rol es "worker"
              if (widget.role == 'ROLE_WORKER')
                buildInfoField('Assigned Area', 'SECURITY STAFF'),

              // Sección de contraseña
              buildPasswordField(),
              SizedBox(height: 20), // Espacio adicional al final
            ],
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para los campos editables con campos a rellenar
  Widget buildEditableField(String label, String value, String actionLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: value,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4), // Espacio entre campo y botón de acción
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // Acción para cambiar el valor
              },
              child: Text(
                actionLabel,
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar el campo de información asignada
  Widget buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  // Widget para la sección de contraseña
  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          TextFormField(
            obscureText: true,
            initialValue: '********',
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 4), // Espacio entre campo y botón
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // Acción para cambiar la contraseña
              },
              child: Text(
                'Change password',
                style: TextStyle(color: Colors.blue[900]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pantalla de información de la organización
class OrganizationInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título "Sweet Manager"
            Center(
              child: Column(
                children: [
                  Text(
                    'Sweet Manager',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C4257),
                    ),
                  ),
                  SizedBox(height: 16),
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
            // Información del negocio
            Text(
              'Business name: Peru Agro J&V S.A.C',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.black),
            SizedBox(height: 16),
            // Sección de información del hotel
            Text(
              'HOTEL INFO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Divider(color: Colors.black),
            SizedBox(height: 8),
            _buildInfoRow('Name', 'Heden Golf'),
            _buildInfoRow('Address', 'Av. La mar'),
            _buildInfoRow('Phone Number', '941 691 025'),
            _buildInfoRow('Email', 'hedengolf@gmail.com'),
            _buildInfoRow('Timezone (Country)', 'Perú'),
            _buildInfoRow('Language', 'English'),
            _buildInfoRow(
              'Description',
              'Ofrece habitaciones confortables con vistas al océano o acceso directo a la playa.',
            ),
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
