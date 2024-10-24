import 'package:flutter/material.dart';
import 'package:sweetmanager/Communication/services/NotificationService.dart';
import '../models/notification.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService for token management

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Notifications> alertNotifications = []; // List of fetched notifications
  bool isLoading = true;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); 
    notificationService = NotificationService(
      baseUrl: 'http://localhost:5181', 
      authService: authService,
    );
    fetchAlertNotifications(); 
  }

  Future<void> fetchAlertNotifications() async {
    try {
      final notifications = await notificationService.getAlertNotifications(1); // Pass the correct hotel ID
      setState(() {
        alertNotifications = notifications; // Update state with fetched notifications
        isLoading = false; // Stop loading indicator
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications: $e')),
      );
    }
  }

  void removeNotification(int index) {
    setState(() {
      alertNotifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Row(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.red,
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              'Alerts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loading spinner
          : ListView.builder(
              itemCount: alertNotifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  notification: alertNotifications[index],
                  index: index,
                  removeNotification: removeNotification,
                );
              },
            ),
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
