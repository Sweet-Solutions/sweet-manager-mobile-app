import 'package:flutter/material.dart';
import '../../Shared/widgets/base_layout.dart';
import '../components/dotsIndicator.dart';
import '../models/notification.dart';
import '../components/notificationCard.dart';

@override
Widget build(BuildContext context) {
  return BaseLayout(role: '', childScreen: NotificationsScreen());
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _currentPage = 0;

  void _changePage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
  }

  List<Widget> _getNotificationsForPage(int page) {
    switch (page) {
      case 0:
        return [
          NotificationCard(
            notification: Notifications(
              1,
              101,
              201,
              301,
              'Reunión de Administradores',
              'Reunión en la sala de conferencias para discutir la estrategia del mes.',
            ),
          ),
          NotificationCard(
            notification: Notifications(
              2,
              101,
              201,
              301,
              'Taller de Capacitación',
              'Capacitación en la sala de capacitación sobre nuevas tecnologías.',
            ),
          ),
        ];
      case 1:
        return [
          NotificationCard(
            notification: Notifications(
              1,
              101,
              201,
              301,
              'Llamada de Proveedores',
              'Llamada con proveedores para discutir los términos del acuerdo.',
            ),
          ),
          NotificationCard(
            notification: Notifications(
              2,
              101,
              201,
              301,
              'Revisión de Inventario',
              'Revisión del inventario en el almacén central.',
            ),
          ),
        ];
      case 2:
        return [
          NotificationCard(
            notification: Notifications(
              1,
              101,
              201,
              301,
              'Reunión de Marketing',
              'Reunión en la sala ejecutiva para definir la estrategia de marketing.',
            ),
          ),
          NotificationCard(
            notification: Notifications(
              2,
              101,
              201,
              301,
              'Presentación de Proyectos',
              'Presentación en el auditorio principal sobre los proyectos del trimestre.',
            ),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, color: Colors.black, size: 36),
            SizedBox(width: 8),
            Text(
              'Notifications',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black, size: 32),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: ListView(
                key: ValueKey<int>(_currentPage),
                padding: const EdgeInsets.all(16),
                children: _getNotificationsForPage(_currentPage),
              ),
            ),
          ),
          DotsIndicator(
            currentPage: _currentPage,
            onPageSelected: _changePage,
          ),
          SupportSection(),
        ],
      ),
    );
  }
}

class SupportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report a Problem',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF091E3D),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your issue...',
              filled: true,
              fillColor: const Color(0xFF2196F3).withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF183952)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0066CC)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF183952),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
