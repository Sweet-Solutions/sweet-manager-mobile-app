import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationsScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
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
            title: 'Reunión de Administradores',
            time: '10:00 a.m.',
            date: '12/11/2024',
            location: 'Sala de Conferencias',
          ),
          NotificationCard(
            title: 'Taller de Capacitación',
            time: '2:00 p.m.',
            date: '13/11/2024',
            location: 'Sala de Capacitación',
          ),
        ];
      case 1:
        return [
          NotificationCard(
            title: 'Llamada de Proveedores',
            time: '11:00 a.m.',
            date: '14/11/2024',
            location: 'Sala de Reuniones',
          ),
          NotificationCard(
            title: 'Revisión de Inventario',
            time: '4:00 p.m.',
            date: '15/11/2024',
            location: 'Almacén Central',
          ),
        ];
      case 2:
        return [
          NotificationCard(
            title: 'Reunión de Marketing',
            time: '9:00 a.m.',
            date: '16/11/2024',
            location: 'Sala Ejecutiva',
          ),
          NotificationCard(
            title: 'Presentación de Proyectos',
            time: '3:00 p.m.',
            date: '17/11/2024',
            location: 'Auditorio Principal',
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
        title: Row(
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
            icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 32),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: ListView(
                key: ValueKey<int>(_currentPage),
                padding: EdgeInsets.all(16),
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

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final String location;

  const NotificationCard({
    required this.title,
    required this.time,
    required this.date,
    required this.location,
  });

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
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // Márgenes más pequeños
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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Fecha: $date', style: TextStyle(color: Colors.grey)),
                  Text('Lugar: $location', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  time,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Tamaño de fuente aumentado
                ),
                SizedBox(height: 8),
                Row(
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
          ],
        ),
      ),
    );
  }
}

class DotsIndicator extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageSelected;

  const DotsIndicator({required this.currentPage, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () => onPageSelected(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index ? Colors.blue : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
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
          Text(
            'Report a Problem',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF091E3D),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your issue...',
              filled: true,
              fillColor: Color(0xFF2196F3).withOpacity(0.1), // Color de fondo ajustado
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF183952)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF0066CC)),
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 180, // Ancho ligeramente menor
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF183952), // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 12), // Botón más alto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Radio circular
                  ),
                ),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontFamily: 'Be Vietnam Pro', // Fuente Be Vietnam Pro
                    fontSize: 15, // Tamaño 15
                    fontWeight: FontWeight.w600, // Letra semibold
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