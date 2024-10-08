import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HotelForm(),
    );
  }
}

class HotelForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sweet Manager',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF1C4257), // Color similar al azul de la cabecera
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Acción para el ícono del menú
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Aquí envolvemos el Column en un SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Hotel Name', 'Heden Golf'),
              SizedBox(height: 16),
              _buildTextField('Hotel Address', 'Av. La Mar'),
              SizedBox(height: 16),
              _buildTextField('Contact Information', 'Hola'),
              SizedBox(height: 16),
              _buildTextField('Hotel Description (Optional)', 'Descripción'),
              SizedBox(height: 16),
              _buildTextField('Email', 'hedengolf@gmail.com', keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildDropdown('Timezone (Country)', 'Perú'),
              SizedBox(height: 16), // Espacio extra en lugar de Spacer()
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al guardar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1C4257),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text('Save', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildTextField(String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String selectedItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedItem,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: ['Perú', 'Argentina', 'Colombia']
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: (value) {
            // Acción al seleccionar una opción
          },
        ),
      ],
    );
  }
}
