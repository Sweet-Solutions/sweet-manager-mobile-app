
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:sweetmanager/ResourceManagement/models/report.dart';



class ReportService{
  final String baseUrl; 

  ReportService({required this.baseUrl});

  Future<List<dynamic>> getReports() async {
    final response = await http.get(Uri.parse('$baseUrl/reports'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  Future<Report> getReportById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/reports/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load report');
    }
  }

  //TODO - Implementarle eso de insertar una imagen
  
  Future<dynamic> createReport(Map<String, dynamic> report, File? imageFile) async {
  var uri = Uri.parse('$baseUrl/reports');
  var request = http.MultipartRequest('POST', uri);

  // Añadir los datos del reporte como campos del formulario
  report.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  if (imageFile != null) {
    // Determinar el tipo MIME de la imagen
    var mimeType = lookupMimeType(imageFile.path)?.split('/');
    
    // Agregar la imagen como archivo multipart
    request.files.add(
      await http.MultipartFile.fromPath(
        'fileUrl', // Nombre del campo en el backend
        imageFile.path,
        contentType: MediaType(mimeType![0], mimeType[1]),
      ),
    );
  }

  // Enviar la solicitud y recibir la respuesta
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to create report');
  }
}
} 
