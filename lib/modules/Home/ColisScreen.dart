import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colis.controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';



class ColisScreen extends StatelessWidget {
  final ColisController controller = Get.put(ColisController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width:  105,
              height: 44,
            ),
            SizedBox(width: 10),
            Flexible( // Added Flexible to prevent text overflow
              child: Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis, // Handles long text
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,

        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.fetchPackages,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${controller.errorMessage.value}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.fetchPackages,
                    child: Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (controller.packages.isEmpty) {
            return Center(child: Text('Aucun colis trouvé'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.packages.length,
            itemBuilder: (context, index) {
              final package = controller.packages[index];
              return _buildPackageCard(package, index);
            },
          );
        }),
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package, int index) {
    final deliveryTime = package['deliveryTime'] == 'AM' ? 'Matin' : 'Après-midi';
    final address = package['address'] ??
        (package['addresses'] != null && package['addresses'].isNotEmpty
            ? package['addresses'][0]
            : null);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Colis ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                if (package['priority'] == true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Prioritaire',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            Divider(height: 24, thickness: 1),
            _buildInfoRow(
              icon: Icons.local_pharmacy,
              text: package['pharmacyId'] ?? 'Pharmacie inconnue',
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.calendar_today,
              text: '${package['deliveryDate']} à $deliveryTime',
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(package['status']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(package['status']),
                  width: 1,
                ),
              ),
              child: Text(
                package['status'],
                style: TextStyle(
                  color: _getStatusColor(package['status']),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            if (address != null && address['lat'] != null && address['long'] != null)
              _buildAddressMapSection(address)
            else
              Text(
                'Pas d\'adresse disponible',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue[800]),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressMapSection(Map<String, dynamic> address) {
    final lat = address['lat']?.toDouble() ?? 0.0;
    final long = address['long']?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adresse:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          address['address'] ?? 'Adresse non spécifiée',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 16),
        Container(
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat, long),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.medifront',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(lat, long),
                      child: Icon(
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En préparation':
        return Colors.orange;
      case 'Prêt':
        return Colors.blue;
      case 'Livré':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Filtrer les colis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => CheckboxListTile(
              title: Text('Prioritaires seulement'),
              value: controller.priorityFilter.value,
              onChanged: (value) {
                controller.priorityFilter.value = value!;
              },
            )),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.statusFilter.value,
              items: [
                DropdownMenuItem(
                  value: 'En préparation',
                  child: Text('En préparation'),
                ),
                DropdownMenuItem(
                  value: 'Prêt',
                  child: Text('Prêt'),
                ),
                DropdownMenuItem(
                  value: 'Livré',
                  child: Text('Livré'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.statusFilter.value = value;
                }
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              controller.fetchPackages();
              Get.back();
            },
            child: Text('Appliquer'),
          ),
        ],
      ),
    );
  }
}