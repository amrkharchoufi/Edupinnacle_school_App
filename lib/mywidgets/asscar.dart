// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/pdf.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Assigncard extends StatefulWidget {
  final String module;
  final String dateass;
  final String lastdate;
  final Bool status;
  final String Title;
  const Assigncard({
    super.key,
    required this.module,
    required this.Title,
    required this.dateass,
    required this.lastdate,
    required this.status,
  });
  State<Assigncard> createState() => _AssigncardState();
}

class _AssigncardState extends State<Assigncard> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _initializeColors();
    });
  }

  Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: brightenColor(primaryColor, 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: primaryColor, // Border color
            width: 1, // Border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                    color: brightenColor(primaryColor, 0.4),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  widget.module,
                  style: TextStyle(color: primaryColor, fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.Title,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "myfont1"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assign Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Last Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Status"),
                      ]),
                  Column(children: [
                    Text(widget.dateass),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.lastdate),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.status.toString()),
                  ])
                ],
              ),
              const SizedBox(height: 20),
              if (widget.status == false)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                    child: const Text(
                      "To be Submitted",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

class Assignprcard extends StatefulWidget {
  final String module;
  final String dateass;
  final String lastdate;
  final String Title;
  final Function delete;
  final Function vue;
  final String? link;
  final String? filename;

  const Assignprcard({
    super.key,
    required this.module,
    required this.Title,
    required this.dateass,
    required this.lastdate,
    required this.delete,
    this.link,
    this.filename, required this.vue,
  });
  State<Assignprcard> createState() => _AssignprcardState();
}

class _AssignprcardState extends State<Assignprcard> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      _initializeColors();
    });
  }

  Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: brightenColor(primaryColor, 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: primaryColor, // Border color
            width: 1, // Border width
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                        color: brightenColor(primaryColor, 0.4),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      widget.module,
                      style: TextStyle(color: primaryColor, fontSize: 15),
                    ),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: widget.vue != null
                            ? () => widget.vue!()
                            : null,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: widget.delete != null
                            ? () => widget.delete!()
                            : null,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.Title,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "myfont1"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assign Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Last Date"),
                        SizedBox(
                          height: 5,
                        ),
                      ]),
                  Column(children: [
                    Text(widget.dateass),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.lastdate),
                    const SizedBox(
                      height: 5,
                    ),
                  ])
                ],
              ),
              const SizedBox(height: 20),
              if (widget.link != null && widget.link!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Link :"),
                    Text(widget.link!),
                    const SizedBox(height: 10),
                  ],
                ),
              if (widget.filename != null && widget.filename!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("File Link:"),
                    Text(
                      widget.filename!,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
            ])));
  }
}

class Assign2card extends StatefulWidget {
  final String module;
  final String dateass;
  final String lastdate;
  final String Title;
  final String? link;
  final String? filename;
  final String? fileurl;
  final bool status;
  final String idoc;

  const Assign2card({
    super.key,
    required this.module,
    required this.Title,
    required this.dateass,
    required this.lastdate,
    this.link,
    this.filename,
    required this.status,
    this.fileurl,
    required this.idoc,
  });
  State<Assign2card> createState() => _Assign2cardState();
}

class _Assign2cardState extends State<Assign2card> {
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

  Future<void> _launchURL(String url) async {
    // Check if the URL can be launched
    if (await canLaunch(url)) {
      // If yes, launch it
      await launch(url);
    } else {
      // If no, throw an error or handle accordingly
      throw 'Could not launch $url';
    }
  }

  void addAssigndoc(String selectedFilePath) async {
    String? fileUrl;
    String? filename;
    File file = File(selectedFilePath);
    final path =
        'assignments/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    fileUrl = await ref.getDownloadURL();
    filename = filename = selectedFilePath.split('/').last;
    await FirebaseFirestore.instance
        .collection('etudiant_assign')
        .doc(widget.idoc)
        .update({'fileurl': fileUrl, 'filename': filename, 'status': true});
  }

  void addAssign() async {
    await FirebaseFirestore.instance
        .collection('etudiant_assign')
        .doc(widget.idoc)
        .update({'status': true});
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      _initializeColors();
    });
  }

  Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: brightenColor(primaryColor, 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: primaryColor, // Border color
            width: 1, // Border width
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                    color: brightenColor(primaryColor, 0.4),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  widget.module,
                  style: TextStyle(color: primaryColor, fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.Title,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "myfont1"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assign Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Last Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Status"),
                      ]),
                  Column(children: [
                    Text(widget.dateass),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.lastdate),
                    const SizedBox(
                      height: 5,
                    ),
                    if (widget.status == true) Text("Submitted"),
                    if (widget.status == false) Text("Not Submitted"),
                  ])
                ],
              ),
              const SizedBox(height: 20),
              if (widget.link != null && widget.link!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Link :"),
                    InkWell(child: Text(widget.link!)),
                    const SizedBox(height: 10),
                  ],
                ),
              if (widget.filename != null && widget.filename!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ressource:"),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PDFViewerPage(pdfUrl: widget.fileurl!),
                          ),
                        );
                      },
                      child: Text(
                        widget.filename!,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (selectedFilePath != null)
                      Row(children: [
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
                      ])
                  ],
                ),
              const SizedBox(height: 20),
              if (widget.status == false && widget.filename != null) ...[
                if (selectedFilePath == null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _openFilePicker();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(primaryColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 16)),
                      ),
                      child: const Text(
                        "Upload",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                if (selectedFilePath != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        addAssigndoc(selectedFilePath!);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(primaryColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 16)),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
              ],
              if (widget.status == false && widget.filename == null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchURL(widget.link!);
                      addAssign();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ])));
  }
}
