import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/providers/models/provider_model.dart';
import 'package:sweetmanager/Profiles/providers/services/providerservices.dart';

class ProviderEditScreen extends StatefulWidget {
  final Provider provider;

  const ProviderEditScreen({super.key, required this.provider});

  @override
  _ProviderEditScreenState createState() => _ProviderEditScreenState();
}

class _ProviderEditScreenState extends State<ProviderEditScreen> {
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _stateController;
  bool isLoading = false;

  final ProviderService _providerService = ProviderService('https://sweetmanager-api.ryzeon.me'); // Cambia la URL base

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.provider.address);
    _emailController = TextEditingController(text: widget.provider.email);
    _phoneController = TextEditingController(text: widget.provider.phone.toString());
    _stateController = TextEditingController(text: widget.provider.state);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _updateProvider() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Crear el objeto actualizado
      Map<String, dynamic> updatedProvider = {
        'id': widget.provider.id,
        'address': _addressController.text,
        'email': _emailController.text,
        'phone': int.parse(_phoneController.text),
        'state': _stateController.text,
      };

      // Llamar al servicio de actualización
      await _providerService.updateProvider(updatedProvider);

      // Regresar a la pantalla anterior con datos actualizados
      Navigator.of(context).pop(updatedProvider);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error al actualizar el proveedor: $e'),
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
                  'Editar Proveedor',
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
                        _buildEditableRow(Icons.location_on, 'Dirección:', _addressController),
                        const SizedBox(height: 10),
                        _buildEditableRow(Icons.email, 'Email:', _emailController),
                        const SizedBox(height: 10),
                        _buildEditableRow(Icons.phone, 'Teléfono:', _phoneController),
                        const SizedBox(height: 10),
                        _buildEditableRow(
                          Icons.check_circle,
                          'Estado:',
                          _stateController,
                          color: widget.provider.state == 'Activo' ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: _updateProvider,
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
  Widget _buildEditableRow(IconData icon, String title, TextEditingController controller, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color ?? const Color(0xFF474C74)),
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
