import 'dart:io';
import 'package:edupinacle/mywidgets/pdfpage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PDFApi {
  static Future<File> loadFirebase(String url) async {
    final refPDF = FirebaseStorage.instance.ref().child(url);
    final bytes = await refPDF.getData();
   return _storeFile(url, bytes!);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  
}
