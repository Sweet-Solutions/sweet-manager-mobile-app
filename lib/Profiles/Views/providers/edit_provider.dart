import 'package:flutter/material.dart';
import 'provider_model.dart';

class EditarProveedorPage extends StatefulWidget {
  final Proveedor proveedor;

  EditarProveedorPage({required this.proveedor});

  @override
  _EditarProveedorPageState createState() => _EditarProveedorPageState();
}

class _EditarProveedorPageState extends State<EditarProveedorPage> {
  final _formKey = GlobalKey<FormState>();
  late String nombre;
  late String contacto;
  late String direccion;
  late String producto;

  @override
  void initState() {
    super.initState();
    nombre = widget.proveedor.nombre;
    contacto = widget.proveedor.contacto;
    direccion = widget.proveedor.direccion;
    producto = widget.proveedor.producto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              TextFormField(
                initialValue: direccion,
                decoration: InputDecoration(labelText: 'Dirección'),
                onChanged: (value) {
                  setState(() {
                    direccion = value;
                  });
                },
              ),
              TextFormField(
                initialValue: producto,
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
                    setState(() {
                      widget.proveedor.nombre = nombre;
                      widget.proveedor.contacto = contacto;
                      widget.proveedor.direccion = direccion;
                      widget.proveedor.producto = producto;
                    });
                    Navigator.pop(context, 'Proveedor actualizado con éxito');
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
