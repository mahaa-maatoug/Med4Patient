import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Ordonnance.dart';
import 'OrdonnanceController.dart';
import 'PDFViewerScreen.dart';
import 'add_ordonnance_screen.dart';

import 'package:intl/intl.dart';

import 'datefilterwidget.dart';



class OrdonnanceListScreen extends StatelessWidget {
  final OrdonnanceController controller = Get.put(OrdonnanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 105,
              height: 44,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                "",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[800]),
        elevation: 0,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              controller.showAllPrescriptions.value ? Icons.filter_alt : Icons.list,
              color: Colors.blue[800],
            )),
            onPressed: () => controller.toggleViewMode(),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue[800]),
            onPressed: () {
              if (controller.showAllPrescriptions.value) {
                controller.fetchOrdonnances();
              } else {
                controller.fetchOrdonnancesByDate();
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (!controller.showAllPrescriptions.value)
            DateFilterWidget(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.ordonnances.isEmpty) {
                return Center(
                  child: Text(
                    'No prescriptions found',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.ordonnances.length,
                itemBuilder: (context, index) {
                  final ordonnance = controller.ordonnances[index];
                  return _buildOrdonnanceCard(ordonnance);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, size: 28),
        onPressed: () => Get.to(() => AddOrdonnanceScreen()),
      ),
    );
  }



  Widget _buildOrdonnanceCard(Ordonnance ordonnance) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          if (ordonnance.storagePath.isNotEmpty)
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ordonnance.storagePath.length,
                itemBuilder: (context, imgIndex) {
                  final filePath = ordonnance.storagePath[imgIndex];
                  if (filePath.endsWith('.pdf')) {
                    // Afficher le fichier PDF
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () {
                            // Lorsque l'utilisateur clique sur un PDF, ouvrez-le dans un écran complet
                            Get.to(() => PDFViewerScreen(pdfPath: filePath));
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Afficher l'image
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://10.0.2.2:3000$filePath',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey[500]),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 150,
                              height: 150,
                              color: Colors.white,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ListTile(
            title: Text(
              ordonnance.note ?? 'No note provided',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text('Status: ${controller.getStatusDisplay(ordonnance.prescriptionStatus)}'),
                Text('Files: ${ordonnance.storagePath.length}'),
                if (ordonnance.createdAt != null)
                  Text('Created: ${DateFormat('MMM dd, yyyy').format(ordonnance.createdAt)}'),
                if (ordonnance.reviewedAt != null)
                  Text('Reviewed: ${DateFormat('MMM dd, yyyy').format(ordonnance.reviewedAt!)}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue[800]),
                  onPressed: () => _showEditDialog(ordonnance),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[400]),
                  onPressed: () => _confirmDelete(ordonnance.id),
                ),
              ],
            ),
            onTap: () => _showPrescriptionDetails(ordonnance),
          ),
        ],
      ),
    );
  }

  void _showPrescriptionDetails(Ordonnance ordonnance) {
    Get.defaultDialog(
      title: 'Prescription Details',
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (ordonnance.storagePath.isNotEmpty)
              ...ordonnance.storagePath.map((path) => Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Image.network(
                  'http://10.0.2.2:3000$path',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    );
                  },
                ),
              )).toList(),

            if (ordonnance.note != null)
              ListTile(
                title: Text('Note'),
                subtitle: Text(ordonnance.note!),
              ),
            ListTile(
              title: Text('Status'),
              subtitle: Text(controller.getStatusDisplay(ordonnance.prescriptionStatus)),
            ),
            ListTile(
              title: Text('Created'),
              subtitle: Text(DateFormat('MMM dd, yyyy - HH:mm').format(ordonnance.createdAt)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Close'),
        ),
      ],
    );
  }


  void _showEditDialog(Ordonnance ordonnance) {
    final patientIdController = TextEditingController(text: ordonnance.patientId);
    final pharmacyIdController = TextEditingController(text: ordonnance.pharmacyId);
    final noteController = TextEditingController(text: ordonnance.note);
    var currentStatus = ordonnance.prescriptionStatus.obs;

    Get.defaultDialog(
      title: 'Edit Prescription',
      content: SingleChildScrollView(
        child: Column(
          children: [

            TextFormField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Note (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<PrescriptionStatus>(
              value: currentStatus.value,
              items: PrescriptionStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(controller.getStatusDisplay(status)),
                );
              }).toList(),
              onChanged: (status) => currentStatus.value = status!,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (patientIdController.text.isEmpty || pharmacyIdController.text.isEmpty) {
              Get.snackbar('Error', 'Patient ID and Pharmacy ID are required');
              return;
            }

            controller.updateOrdonnance(
              id: ordonnance.id,

              note: noteController.text.isNotEmpty ? noteController.text : null,
              prescriptionStatus: currentStatus.value,
            );
            Get.back();
          },
          child: Text('Save'),
        ),
      ],
    );
  }



  void _confirmDelete(String ordonnanceId) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      content: Text('Are you sure you want to delete this prescription?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            controller.deleteOrdonnance(ordonnanceId);
            Get.back();
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }


  }
