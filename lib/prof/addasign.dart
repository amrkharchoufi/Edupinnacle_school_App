import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddAssignment extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  final color;
  const AddAssignment(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass,
      required this.color});

  @override
  State<AddAssignment> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController link = TextEditingController();
  bool showLinkField = false;
  bool showAttachField = false;
  String? selectedFilePath;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Add more extensions if needed
    );

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  }

  void _clearFile() {
    setState(() {
      selectedFilePath = null;
    });
  }

  void _addAssignment() async {
    // Validate input fields (you can add more validation logic as needed)
    if (title.text.isEmpty || date.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Validation Error"),
          content: Text("Please enter title and due date."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Add assignment to Firestore and upload file to Firebase Storage
    try {
      // Upload file to Firebase Storage
      String? fileUrl;
      if (selectedFilePath != null) {
        File file = File(selectedFilePath!);
        final path = 'assignments/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(file);
        fileUrl = await ref.getDownloadURL();
      }

      // Add assignment details to Firestore
      await FirebaseFirestore.instance.collection('Assignement').add({
        'idclass': widget.idclass, // Replace with actual class ID
        'idmodule': widget.idmodule, // Replace with actual module ID
        'idprof': widget.idprof, // Replace with actual professor ID
        'title': title.text,
        'date': date.text,
        'link': link.text,
        'fileUrl': fileUrl,
      });

      // Clear input fields and reset state
      setState(() {
        title.clear();
        date.clear();
        link.clear();
        selectedFilePath = null;
        showAttachField = false;
        showLinkField = false;
      });

      // Show success message or navigate to a success screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Assignment added successfully!"),
        ),
      );
    } catch (e) {
      // Handle errors, e.g., Firebase exceptions
      print("Error adding assignment: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred. Please try again later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Add Assignment",
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 80),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assignment Title:",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Myinput(
                    width: 400,
                    label: "setTitle",
                    type: TextInputType.text,
                    obscure: false,
                    mycontrol: title,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Due to:",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Myinput1(
                    width: 400,
                    label: "setDate",
                    type: TextInputType.datetime,
                    obscure: false,
                    mycontrol: date,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Attach Document:",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Switch(
                        value: showAttachField,
                        onChanged: (value) {
                          setState(() {
                            showAttachField = value;
                            if (!value) {
                              // Clear file selection if switching off
                              _clearFile();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  if (showAttachField)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _openFilePicker,
                              child: Text("Choose File"),
                            ),
                            SizedBox(width: 10),
                            if (selectedFilePath != null)
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedFilePath!.split('/').last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: _clearFile,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Assignment Link:",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Switch(
                        value: showLinkField,
                        onChanged: (value) {
                          setState(() {
                            showLinkField = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (showLinkField)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Myinput(
                          width: 400,
                          label: "setLink",
                          type: TextInputType.text,
                          obscure: false,
                          mycontrol: link,
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addAssignment,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Text("ADD"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}