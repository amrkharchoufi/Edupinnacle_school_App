import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  PDFViewerPage({required this.pdfUrl});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      // Create a reference to the file in Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(widget.pdfUrl);

      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${ref.name}';

      // Download the file and save it locally
      final file = File(filePath);

      if (!await file.exists()) {
        // Create a new file on disk
        await file.create();

        // Start the file download
        await ref.writeToFile(file);

        // Make sure the download is complete before proceeding
        await ref.getDownloadURL(); // This ensures the download is complete.
      }

      // Update the state to reflect the local file path
      setState(() {
        localFilePath = filePath;
      });
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: localFilePath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localFilePath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              onRender: (_pages) {
                setState(() {});
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            ),
    );
  }
}
