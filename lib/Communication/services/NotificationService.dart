import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/notification.dart';

class NotificationService {
  final String baseUrl = "https://sweetmanager-api.ryzeon.me/swagger/index.html";

  Future<bool> createNotification(Notifications notification) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create notification');
    }
  }

  Future<List<Notifications>> getAllNotifications(int hotelId) async {
    final url = Uri.parse("$baseUrl/get-all-notifications?hotelId=$hotelId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Notifications.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<Notifications> getNotificationById(int id) async {
    final url = Uri.parse("$baseUrl/get-notification-by-id?id=$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Notifications.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Notification not found');
    }
  }
}
