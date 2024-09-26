import 'package:flutter/material.dart';
import 'customer_model.dart';

class EditarClientePage extends StatefulWidget {
  final Cliente cliente;

  EditarClientePage({required this.cliente});

  @override
  _EditarClientePageState createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  final _formKey = GlobalKey<FormState>();
  late String dni;
  late String nombre;
  late String contacto;

  @override
  void initState() {
    super.initState();
    dni = widget.cliente.dni;
    nombre = widget.cliente.nombre;
    contacto = widget.cliente.contacto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: dni,
                decoration: InputDecoration(labelText: 'DNI'),
                onChanged: (value) {
                  setState(() {
                    dni = value;
                  });
                },
              ),
              TextFormField(
                initialValue: nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
              ),
              TextFormField(
                initialValue: contacto,
                decoration: InputDecoration(labelText: 'Contacto'),
                onChanged: (value) {
                  setState(() {
                    contacto = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.cliente.dni = dni;
                    widget.cliente.nombre = nombre;
                    widget.cliente.contacto = contacto;
                  });
                  Navigator.pop(context, 'Cliente actualizado con éxito');
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
