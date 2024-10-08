import 'package:flutter/material.dart';
import 'package:sweetmanager/supply-management/models/supply.dart';
import 'package:sweetmanager/supply-management/views/supplyaddscreen.dart';
import 'package:sweetmanager/supply-management/views/supplyeditscreen.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  List<Supply> supplies = [
    Supply(id: 10, providersId: 1, name: 'Shampoo', price: 3.99, stock: 10, state: 'Out of Stock'),
    Supply(id: 210, providersId: 2, name: 'Soap', price: 1.99, stock: 20, state: 'In Stock'),
    Supply(id: 99, providersId: 3, name: 'Blanket', price: 5.10, stock: 15, state: 'In Stock'),
    Supply(id: 433, providersId: 4, name: 'Toothbrush', price: 1.99, stock: 25, state: 'In Stock'),
  ];

  void _showDeleteConfirmationDialog(Supply supply) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: Text('¿Estás seguro de que quieres eliminar el producto "${supply.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin eliminar
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  supplies.remove(supply); 
                });
                Navigator.of(context).pop(); 
              },
              child: const Text(
                "Eliminar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente todo el contenido
          children: [
            const Text(
              'Gestión de Inventario',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Botones centrados en una fila
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra horizontalmente los botones
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupplyAddScreen(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF474C74), // Color de fondo
                  ),
                  child: const Text('Agregar', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20), // Espacio entre los botones
                ElevatedButton(
                  onPressed: () {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF474C74), 
                  ),
                  child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            const SizedBox(height: 20), // Espacio entre los botones y la tabla

            // Tabla de datos
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Habilita desplazamiento horizontal si es necesario
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return const Color(0xFF474C74); // Color de fondo para la fila de encabezado
                  },
                ),
                dataRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.grey.withOpacity(0.5); // Color cuando una fila es seleccionada
                    }
                    return Colors.white; // Color por defecto de las filas
                  },
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'ID',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del encabezado
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Producto',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del encabezado
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Cantidad',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del encabezado
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Acciones',
                        style: TextStyle(
                          color: Colors.white, // Color del texto del encabezado
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: supplies.map((supply) {
                  return DataRow(
                    cells: [
                      DataCell(Text(supply.id.toString())),
                      DataCell(Text(supply.name)),
                      DataCell(Text(supply.stock.toString())),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SupplyEditScreen(supply: supply),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF474C74), // Color de fondo
                              ),
                              child: const Text('Edit', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(supply);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text('Rows per page: 4      1-4 of 365'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
