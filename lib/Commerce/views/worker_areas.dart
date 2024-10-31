import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Commerce/services/commerce_service.dart';

import '../../Shared/widgets/base_layout.dart';

class WorkerAreasSelection extends StatefulWidget {
  const WorkerAreasSelection({super.key});

  @override
  State<WorkerAreasSelection> createState() => _WorkerAreasSelectionState();
}

class _WorkerAreasSelectionState extends State<WorkerAreasSelection> {

  final storage = const FlutterSecureStorage();

  final _commerceService = CommerceService();

  final List<Map<String, dynamic>> workAreas = [
    {"name": "Kitchen Staff", "selected": false},
    {"name": "Housekeeping", "selected": false},
    {"name": "Wait Staff", "selected": false},
    {"name": "Security", "selected": false},
    {"name": "Room Service", "selected": false},
    {"name": "Reception", "selected": false},
    {"name": "Valet and Bellhop", "selected": false},
    {"name": "Laundry", "selected": false},
    {"name": "Spa Wellness Staff", "selected": false},
    {"name": "Concierge", "selected": false},
  ];

  Future<String?> _getRole() async
  {
    // Retrieve token from local storage

    String? token = await storage.read(key: 'token');

    Map<String,dynamic> decodedToken = JwtDecoder.decode(token!);

    // Get Role in Claims token

    return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
  }

  void toggleSelection(int index) {
    setState(() {
      workAreas[index]["selected"] = !workAreas[index]["selected"];
    });
  }

  void submitSelection() async {
    List<String> selectedAreas = workAreas
        .where((area) => area["selected"])
        .map((area) => area["name"] as String)
        .toList();

    var isWrong = false;

    for(var workerAreas in workAreas.where((wa) => wa["selected"]))
    {
      
    }


    print("Selected Work Areas: $selectedAreas");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getRole(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.hasData)
        {
          String? role = snapshot.data;

          return BaseLayout(
            role: role,
            childScreen: getContentView(role)
          );
        }

        return const Center(child: Text('Unable to get information', textAlign: TextAlign.center,));
      }
    );
  }

  Widget getContentView(String? role)
  {
    if(role == 'ROLE_OWNER')
    {
      return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Dark overlay for readability
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select the work areas of your hotel.\nYou can select more than one.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: workAreas.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(
                            workAreas[index]["name"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: workAreas[index]["selected"],
                          onChanged: (bool? value) {
                            toggleSelection(index);
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: submitSelection,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    }
    else
    {
      return const Scaffold(
        body: Center(child: Text('You are not authorized!'),),
      );
    }
  }
}