import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetmanager/ResourceManagement/models/typereport.dart';
import 'package:sweetmanager/ResourceManagement/services/typesreportservice.dart';
import 'package:sweetmanager/ResourceManagement/services/reportservice.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PlatformFile? pickedFile;
  String? base64File;
  int? selectedTypeReportId;
  List<TypesReport> typesReports = [];
  late TypesReportService typesReportService;
  late ReportService reportService;
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    final authService = AuthService();
    typesReportService = TypesReportService(
      baseUrl: 'https://sweetmanager-api.ryzeon.me/api',
      authService: authService,
    );
    reportService = ReportService(
      baseUrl: 'https://sweetmanager-api.ryzeon.me/api',
      authService: authService,
    );
    fetchTypesReports();
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    
    setState(() {
      pickedFile = result.files.first;
      base64File = base64Encode(pickedFile!.bytes!); // Encode file to Base64
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File "${pickedFile!.name}" selected')),
    );
  }

  Future<void> _submitReport() async {
    if (usernameController.text.isEmpty ||
        titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        selectedTypeReportId == null ||
        base64File == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required, including the file.')),
      );
      return;
    }

    final reportData = {
      'username': usernameController.text,
      'title': titleController.text,
      'description': contentController.text,
      'typesReportsId': selectedTypeReportId,
      'fileBase64': base64File, // Store the Base64 file content
      'fileName': pickedFile!.name,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await firestore.collection('reports').add(reportData); // Save in Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting report: $e')),
      );
    }
  }

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
            const SizedBox(height: 16),
            const Text('User'),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User',
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
            if (pickedFile != null) // Show selected file name
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
