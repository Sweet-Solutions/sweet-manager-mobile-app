import 'package:flutter/material.dart';
import 'package:sweetmanager/ResourceManagement/components/reportcard.dart';
import 'package:sweetmanager/ResourceManagement/pages/addreport.dart';
import 'package:sweetmanager/ResourceManagement/models/report.dart';
import 'package:sweetmanager/ResourceManagement/services/reportservice.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isSearching = false; // State to show the search TextField
  bool isLoading = true; // Loading state
  List<Report> reports = []; // List of reports
  List<Report> filteredReports = []; // Filtered list of reports
  late ReportService reportService; // ReportService instance

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); // Instantiate AuthService
    reportService = ReportService(
      baseUrl: 'http://localhost:5181/api', // Set your localhost URL
      authService: authService,
    );
    fetchReports(); // Fetch reports on initialization
  }

  Future<void> fetchReports() async {
    try {
      // Call the service to get reports
      final List<dynamic> reportData = await reportService.getReports();
      setState(() {
        reports = reportData.map((data) => Report.fromJson(data)).toList();
        filteredReports = reports; // Initially, show all reports
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if necessary
      print('Error fetching reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Container with padding and rounded borders around the header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0), // Rounded border
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow downwards
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reports',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // If isSearching is true, display the search field
                      isSearching
                          ? SizedBox(
                              width: 200,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                    filteredReports = reports.where((report) {
                                      return report.title.toLowerCase().contains(searchQuery.toLowerCase());
                                    }).toList();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search reports',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            isSearching = !isSearching; // Toggle search state
                            if (!isSearching) {
                              searchController.clear();
                              searchQuery = "";
                              filteredReports = reports; // Reset report list
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddReport(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Show a loading indicator while fetching data
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ReportCard(report: filteredReports[index], index: index),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
