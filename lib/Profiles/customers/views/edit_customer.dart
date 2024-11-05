import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/customers/models/customer_model.dart';
import 'package:sweetmanager/Profiles/customers/services/customerservices.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({super.key, required this.customer});

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _stateController;
  bool isLoading = false;

  final Customerservice _customerService = Customerservice('https://sweetmanager-api.ryzeon.me'); // Cambia la URL base

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.customer.email);
    _phoneController = TextEditingController(text: widget.customer.phone.toString());
    _stateController = TextEditingController(text: widget.customer.state);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Crear el objeto actualizado
      Map<String, dynamic> updatedCustomer = {
        'id': widget.customer.id,
        'email': _emailController.text,
        'phone': int.parse(_phoneController.text),
        'state': _stateController.text,
      };

      // Llamar al servicio de actualización
      await _customerService.updateCustomer(widget.customer.id, updatedCustomer);

      // Regresar a la pantalla anterior con datos actualizados
      Navigator.of(context).pop(updatedCustomer);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error al actualizar el cliente: $e'),
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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(); // Regresar a la pantalla anterior
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Editar Cliente',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF474C74),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
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
                        _buildEditableRow(Icons.email, 'Email:', _emailController),
                        const SizedBox(height: 10),
                        _buildEditableRow(Icons.phone, 'Teléfono:', _phoneController),
                        const SizedBox(height: 10),
                        _buildEditableRow(Icons.check_circle, 'Estado:', _stateController),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: _updateCustomer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF474C74),
                              ),
                              child: const Text(
                                'Guardar cambios',
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
          ],
        ),
      ),
    );
  }

  // Método para construir campos editables
  Widget _buildEditableRow(IconData icon, String title, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF474C74)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
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
