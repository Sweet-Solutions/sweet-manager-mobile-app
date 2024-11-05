import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetmanager/ResourceManagement/models/typereport.dart';
import 'package:sweetmanager/ResourceManagement/services/typesreportservice.dart';
import 'package:sweetmanager/ResourceManagement/services/reportservice.dart';


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
    typesReportService = TypesReportService();
    reportService = ReportService();
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
  // Check that all required fields are completed
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
    // Step 1: Upload the image to Firestore and get its URL
    String? imageUrl;
    if (pickedFile != null) {
      final storageRef = FirebaseFirestore.instance.collection('report_images').doc();
      await storageRef.set({
        'fileName': pickedFile!.name,
        'content': base64File,
      });
      imageUrl = storageRef.path;
    }

    // Step 2: Prepare report data
    final reportData = {
      'typesReportsId': selectedTypeReportId,
      'adminsId': int.parse(adminController.text),
      'workersId': int.parse(workerController.text),
      'title': titleController.text,
      'description': contentController.text,
      'fileUrl': imageUrl ?? base64File,
    };

    // Send the report
    final response = await reportService.createReport(reportData, null);

    // Check response and redirect if successful
    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.pop(context, true); // Pass `true` to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit report')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting report: $e')),
    );
    Navigator.pop(context, true); // Pass `false` to indicate failure
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
