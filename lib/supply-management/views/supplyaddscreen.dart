import 'package:flutter/material.dart';
import 'package:sweetmanager/supply-management/services/supplyservices.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SupplyAddScreen extends StatefulWidget {
  const SupplyAddScreen({super.key});

  @override
  State<SupplyAddScreen> createState() => _SupplyAddScreenState();
}

class _SupplyAddScreenState extends State<SupplyAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _providersIdController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  bool isLoading = false;

  late SupplyService _supplyService;
  late AuthService _authService;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _supplyService = SupplyService('http://localhost:5181', _authService);
  }

  Future<void> _addSupply() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Crear un mapa con los datos del nuevo suministro
      Map<String, dynamic> newSupply = {
        'name': _nameController.text,
        'providersId': int.parse(_providersIdController.text),
        'stock': int.parse(_stockController.text),
        'price': double.parse(_priceController.text),
        'state': _stateController.text,
      };

      // Llamar al servicio para crear el suministro
      final response = await _supplyService.createSupply(newSupply);

      // Asumir que si no hubo error, la operación fue exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supply addded succesfully')),
      );
      Navigator.of(context).pop(true); // Regresar con un resultado de éxito
    } catch (e) {
      // Manejar errores con un Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Faild to load supplies: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Supply'),
        backgroundColor: const Color(0xFF474C74),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Supply',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF474C74),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.label),
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _providersIdController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_2),
                      labelText: 'Provider ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.shopping_cart),
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.attach_money),
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.check_circle),
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _addSupply,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF474C74),
                              ),
                              child: const Text(
                                'Add Supply',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _providersIdController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _stateController.dispose();
    super.dispose();
  }
}
