import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage import
import 'package:path/path.dart' as path; // For file path manipulation
import 'package:sweetmanager/ResourceManagement/models/typereport.dart';
import 'package:sweetmanager/ResourceManagement/services/typesreportservice.dart';
import 'package:sweetmanager/ResourceManagement/services/reportservice.dart'; // ReportService import
import 'package:sweetmanager/IAM/services/auth_service.dart'; // AuthService import

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
  File? _imageFile; // Selected image file
  final picker = ImagePicker();
  int? selectedTypeReportId; // ID of the selected report type
  List<TypesReport> typesReports = []; // List of report types
  late TypesReportService typesReportService; // Service to fetch types of reports
  late ReportService reportService; // Report service
  String? imageUrl; // URL of the image uploaded to Firebase

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); // Instantiate AuthService
    typesReportService = TypesReportService(
      baseUrl: 'http://localhost:5181/api', 
      authService: authService
    );
    reportService = ReportService(
        baseUrl: 'http://localhost:5181/api',
        authService: authService);
    fetchTypesReports(); // Fetch types of reports on init
  }

  // Fetch report types from the API
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

  // Pick an image and upload it to Firebase
  Future<void> _pickImageAndUpload() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage
      String fileName = path.basename(pickedFile.path);
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('report_images/$fileName');
        UploadTask uploadTask = ref.putFile(_imageFile!);

        // Wait for the upload to complete
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl; // Save the image URL
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  // Handle form submission
  Future<void> _submitReport() async {
    String username = usernameController.text;
    String title = titleController.text;
    String content = contentController.text;

    if (username.isEmpty || title.isEmpty || content.isEmpty || selectedTypeReportId == null || imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required, including the image.')),
      );
      return;
    }

    // Create the report data
    Map<String, dynamic> reportData = {
      'username': username,
      'title': title,
      'description': content,
      'typesReportsId': selectedTypeReportId,
      'fileUrl': imageUrl, // Use the uploaded image URL
    };

    try {
      await reportService.createReport(reportData, _imageFile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
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
            // Back arrow and centered title
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Placeholder for space alignment
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown for selecting report type
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
          
            const SizedBox(height: 16),

            // User field
            const Text('User'),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User',
              ),
            ),
            const SizedBox(height: 16),

            // Title field
            const Text('Title'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),

            // Content field
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

            // Upload image button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImageAndUpload, // Select and upload image
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Upload Image'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Submit report button
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
