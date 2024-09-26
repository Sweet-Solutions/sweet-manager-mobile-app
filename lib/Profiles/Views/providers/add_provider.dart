import 'package:flutter/material.dart';
import 'provider_model.dart';

class AgregarProveedorPage extends StatefulWidget {
  @override
  _AgregarProveedorPageState createState() => _AgregarProveedorPageState();
}

class _AgregarProveedorPageState extends State<AgregarProveedorPage> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String contacto = '';
  String direccion = '';
  String producto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? 'Este campo es obligatorio' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contacto'),
                onChanged: (value) {
                  setState(() {
                    contacto = value;
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? 'Este campo es obligatorio' : null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección'),
                onChanged: (value) {
                  setState(() {
                    direccion = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Producto'),
                onChanged: (value) {
                  setState(() {
                    producto = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Proveedor nuevoProveedor = Proveedor(
                      nombre: nombre,
                      contacto: contacto,
                      direccion: direccion,
                      producto: producto,
                    );
                    proveedores.add(nuevoProveedor);
                    Navigator.pop(context, 'Proveedor agregado con éxito');
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
