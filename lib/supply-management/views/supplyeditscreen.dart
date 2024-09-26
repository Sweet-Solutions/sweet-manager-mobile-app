import 'package:flutter/material.dart';
import 'package:sweetmanager/supply-management/models/supply.dart';

class SupplyEditScreen extends StatefulWidget {
  final Supply supply; // Este es el supply que se va a editar.

  const SupplyEditScreen({super.key, required this.supply});

  @override
  _SupplyEditScreenState createState() => _SupplyEditScreenState();
}

class _SupplyEditScreenState extends State<SupplyEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _providersIdController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores actuales del objeto supply.
    _nameController = TextEditingController(text: widget.supply.name);
    _providersIdController = TextEditingController(text: widget.supply.providersId.toString());
    _stockController = TextEditingController(text: widget.supply.stock.toString());
    _priceController = TextEditingController(text: widget.supply.price.toStringAsFixed(2));
    _stateController = TextEditingController(text: widget.supply.state);
  }

  @override
  void dispose() {
    // Limpiar los controladores cuando no se usen más.
    _nameController.dispose();
    _providersIdController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Añadir un espacio alrededor de todo el contenido
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder( // Bordes redondeados
              borderRadius: BorderRadius.circular(15.0), // Radio de 15 px
            ),
            elevation: 8,
            child: Padding( 
              padding: const EdgeInsets.all(20.0), // Añadir un espacio alrededor del contenido del Card
              child: Column(
                mainAxisSize: MainAxisSize.min, // Tamaño principal mínimo
                crossAxisAlignment: CrossAxisAlignment.start, // Alinear los elementos a la izquierda
                children: [
                  const Row(
                    children: [
                      Icon(Icons.inventory, size: 28, color: Color(0xFF474C74)),
                      SizedBox(width: 10),
                      Text(
                        'Editar Producto',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF474C74),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  
                  // TextField para nombre del producto
                  _buildEditableRow(Icons.label, 'Producto:', _nameController),
                  const Divider(),
                  
                  // TextField para ID del proveedor
                  _buildEditableRow(Icons.person_2, 'Id del Proveedor:', _providersIdController),
                  const Divider(),
                  
                  // TextField para cantidad
                  _buildEditableRow(Icons.shopping_cart, 'Cantidad:', _stockController),
                  const Divider(),
                  
                  // TextField para precio
                  _buildEditableRow(Icons.attach_money, 'Precio:', _priceController),
                  const Divider(),
                  
                  // TextField para estado
                  _buildEditableRow(
                    Icons.check_circle,
                    'Estado:',
                    _stateController,
                    color: widget.supply.state == 'In Stock' ? Colors.green : Colors.red,
                  ),
                  const Divider(),
                  
                  // Botón de guardar cambios
                  ElevatedButton(
                    onPressed: () {
                      // Actualizar el objeto supply con los nuevos valores
                      final updatedSupply = Supply(
                        id: widget.supply.id,
                        name: _nameController.text,
                        providersId: int.parse(_providersIdController.text),
                        stock: int.parse(_stockController.text),
                        price: double.parse(_priceController.text),
                        state: _stateController.text,
                      );
                      // Devolver el objeto actualizado a la pantalla anterior
                      Navigator.of(context).pop(updatedSupply);
                    },
                    child: const Text('Guardar cambios'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método reutilizable para construir los campos editables con TextField
  Widget _buildEditableRow(IconData icon, String title, TextEditingController controller, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color ?? const Color(0xFF474C74)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller, // Controlador que maneja el texto
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
