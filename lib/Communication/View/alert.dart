import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const AlertsScreen(),
    );
  }
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<Alert> alerts = [
    const Alert('Power Outage Scheduled', 'There will be a power outage in the hotel from 2 AM to...', 'Warning'),
    const Alert('Emergency Fire Drill', 'An emergency fire drill will take place at 10 AM today...', 'Important'),
    const Alert('Water Supply Disruption', 'Several guests reported unusual behavior around the...', 'Security'),
    const Alert('Low Stock of Guest Amenities', 'There will be a temporary disruption in the water supply...', 'Warning'),
    const Alert('Security System Update', 'A security system update is scheduled for tonight...', 'Important'),
    const Alert('Lost Guest Property', 'A guest has reported a lost item in the lobby. Please...', 'Warning'),
    const Alert('Wi-Fi Outage', 'There is an ongoing Wi-Fi outage affecting the entire...', 'Important'),
    const Alert('Broken Elevator', 'The elevator in the north wing is out of service. Please...', 'Extreme'),
    const Alert('Unauthorized Access in Staff Area', 'We are experiencing a shortage of essential supplies...', 'Warning'),
    const Alert('HVAC System Failure', 'The HVAC system in the east wing is not functioning...', 'Warning'),
  ];

  final Map<int, bool> _isHoveringAlert = {};
  bool _isHoveringAdd = false;

  void removeAlert(int index) {
    setState(() {
      alerts.removeAt(index);
      _isHoveringAlert.remove(index);
      // Update hover states after removal
      _isHoveringAlert.forEach((key, value) {
        if (key > index) {
          _isHoveringAlert[key - 1] = value;
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
          children:  [
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
                  child:  Icon(
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
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHoveringAlert[index] = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHoveringAlert[index] = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: _isHoveringAlert[index] ?? false
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
              child: AlertCard(
                alert: alerts[index],
                index: index,
                removeAlert: removeAlert,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Alert {
  final String title;
  final String description;
  final String level;

  const Alert(this.title, this.description, this.level);
}

class AlertCard extends StatelessWidget {
  final Alert alert;
  final int index;
  final void Function(int) removeAlert;

  const AlertCard({
    Key? key,
    required this.alert,
    required this.index,
    required this.removeAlert,
  }) : super(key: key);

  Color getLevelColor() {
    switch (alert.level) {
      case 'Warning':
        return Colors.orange;
      case 'Important':
        return Colors.red;
      case 'Security':
        return Colors.blueAccent;
      case 'Extreme':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.warning,
          color: getLevelColor(),
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                alert.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                alert.level,
                style: TextStyle(
                  fontSize: 14,
                  color: getLevelColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'Delete') {
              removeAlert(index);
            } else if (value == 'View Details') {
              // Add logic to view details of the alert
            }
          },
          itemBuilder: (BuildContext context) {
            return const {'Delete', 'View Details'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
