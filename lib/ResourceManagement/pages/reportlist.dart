import 'package:flutter/material.dart';
import 'package:sweetmanager/ResourceManagement/components/reportcard.dart';
import 'package:sweetmanager/ResourceManagement/components/reportdata.dart';
import 'package:sweetmanager/ResourceManagement/pages/addreport.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isSearching = false; // Estado para mostrar el TextField de búsqueda

  @override
  Widget build(BuildContext context) {
    // Filtrar los reportes según la búsqueda
    List filteredReports = reports.where((report) {
      return report.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Contenedor con padding y borde redondeado alrededor del encabezado
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0), // Borde redondeado
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Sombra hacia abajo
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
                      // Si isSearching es true, mostramos el campo de búsqueda
                      isSearching
                          ? SizedBox(
                              width: 200,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Buscar reportes',
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
                            isSearching = !isSearching; // Alternar búsqueda
                            if (!isSearching) {
                              searchController.clear();
                              searchQuery = "";
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
          // Lista de reportes
          Expanded(
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
