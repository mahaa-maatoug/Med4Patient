import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';



class AddressMap extends StatelessWidget {
  final Map<String, dynamic> address;

  const AddressMap({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final lat = address['lat']?.toDouble() ?? 0.0;
    final long = address['long']?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Adresse:',
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
        Text(address['address'] ?? 'Adresse non disponible'),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat, long),  // Changed from center
                initialZoom: 15.0,                // Changed from zoom
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Updated URL
                  userAgentPackageName: 'com.example.medifront',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,  // Added required width
                      height: 40.0, // Added required height
                      point: LatLng(lat, long),
                      child: const Icon(  // Changed from builder
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}