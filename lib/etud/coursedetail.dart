import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:edupinacle/mywidgets/coursedetcard.dart';
import 'package:edupinacle/mywidgets/pdf.dart';

import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  final color;
  const CourseDetail(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass,
      required this.color});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  var url;
  String? filepath;
  bool isLoaded = false;
  List<Coursedetcard1> cards = [];
  Future<void> getdata() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Feed')
        .where('IDclass', isEqualTo: widget.idclass)
        .where('IDprof', isEqualTo: widget.idprof)
        .where('IDmodule', isEqualTo: widget.idmodule)
        .get();

    List<Coursedetcard1> newCards = []; // Temporary list to hold new cards

    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;
      Map<String, dynamic> feed = doc.get('Feed') as Map<String, dynamic>;
      feed.forEach((date, value) {
        // value should be a map containing 'message' and 'file'
        Map<String, dynamic> messageDetails = value as Map<String, dynamic>;
        String message = messageDetails['message'] ?? '';
        String filename = messageDetails['file'] ?? '';
        String fileurl = messageDetails['url'] ?? '';
        newCards.add(
          Coursedetcard1(
            message: message,
            prof: doc.get('IDprof'),
            date: date,
            file: filename == ''
                ? SizedBox(
                    width: 10,
                  )
                : GestureDetector(
                    onTap: () async {
                      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFViewerPage(pdfUrl: fileurl),
              ),
            );
                    },
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        child: Column(
                          children: [
                            Icon(
                              Icons.file_copy,
                              size: 40,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(filename)
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      });
    } else {
      // Handle the case where no document was found
      print('No document found for the given criteria.');
    }

    setState(() {
      cards.clear();
      cards.addAll(newCards);
      isLoaded = true; // Mark data as loaded
    });
  }


  @override
  void initState() {
    getdata();
    super.initState();
  }

  TextEditingController msg = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: widget.color,
      ),
      body: isLoaded
        ? Column(
            children: [
              cards.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          return cards[index];
                        },
                      ),
                    )
                  : Text(
                      'No Messages yet !',
                      style: TextStyle(fontSize: 17),
                    )
            ],
          )
        : Center(child: CircularProgressIndicator())
  );}
}