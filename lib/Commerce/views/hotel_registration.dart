

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Commerce/services/commerce_service.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class HotelRegistration extends StatefulWidget {
  const HotelRegistration({super.key});

  @override
  State<HotelRegistration> createState() => _HotelRegistrationState();
}

class _HotelRegistrationState extends State<HotelRegistration> {

  // Declare Services

  final storage = const FlutterSecureStorage();

  final _commerceService = CommerceService();

  // Declare all variables

  final TextEditingController _hotelNameController = TextEditingController();

  final TextEditingController _hotelAddressController = TextEditingController();

  final TextEditingController _contactController = TextEditingController();

  final TextEditingController _hotelDescriptionController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();


  Future<String?> _getIdentity() async
  {
    // Retrieve token from local storage

    String? token = await storage.read(key: 'token');

    Map<String,dynamic> decodedToken = JwtDecoder.decode(token!);

    // Get Role in Claims token

    return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/Sid']?.toString();
  }


  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose() {
    _hotelNameController.dispose();

    _hotelAddressController.dispose();

    _contactController.dispose();

    _hotelDescriptionController.dispose();

    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getIdentity(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.hasData)
        {
          String identity = snapshot.data!;

          return BaseLayout(
            role: '',
            childScreen: getContentView(context, identity)
          );
        }

        return const Center(child: Text('Unable to get information', textAlign: TextAlign.center,));
      }
    );
  }


  Widget getContentView(BuildContext context, String identity)
  {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _hotelNameController, 
                  decoration: const InputDecoration(
                    labelText: 'Hotel Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 60,),
                TextField(
                  controller: _hotelAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Hotel Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 60,),
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Information',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 60,),
                TextField(
                  controller: _hotelDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Hotel Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      // Access cardIdentifier here
                      print('${_hotelNameController.text}');
                      print('${_hotelAddressController.text}');
                      print('${_contactController.text}');
                      print('${_hotelDescriptionController.text}');
                      print('${_emailController.text}');
                      
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 16),
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}