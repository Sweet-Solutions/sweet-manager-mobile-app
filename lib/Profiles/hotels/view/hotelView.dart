import 'package:flutter/material.dart';
import 'package:sweetmanager/Commerce/views/room_types_setup.dart';
import 'package:sweetmanager/Profiles/hotels/models/hotel.dart';

class HotelDetailScreen extends StatelessWidget {
  // Recibe el hotel como parámetro en el constructor
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

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
                  'https://i.pinimg.com/564x/29/1b/10/291b104087960aa6b0c63e1aca8a7977.jpg', // Cambia esto si tienes una URL en el modelo
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hotel.name, // Usar el nombre del hotel
                        style: const TextStyle(
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
                    icon: const Icon(Icons.share, color: Colors.white),
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
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        hotel.address, // Usar la dirección del hotel
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HOTEL INFO',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildHotelInfoRow('Name', hotel.name),
                  _buildHotelInfoRow('Address', hotel.address),
                  _buildHotelInfoRow('Phone Number', hotel.phoneNumber),
                  _buildHotelInfoRow('Email', hotel.email),
                  _buildHotelInfoRow('Owner ID', hotel.ownerId.toString()),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.description, // Usar la descripción del hotel
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RoomTypesSetup()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C4257),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
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
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
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