import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationCard extends StatelessWidget {
  final Notifications notification;

  const NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFF0066CC).withOpacity(0.4)),
      ),
      elevation: 12,
      shadowColor: Color(0xFF0066CC).withOpacity(0.4),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Descripción: ${notification.description}', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('ID Administrador: ${notification.adminsId}', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}