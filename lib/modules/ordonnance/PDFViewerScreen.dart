import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Importer le package PDF

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: PDFView(
          filePath: 'http://10.0.2.2:3000$pdfPath', // Assurez-vous que le fichier PDF est accessible via l'URL
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
        ),
      ),
    );
  }
}
