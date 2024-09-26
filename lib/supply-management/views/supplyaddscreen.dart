import 'package:flutter/material.dart';

class SupplyAddScreen extends StatefulWidget {
  const SupplyAddScreen({super.key});

  @override
  State<SupplyAddScreen> createState() => _SupplyAddScreenState();
}

class _SupplyAddScreenState extends State<SupplyAddScreen> {


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
                  const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.label),
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_2),
                      labelText: 'ID del proveedor',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.shopping_cart),
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.attach_money),
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.check_circle),
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción del botón
                          Navigator.of(context).pop();
                        },
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
          )
        )

    );
  }


}