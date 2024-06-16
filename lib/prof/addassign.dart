import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAssignment extends StatefulWidget {
  final String idmodule;
  final String idprof;
  final String idclass;
  final Color color;

  const AddAssignment({
    Key? key,
    required this.idmodule,
    required this.idprof,
    required this.idclass,
    required this.color,
  }) : super(key: key);

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
      allowedExtensions: ['pdf', 'doc', 'docx'],
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
  // Validate input fields
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

  try {
    String? fileUrl;
    String? filename;

    if (selectedFilePath != null) {
      File file = File(selectedFilePath!);
      final path =
          'assignments/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      fileUrl = await ref.getDownloadURL();
      filename = selectedFilePath!.split('/').last;
    }

    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(now); // Fixed the format

    // Add assignment details to Firestore
    await FirebaseFirestore.instance.collection('Assignement').add({
      'idclass': widget.idclass,
      'idmodule': widget.idmodule,
      'idprof': widget.idprof,
      'title': title.text,
      'duedate': date.text,
      'createdAt': formattedDate,
      'link': showLinkField ? link.text : null,
      'fileUrl': fileUrl,
      'filename': filename,
    });

    // Clear input fields
    title.clear();
    date.clear();
    link.clear();
    selectedFilePath = null;
    showAttachField = false;
    showLinkField = false;

    // Show success dialog
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: 'Assignment successfully Added.',
      btnOkOnPress: () {
        Navigator.pop(context, true); // Pop the page
      },
    ).show();
  } catch (e) {
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
      appBar: AppBar(
        title: Text(
          "Assignement",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: widget.color,
      ),
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
