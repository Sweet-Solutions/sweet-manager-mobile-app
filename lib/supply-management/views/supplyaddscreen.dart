import 'package:flutter/material.dart';
import 'package:sweetmanager/supply-management/services/supplyservices.dart'; // Asegúrate de importar tu servicio

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

  bool isLoading = false; // Variable para manejar el estado de carga

  final SupplyService _supplyService = SupplyService('https://example.com'); // Cambia la URL base

  Future<void> _addSupply() async {
    setState(() {
      isLoading = true; // Mostrar el indicador de carga
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
      await _supplyService.createSupply(newSupply);

      // Mostrar un mensaje de éxito o regresar a la pantalla anterior
      Navigator.of(context).pop();
    } catch (e) {
      // Manejar errores (por ejemplo, mostrar un diálogo con el error)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error al agregar el suministro: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Ocultar el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Row(
                    children: [
                      Text(
                        'Agregar Suministro',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF474C74)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController, // Asignar controlador
                    decoration: const InputDecoration(
                      icon: Icon(Icons.label),
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _providersIdController, // Asignar controlador
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_2),
                      labelText: 'ID del proveedor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Asegurar que solo se ingresen números
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _stockController, // Asignar controlador
                    decoration: const InputDecoration(
                      icon: Icon(Icons.shopping_cart),
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Asegurar que solo se ingresen números
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceController, // Asignar controlador
                    decoration: const InputDecoration(
                      icon: Icon(Icons.attach_money),
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // Asegurar que solo se ingresen números
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _stateController, // Asignar controlador
                    decoration: const InputDecoration(
                      icon: Icon(Icons.check_circle),
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? const CircularProgressIndicator() // Mostrar indicador de carga si isLoading es true
                          : ElevatedButton(
                              onPressed: _addSupply, // Llamar a la función para agregar el suministro
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF474C74),
                              ),
                              child: const Text('Agregar', style: TextStyle(color: Colors.white)),
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
    // Liberar los controladores de texto cuando se destruya el widget
    _nameController.dispose();
    _providersIdController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _stateController.dispose();
    super.dispose();
  }
}
