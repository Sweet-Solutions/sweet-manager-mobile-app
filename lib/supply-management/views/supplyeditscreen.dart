import 'package:flutter/material.dart';
import 'package:sweetmanager/supply-management/models/supply.dart';
import 'package:sweetmanager/supply-management/services/supplyservices.dart'; // Asegúrate de importar tu servicio

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
  bool isLoading = false; // Variable para el estado de carga

  final SupplyService _supplyService = SupplyService('https://example.com'); // Cambia la URL base

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

  Future<void> _updateSupply() async {
    setState(() {
      isLoading = true; // Mostrar el indicador de carga
    });

    try {
      // Actualizar el objeto supply con los nuevos valores del formulario
      Map<String, dynamic> updatedSupply = {
        'name': _nameController.text,
        'providersId': int.parse(_providersIdController.text),
        'stock': int.parse(_stockController.text),
        'price': double.parse(_priceController.text),
        'state': _stateController.text,
      };

      // Llamar al servicio para actualizar el suministro
      await _supplyService.updateSupply(widget.supply.id, updatedSupply);

      // Regresar a la pantalla anterior con los datos actualizados
      Navigator.of(context).pop(updatedSupply);
    } catch (e) {
      // Manejar errores (por ejemplo, mostrar un diálogo con el error)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error al actualizar el suministro: $e'),
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
                  isLoading
                    ? const Center(child: CircularProgressIndicator()) // Mostrar indicador de carga si isLoading es true
                    : ElevatedButton(
                        onPressed: _updateSupply, // Llamar al método que actualiza el suministro
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
