import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:sweetmanager/ResourceManagement/models/report.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Ensure you import your AuthService class

class ReportService {
  final String baseUrl;
  final AuthService authService; // AuthService dependency

  ReportService({required this.baseUrl, required this.authService});

  // Helper method to get the headers with token
  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all reports
  Future<List<dynamic>> getReports() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/reports'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  // Get a report by ID
  Future<Report> getReportById(int id) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/reports/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Report.fromJson(json.decode(response.body)); // Ensure Report.fromJson exists
    } else {
      throw Exception('Failed to load report');
    }
  }

  // Create a new report, optionally with an image
  Future<dynamic> createReport(Map<String, dynamic> report, File? imageFile) async {
    final headers = await _getHeaders();
    var uri = Uri.parse('$baseUrl/reports/create');
    var request = http.MultipartRequest('POST', uri);

    // Add report data as form fields
    report.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the headers including the token
    request.headers.addAll(headers);

    if (imageFile != null) {
      // Get the MIME type of the image
      var mimeType = lookupMimeType(imageFile.path)?.split('/');

      // Add the image as a multipart file
      request.files.add(
        await http.MultipartFile.fromPath(
          'fileUrl', // Name of the field expected by the backend
          imageFile.path,
          contentType: MediaType(mimeType![0], mimeType[1]),
        ),
      );
    }

    // Send the request and get the response
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create report');
    }
  }
}
