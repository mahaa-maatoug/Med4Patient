import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'OrdonnanceController.dart';



class AddOrdonnanceScreen extends StatefulWidget {
  @override
  _AddOrdonnanceScreenState createState() => _AddOrdonnanceScreenState();
}

class _AddOrdonnanceScreenState extends State<AddOrdonnanceScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;
  late final OrdonnanceController _controller;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _controller = Get.find<OrdonnanceController>();
  }

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
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(Icons.upload, size: 28, color: Colors.blue[800]),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Prescription Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        Divider(color: Colors.grey[300], thickness: 1),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Note Field
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notes (Optional)",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.notes_outlined, color: Colors.blue[800]),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // File Selection Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prescription Files',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        if (_controller.selectedFiles.isNotEmpty)
                          ..._controller.selectedFiles.map((file) => Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              leading: Icon(Icons.insert_drive_file, color: Colors.blue[800]),
                              title: Text(
                                file.path.split('/').last,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.close, color: Colors.red[400]),
                                onPressed: () => _controller.removeFile(file),
                              ),
                            ),
                          )).toList(),

                        OutlinedButton.icon(
                          icon: Icon(Icons.attach_file, color: Colors.blue[800], size: 22),
                          label: Text(
                            'Select Files',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: _controller.pickFiles,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue[800]!, width: 1.2),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Selected files: ${_controller.selectedFiles.length}/5',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            if (_controller.selectedFiles.isEmpty)
                              Text(
                                'Please select at least one file',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ],
                    )),
                  ),
                  SizedBox(height: 30),

                  // Upload Button
                  Obx(() => ElevatedButton(
                    onPressed: _controller.isLoading.value ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      minimumSize: Size(double.infinity, 50),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: _controller.isLoading.value
                        ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : Text(
                      'Upload Prescription',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_controller.selectedFiles.isEmpty) {
      Get.snackbar('Error', 'Please select at least one file');
      return;
    }

    _controller.createAndUploadOrdonnance(
      note: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}