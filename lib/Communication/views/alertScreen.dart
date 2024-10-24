
import 'package:flutter/material.dart';
import 'package:sweetmanager/Communication/services/NotificationService.dart';
import '../models/notification.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService for token management
import 'package:sweetmanager/Shared/widgets/base_layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return const BaseLayout(role: '', childScreen: AlertsScreen());
}

class AlertsScreen extends StatefulWidget {

  const AlertsScreen({super.key});

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Notifications> alertNotifications = []; // List of fetched notifications
  bool isLoading = true;
  late NotificationService notificationService;
  final storage = const FlutterSecureStorage();
  String? role;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService(
    );
    fetchAlertNotifications(); 
  }

  // Método para obtener el rol del token
  Future<String?> _getRole() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
    }
    return null;
  }

  Future<void> fetchAlertNotifications() async {
    try {
      final notifications = await notificationService.getAlertNotifications(1); // Pass the correct hotel ID
      setState(() {
        alertNotifications = notifications;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications: $e')),
      );
    }
  }
  final List<Notifications> alertNotifications = [
    Notifications(1, 1, 2, 3, 'Power Outage Scheduled', 'There will be a power outage in the hotel from 2 AM to...'),
    Notifications(2, 1, 2, 3, 'Emergency Fire Drill', 'An emergency fire drill will take place at 10 AM today...'),
    Notifications(3, 1, 2, 3, 'Water Supply Disruption', 'Several guests reported unusual behavior around the...'),
    Notifications(1, 1, 2, 3, 'Low Stock of Guest Amenities', 'There will be a temporary disruption in the water supply...'),
    Notifications(2, 1, 2, 3, 'Security System Update', 'A security system update is scheduled for tonight...'),
    Notifications(1, 1, 2, 3, 'Lost Guest Property', 'A guest has reported a lost item in the lobby. Please...'),
    Notifications(2, 1, 2, 3, 'Wi-Fi Outage', 'There is an ongoing Wi-Fi outage affecting the entire...'),
    Notifications(4, 1, 2, 3, 'Broken Elevator', 'The elevator in the north wing is out of service. Please...'),
    Notifications(1, 1, 2, 3, 'Unauthorized Access in Staff Area', 'We are experiencing a shortage of essential supplies...'),
    Notifications(1, 1, 2, 3, 'HVAC System Failure', 'The HVAC system in the east wing is not functioning...'),
  ];

  final Map<int, bool> _isHoveringNotification = {};

  void removeNotification(int index) {
    setState(() {
      alertNotifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading role'));
        }

        role = snapshot.data;

        return BaseLayout(
          role: role,
          childScreen: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alerts',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/writealert');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5282),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Write Alert',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? const Center(child: CircularProgressIndicator()) // Show a loading spinner
                      : Expanded(
                          child: ListView.builder(
                            itemCount: alertNotifications.length,
                            itemBuilder: (context, index) {
                              return NotificationCard(
                                notification: alertNotifications[index],
                                index: index,
                                removeNotification: removeNotification,
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Notifications notification;
  final int index;
  final Function(int) removeNotification;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.index,
    required this.removeNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notification.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => removeNotification(index),
        ),
      ),
    );
  }
}



