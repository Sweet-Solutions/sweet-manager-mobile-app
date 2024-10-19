import 'package:flutter/material.dart';

import '../models/notification.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
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
  bool _isHoveringAdd = false;

  void removeNotification(int index) {
    setState(() {
      alertNotifications.removeAt(index);
      _isHoveringNotification.remove(index);
      // Update hover states after removal
      _isHoveringNotification.forEach((key, value) {
        if (key > index) {
          _isHoveringNotification[key - 1] = value;
        }
      });
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveringAdd = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveringAdd = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isHoveringAdd ? 45 : 40,
                height: _isHoveringAdd ? 45 : 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  shape: BoxShape.circle,
                  color: _isHoveringAdd ? Colors.grey[100] : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: alertNotifications.length,
        itemBuilder: (context, index) {
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHoveringNotification[index] = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHoveringNotification[index] = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: _isHoveringNotification[index] ?? false
                    ? Colors.grey[100]
                    : (index % 2 == 0 ? Colors.white : const Color(0xFFDEE8EB)),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: NotificationCard(
                notification: alertNotifications[index],
                index: index,
                removeNotification: removeNotification,
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Notifications notification; // Aquí también usamos 'Notifications' del modelo
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(notification.description),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => removeNotification(index),
        ),
      ],
    );
  }
}