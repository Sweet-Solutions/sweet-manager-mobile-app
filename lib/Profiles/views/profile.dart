import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Initializing the secure storage
  final storage = const FlutterSecureStorage();

  Future<String?> _getRole() async {
    // Retrieve token from local storage
    String? token = await storage.read(key: 'token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
    }

    return null; // Return null if no token is found
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          String? role = snapshot.data;
          return BaseLayout(
            role: role!,
            childScreen: _buildProfilePage(role),
          );
        }

        return const Center(child: Text('Unable to retrieve role'));
      },
    );
  }

  Widget _buildProfilePage(String role) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user icon, name, and "View organization" button
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

              // Editable fields for the profile page
              buildEditableField('Name', 'Jane Doe', 'Change name'),
              buildEditableField('Username', 'JaneDoe123', 'Change username'),
              buildEditableField('Email', 'janedoe@peruagro.com', 'Change email'),
              buildEditableField('Phone', '77777777', 'Change phone'),

              // Show "Supervision Areas" only if the user is an "owner"
              if (role == 'ROLE_OWNER')
                buildEditableField('Supervision Areas', 'SECURITY STAFF', 'Change supervision areas'),

              // Show "Assigned Area" only if the user is a "worker"
              if (role == 'ROLE_WORKER')
                buildInfoField('Assigned Area', 'SECURITY STAFF'),

              // Password section
              buildPasswordField(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // Action to change the field value
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
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // Action to change the password
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

// Organization Information Screen
class OrganizationInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Logo_de_Campoalegre_FC.svg/1024px-Logo_de_Campoalegre_FC.svg.png',
                    ),
                  ),
                  SizedBox(height: 16),
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
            Text(
              'Business name: Peru Agro J&V S.A.C',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.black),
            SizedBox(height: 16),
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
