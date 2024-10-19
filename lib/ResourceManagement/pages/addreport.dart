import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage
import 'package:path/path.dart' as path; // Para obtener el nombre del archivo
import 'package:sweetmanager/ResourceManagement/models/typereport.dart';
import 'package:sweetmanager/ResourceManagement/services/typesreportservice.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile; // Imagen seleccionada
  final picker = ImagePicker();
  int? selectedTypeReportId; // ID del tipo de reporte seleccionado
  List<TypesReport> typesReports = []; // Lista de tipos de reportes
  final TypesReportService _typesReportService = TypesReportService(); // Servicio para obtener los tipos de reporte
  String? imageUrl; // URL de la imagen subida a Firebase

  @override
  void initState() {
    super.initState();
    fetchTypesReports(); // Llamada a la API al iniciar
  }

  // Método para obtener los tipos de reportes
  Future<void> fetchTypesReports() async {
    try {
      List<TypesReport> fetchedReports = await _typesReportService.fetchTypesReports();
      setState(() {
        typesReports = fetchedReports;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener los tipos de reportes')),
      );
    }
  }

  // Método para seleccionar una imagen y luego subirla a Firebase
  Future<void> _pickImageAndUpload() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Sube la imagen a Firebase Storage
      String fileName = path.basename(pickedFile.path);
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('report_images/$fileName');
        UploadTask uploadTask = ref.putFile(_imageFile!);

        // Espera a que la tarea se complete
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl; // Guarda la URL de la imagen
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen cargada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar la imagen: $e')),
        );
      }
    }
  }

  // Método para manejar el envío del formulario
  void _submitReport() {
    String username = usernameController.text;
    String title = titleController.text;
    String content = contentController.text;

    if (username.isEmpty || title.isEmpty || content.isEmpty || selectedTypeReportId == null || imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios, incluyendo la imagen.')),
      );
      return;
    }

    // Aquí puedes manejar el envío del reporte al backend, incluyendo imageUrl
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flecha y Título centrado
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
                      'HACER UN REPORTE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),

            // Selección del tipo de reporte
            typesReports.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<int>(
                    value: selectedTypeReportId,
                    items: typesReports.map((TypesReport reportType) {
                      return DropdownMenuItem<int>(
                        value: reportType.id,
                        child: Text(reportType.name),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedTypeReportId = newValue;
                      });
                    },
                    hint: const Text('Selecciona el tipo de reporte'),
                  ),
          
            const SizedBox(height: 16),

            // Campo de Usuario
            const Text('Usuario'),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuario',
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Título
            const Text('Título'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Título',
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Contenido
            const Text('Contenido'),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contenido',
              ),
            ),
            const SizedBox(height: 16),

            // Botón para subir imagen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImageAndUpload, // Método para seleccionar e intentar subir una imagen
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Subir Imagen'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botón de enviar el reporte
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
                  'Mandar',
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
