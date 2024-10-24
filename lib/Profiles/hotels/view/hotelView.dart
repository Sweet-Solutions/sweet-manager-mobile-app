import 'package:flutter/material.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

@override
Widget build(BuildContext context) { // Implements design for login view.
  return BaseLayout(role: '', childScreen: HotelDetailScreen());
}
class HotelDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://i.pinimg.com/564x/29/1b/10/291b104087960aa6b0c63e1aca8a7977.jpg', // Imagen personalizada
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Capa oscura semitransparente para oscurecer la imagen
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4), // Oscurecimiento
                ),
                // Botón de regresar (sin funcionalidad)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // No hay funcionalidad aquí, el botón es solo visual
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Heden Golf',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón de compartir en la esquina superior derecha
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      // Acción para compartir
                    },
                  ),
                ),
                // Dirección en la parte inferior derecha
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Av. La mar 1415',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Título "Sweet Manager"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sweet Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C4257),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOTEL INFO',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  _buildHotelInfoRow('Name', 'Heden Golf'),
                  _buildHotelInfoRow('Address', 'Av. La mar'),
                  _buildHotelInfoRow('Phone Number', '941 691 025'),
                  _buildHotelInfoRow('Email', 'hedengolf@gmail.com'),
                  _buildHotelInfoRow('Timezone (Country)', 'Perú'),
                  _buildHotelInfoRow('Language', 'English'),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ofrece habitaciones confortables con vistas al océano y acceso directo a la playa. Es ideal para disfrutar de una estancia relajante en un ambiente costero tranquilo.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción de guardar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1C4257),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
