import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService for token management

class NotificationService {
  final String baseUrl = "https://sweetmanager-api.ryzeon.me"; // Base URL
  final AuthService authService = AuthService(); // AuthService dependency

  NotificationService();

  // Helper method to get the headers with the token
  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.storage.read(key: 'token');
    if (token == null) {
      throw Exception('Authorization token is missing');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Create a new notification
  Future<bool> createNotification(Notifications notification) async {
    final url = Uri.parse("$baseUrl/api/notifications"); // Endpoint
    final headers = await _getHeaders(); // Fetch headers with token
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to create notification');
    }
  }

  // Get all notifications filtered by typesNotificationsId = 2 (Alerts)
  Future<List<Notifications>> getAlertNotifications(int hotelId) async {
    final url = Uri.parse("$baseUrl/api/notifications/get-all-notifications?hotelId=$hotelId"); // Adjust this endpoint
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers).timeout(Duration(seconds: 15)); // Added timeout

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Notifications.fromJson(json))
          .where((notification) => notification.typesNotificationsId == 2)
          .toList();
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load notifications');
    }
  }

  // Create a new alert (typesNotificationsId == 2)
  Future<bool> createAlert(Notifications notification) async {
    final headers = await _getHeaders();
    final url = Uri.parse("$baseUrl/api/notifications"); // Endpoint

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode == 201) {
      return true; // Success
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to create alert');
    }
  }

  // Get a notification by ID
  Future<Notifications> getNotificationById(int id) async {
    final url = Uri.parse("$baseUrl/api/notifications/get-notification-by-id/$id"); // Correct endpoint
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers).timeout(Duration(seconds: 15)); // Added timeout

    if (response.statusCode == 200) {
      return Notifications.fromJson(jsonDecode(response.body));
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Notification not found');
    }
  }

  // Get all notifications filtered by typesNotificationsId = 1 (Messages)
  Future<List<Notifications>> getMessages(int hotelId) async {
    final url = Uri.parse("$baseUrl/api/notifications/get-all-notifications?hotelId=$hotelId"); // Correct endpoint
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers).timeout(Duration(seconds: 15)); // Added timeout

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Notifications.fromJson(json))
          .where((notification) => notification.typesNotificationsId == 1)
          .toList();
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load messages');
    }
  }

  // Fetch all notifications (no filter by type)
  Future<List<Notifications>> getAllNotifications(int hotelId) async {
    final url = Uri.parse("$baseUrl/api/notifications/get-all-notifications?hotelId=$hotelId"); // Correct endpoint
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers).timeout(Duration(seconds: 15)); // Added timeout

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Notifications.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load notifications');
    }
  }

  // Service to fetch all admin and worker IDs
Future<List<int>> getAllAdminIds() async {
  final url = Uri.parse("$baseUrl/admins");
  final headers = await _getHeaders();
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((admin) => admin['id'] as int).toList();
  } else {
    throw Exception('Failed to load admin IDs');
  }
}

Future<List<int>> getAllWorkerIds() async {
  final url = Uri.parse("$baseUrl/workers");
  final headers = await _getHeaders();
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((worker) => worker['id'] as int).toList();
  } else {
    throw Exception('Failed to load worker IDs');
  }
}

}
