import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../IAM/services/auth_service.dart';
import '../models/notification.dart';

class NotificationService {
  final String baseUrl = "http://localhost:5181/api/v1/notifications";
  final AuthService _authService = AuthService(); // Instancia de AuthService

  // Obtener el token de autenticación
  Future<String?> _getAuthToken() async {
    return await _authService.storage.read(key: 'token');
  }

  // Crear una nueva notificación
  Future<bool> createNotification(Notifications notification) async {
    final token = await _getAuthToken(); // Obtiene el token de autenticación

    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Añadir el token a los encabezados
      },
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create notification');
    }
  }

  // Obtener todas las notificaciones de un hotel específico
  Future<List<Notifications>> getAllNotifications(int hotelId) async {
    final token = await _getAuthToken();

    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse('$baseUrl/get-all-notifications?hotelId=$hotelId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Añadir el token a los encabezados
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Notifications.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Obtener una notificación específica por ID
  Future<Notifications> getNotificationById(int id) async {
    final token = await _getAuthToken();

    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse('$baseUrl/get-notification-by-id?id=$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Añadir el token a los encabezados
      },
    );

    if (response.statusCode == 200) {
      return Notifications.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Notification not found');
    }
  }
}
