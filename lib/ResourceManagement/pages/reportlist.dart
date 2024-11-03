import 'package:flutter/material.dart';
import 'package:sweetmanager/ResourceManagement/components/reportcard.dart';
import 'package:sweetmanager/ResourceManagement/pages/addreport.dart';
import 'package:sweetmanager/ResourceManagement/models/report.dart';
import 'package:sweetmanager/ResourceManagement/services/reportservice.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart'; // Import AuthService
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isSearching = false;
  bool isLoading = true;
  List<Report> reports = [];
  List<Report> filteredReports = [];
  late ReportService reportService;
  final storage = const FlutterSecureStorage();
  String? role;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(); 
    reportService = ReportService(
      baseUrl: 'https://sweetmanager-api.ryzeon.me/api', 
      authService: authService,
    );
    fetchReports();
  }

  Future<String?> _getRole() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
    }
    return null;
  }

  Future<void> fetchReports() async {
    try {
      final List<dynamic> reportData = await reportService.getReports();
      setState(() {
        reports = reportData.map((data) => Report.fromJson(data)).toList();
        filteredReports = reports; 
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading role'));
        }

        role = snapshot.data;

        return BaseLayout(
          role: role,
          childScreen: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
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
                                  isSearching = !isSearching;
                                  if (!isSearching) {
                                    searchController.clear();
                                    searchQuery = "";
                                    filteredReports = reports;
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
          ),
        );
      },
    );
  }
}
