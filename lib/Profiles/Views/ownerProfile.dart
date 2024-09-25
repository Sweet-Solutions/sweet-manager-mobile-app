import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Row(
          children: [
            Icon(Icons.home, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Sweet Manager',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Acción del menú
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                      TextButton(
                        onPressed: () {
                          // Acción para ver organización
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
              buildEditableField('Supervision Areas', 'SECURITY STAFF', 'Change role'),

              // Sección de contraseña
              buildPasswordField(),
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
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
              contentPadding:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
