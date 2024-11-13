import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';  // Correcto

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetmanager/ResourceManagement/models/typereport.dart';
import 'package:sweetmanager/ResourceManagement/services/typesreportservice.dart';
import 'package:sweetmanager/ResourceManagement/services/reportservice.dart';

import 'dart:io'; // Para File


class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController adminController = TextEditingController();
  final TextEditingController workerController = TextEditingController();
  ImagePicker imagePicker = ImagePicker(); 

  XFile? pickedFile;  // Usamos Xfile en lugar de PlatformFile
  String imageurl = ''; // Esta variable contendrá la URL de la imagen después de subirla
  int? selectedTypeReportId;
  List<TypesReport> typesReports = [];
  late TypesReportService typesReportService;
  late ReportService reportService;

  @override
  void initState() {
    super.initState();
    typesReportService = TypesReportService();
    reportService = ReportService();
    fetchTypesReports();
  }

  // Método para seleccionar la imagen
  Future<void> selectFile() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.camera); // Usamos cámara para la selección
    if (file == null) return;

    setState(() {
      pickedFile = file;  // Asignamos el archivo seleccionado directamente
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File "${pickedFile!.name}" selected')),
    );
  }

  // Método para enviar el reporte
  Future<void> _submitReport() async {
    // Verificar que todos los campos obligatorios están completos
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        selectedTypeReportId == null ||
        pickedFile == null ||
        adminController.text.isEmpty ||
        workerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required, including the file.')),
      );
      return;
    }

    try {
      // Subir la imagen a Firebase Storage y obtener su URL
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final referenceRoot = FirebaseStorage.instance.ref();
      final referenceDirImages = referenceRoot.child('images');
      final referenceImageToUpload = referenceDirImages.child(uniqueFileName);

      // Subir el archivo a Firebase Storage
      await referenceImageToUpload.putFile(File(pickedFile!.path));

      // Obtener la URL de la imagen subida
      imageurl = await referenceImageToUpload.getDownloadURL();

      // Preparar los datos del reporte
      final reportData = {
        'typesReportsId': selectedTypeReportId,
        'adminsId': int.parse(adminController.text),
        'workersId': int.parse(workerController.text),
        'title': titleController.text,
        'description': contentController.text,
        'fileUrl': imageurl, // Guardamos la URL de la imagen subida
      };

      // Enviar el reporte
      final response = await reportService.createReport(reportData, null);

      // Comprobar respuesta y redirigir si es exitoso
      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully')),
        );
        Navigator.pop(context, true); // Pasamos `true` para indicar éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit report')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
      );
      Navigator.pop(context, true); // Pasamos `false` para indicar error
    }
  }

  // Método para obtener los tipos de reporte
  Future<void> fetchTypesReports() async {
    try {
      List<TypesReport> fetchedReports = await typesReportService.fetchTypesReports();
      setState(() {
        typesReports = fetchedReports;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching report types')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Create Report',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),
            typesReports.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<int>(
                    value: selectedTypeReportId,
                    items: typesReports.map((TypesReport reportType) {
                      return DropdownMenuItem<int>(
                        value: reportType.id,
                        child: Text(reportType.title),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedTypeReportId = newValue;
                      });
                    },
                    hint: const Text('Select report type'),
                  ),
            const SizedBox(height: 8),
            const Text('Admin ID'),
            TextField(
              controller: adminController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Admin ID',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Worker ID'),
            TextField(
              controller: workerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Worker ID',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Title'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Content'),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Content',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: selectFile,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Select File'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (pickedFile != null) // Mostrar el nombre del archivo seleccionado
              Text("Selected: ${pickedFile!.name}"),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
