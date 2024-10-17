import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Commerce/widgets/plan_card.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class SubscriptionPlansView extends StatelessWidget{
  

  final storage = const FlutterSecureStorage();

  Future<String?> _getRole() async
  {
    // Retrieve token from local storage

    String? token = await storage.read(key: 'token');

    Map<String,dynamic> decodedToken = JwtDecoder.decode(token!);

      // Get Role in Claims token

    return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
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
            childScreen: getContentView()
          );
        }

        return const Center(child: Text('Unable to get information', textAlign: TextAlign.center,));
      }
    );
  }

  Widget getContentView()
  {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back_login.png'), // Replace with your background image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Centered Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select a plan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Basic Plan Card
                    PlanCard(
                      color: Colors.brown[200]!,
                      planName: 'Básico',
                      price: '29.50',
                      features: const [
                        'Max 5 Empleados',
                        'Max 1 Administrador',
                        'Max 50 Dormitorios',
                        'Almacenamiento de 5 GB',
                      ],
                      buttonColor: Colors.black,
                      behavior: () {
                        // Connection to checkout subscription dart view
                      },
                    ),
                    const SizedBox(height: 20),
                    // Regular Plan Card
                    PlanCard(
                      color: Colors.white,
                      borderColor: Colors.blueAccent,
                      planName: 'Regular',
                      price: '58.99',
                      features: const [
                        'Max 150 habitaciones',
                        'Max 3 Administrador',
                        'Max 15 trabajadores',
                        'Almacenamiento de 20 GB',
                      ],
                      buttonColor: Colors.indigo[800]!,
                      behavior: () {
                        // Connection to checkout subscription dart view
                      },
                    ),
                    const SizedBox(height: 20,),
                    PlanCard(
                      color: Colors.brown,
                      borderColor: Colors.transparent,
                      planName: 'Regular',
                      price: '110.69',
                      features: const [
                        'Dormitorios ilimitados',
                        'Administradores Ilimitados',
                        'Trabajadores Ilimitados',
                        'Almacenamiento de 500 GB',
                      ],
                      buttonColor: const Color.fromARGB(255, 39, 89, 109)!,
                      behavior: () {
                        // Connection to checkout subscription dart view
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}