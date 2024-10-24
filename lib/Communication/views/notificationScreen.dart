import 'package:flutter/material.dart';
import 'package:sweetmanager/Communication/services/NotificationService.dart';
import '../models/notification.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService for token management
import '../components/dotsIndicator.dart';
import '../components/notificationCard.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _currentPage = 0;
  bool isLoading = true;
  List<List<Notifications>> paginatedNotifications = []; // List of paginated notifications

  late NotificationService notificationService;
  final storage = const FlutterSecureStorage();
  String? role;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); // Instantiate AuthService
    notificationService = NotificationService(
      baseUrl: 'http://localhost:5181', // Adjust this to your API's base URL
      authService: authService,
    );
    fetchNotifications(); // Fetch notifications on init
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

  // Fetch all notifications
  Future<void> fetchNotifications() async {
    try {
      final notifications = await notificationService.getAllNotifications(1); // Pass the correct hotel ID
      setState(() {
        paginatedNotifications = _paginateNotifications(notifications); // Paginate the notifications
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications: $e')),
      );
      print("Error fetching notifications: $e");
    }
  }

  // Paginate the notifications into chunks of 2 (or any number per page)
  List<List<Notifications>> _paginateNotifications(List<Notifications> notifications) {
    List<List<Notifications>> pages = [];
    int pageSize = 2;

    for (var i = 0; i < notifications.length; i += pageSize) {
      pages.add(notifications.sublist(i, i + pageSize > notifications.length ? notifications.length : i + pageSize));
    }
    return pages;
  }

  // Change page for pagination
  void _changePage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
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
            body: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading spinner
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: ListView(
                            key: ValueKey<int>(_currentPage),
                            padding: const EdgeInsets.all(16),
                            children: paginatedNotifications.isNotEmpty
                                ? paginatedNotifications[_currentPage].map((notification) {
                                    return NotificationCard(notification: notification);
                                  }).toList()
                                : [],
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
          ),
        );
      },
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
              fillColor: Color(0xFF2196F3).withOpacity(0.1),
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
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  // Add report submission logic if needed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF183952),
                  padding: EdgeInsets.symmetric(vertical: 12),
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
