import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sweetmanager/ResourceManagement/models/typereport.dart';

class TypesReportService {
  final String apiUrl = 'https://your-api-endpoint.com/api/types-reports'; // Cambia esto por tu URL real

  Future<List<TypesReport>> fetchTypesReports() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<TypesReport> typesReports = body
          .map((dynamic item) => TypesReport.fromJson(item))
          .toList();
      return typesReports;
    } else {
      throw Exception('Error al obtener los tipos de reportes');
    }
  }
}
