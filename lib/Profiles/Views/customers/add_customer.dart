import 'package:flutter/material.dart';
import 'customer_model.dart';

class AgregarClientePage extends StatefulWidget {
  @override
  _AgregarClientePageState createState() => _AgregarClientePageState();
}

class _AgregarClientePageState extends State<AgregarClientePage> {
  final _formKey = GlobalKey<FormState>();
  String dni = '';
  String nombre = '';
  String contacto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'DNI'),
                onChanged: (value) {
                  setState(() {
                    dni = value;
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? 'Este campo es obligatorio' : null;
                },
              ),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Cliente nuevoCliente = Cliente(
                      dni: dni,
                      nombre: nombre,
                      contacto: contacto,
                    );
                    clientes.add(nuevoCliente);
                    Navigator.pop(context, 'Cliente agregado con éxito');
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
