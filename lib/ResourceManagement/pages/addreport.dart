import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sweetmanager/ResourceManagement/pages/reportlist.dart';

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
  File? _imageFile;
  final picker = ImagePicker(); // Para manejar la imagen seleccionada.

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportList(),
                        ));
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
                // Espacio en blanco para centrar el título
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),

            // Selección del tipo de reporte
            ElevatedButton(
              onPressed: () {
                // Acción para seleccionar tipo de reporte
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Selecciona el tipo de reporte >',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            // Texto de instrucciones
            const Text(
              'Agrega detalles para enviar tu reporte',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  onPressed: _pickImage, // Método para seleccionar una imagen
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
                onPressed: _submitReport, // Método para manejar el envío del formulario
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color del botón de enviar
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

  // Método para seleccionar una imagen
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Método para manejar el envío del formulario
  void _submitReport() {
    String username = usernameController.text;
    String title = titleController.text;
    String content = contentController.text;

    if (username.isEmpty || title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    // Aquí puedes manejar el envío del reporte al backend
  }
}
