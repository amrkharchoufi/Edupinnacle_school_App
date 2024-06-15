// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edupinacle/mywidgets/PdfAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/coursedetcard.dart';
import 'package:edupinacle/mywidgets/notfound.dart';
import 'package:edupinacle/mywidgets/pdfpage.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:edupinacle/staff/administration/class/addclass.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PRCoursesdet extends StatefulWidget {
  final String idmodule;
  final String idclass;
  final String idprof;
  const PRCoursesdet(
      {super.key,
      required this.idmodule,
      required this.idclass,
      required this.idprof});

  @override
  State<PRCoursesdet> createState() => _PRCoursesState();
}

class _PRCoursesState extends State<PRCoursesdet> {
  int _currentIndex = 0;
  List<Widget> _pages = [];
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      print("Timer triggered. Refreshing colors...");
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
    _pages = [
      Feed(
        idmodule: widget.idmodule,
        idprof: widget.idprof,
        idclass: widget.idclass,
        color: primaryColor,
      ),
      Notes(
        idmodule: widget.idmodule,
        idprof: widget.idprof,
        idclass: widget.idclass,
        color: primaryColor,
      ),
      Assignment(
        idmodule: widget.idmodule,
        idprof: widget.idprof,
        idclass: widget.idclass,
        color: primaryColor,
      ),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String submodule = widget.idmodule;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          submodule,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Grades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignement',
          ),
        ],
      ),
    );
  }
}

class Feed extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  final color;
  const Feed(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass,
      required this.color});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  var url;
  String? filepath;
  bool isLoaded = false;
  List<Coursedetcard> cards = [];
  final TextEditingController _text = TextEditingController();

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );

  Future<void> deleteMessage(
      String timestamp, String msg, String fileurl) async {
    // Query Firestore to get the document containing the feed
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Feed')
        .where('IDclass', isEqualTo: widget.idclass)
        .where('IDprof', isEqualTo: widget.idprof)
        .where('IDmodule', isEqualTo: widget.idmodule)
        .get();

    // Check if the query result is not empty
    if (query.docs.isNotEmpty) {
      // Get the first document from the query result
      DocumentSnapshot doc = query.docs.first;

      // Get the 'Feed' map from the document
      Map<String, dynamic> feed = doc.get('Feed') as Map<String, dynamic>;

      // Remove the entry with the specified timestamp and message
      feed.removeWhere(
          (key, value) => key == timestamp && value['message'] == msg);

      // Update the Firestore document with the modified feed
      await FirebaseFirestore.instance
          .collection('Feed')
          .doc(doc.id)
          .update({'Feed': feed});

      // Delete file from Firebase Storage
      await FirebaseStorage.instance.ref().child(fileurl).delete();

      // Update local state to remove the deleted card
      setState(() {
        cards.removeWhere(
            (card) => card.date == timestamp && card.message == msg);
      });
    } else {
      // Handle the case where no documents match the query criteria
      print('No document found for the given criteria.');
    }
  }

  Future<void> getdata() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Feed')
        .where('IDclass', isEqualTo: widget.idclass)
        .where('IDprof', isEqualTo: widget.idprof)
        .where('IDmodule', isEqualTo: widget.idmodule)
        .get();

    List<Coursedetcard> newCards = []; // Temporary list to hold new cards

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
          Coursedetcard(
            message: message,
            prof: 'Moi',
            date: date,
            file: filename == ''
                ? SizedBox(
                    width: 10,
                  )
                : GestureDetector(
                    onTap: () async {
                      final file = await PDFApi.loadFirebase(fileurl);
                      if (file == null) return;
                      openPDF(context, file);
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
            delete: MaterialButton(
              onPressed: () {
                deleteMessage(date, message, fileurl);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.black,
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

  void addMessage(String msg, String? path, var url) async {
    DateTime currentDate = DateTime.now();
    int year = currentDate.year;
    int month = currentDate.month;
    int day = currentDate.day;
    int hour = currentDate.hour;
    int minute = currentDate.minute;
    int second = currentDate.second;

    // Format the date
    String formattedDate =
        '$year-$month-$day $hour:$minute:$second'; // Example format: 2024-06-02

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Feed')
        .where('IDclass', isEqualTo: widget.idclass)
        .where('IDprof', isEqualTo: widget.idprof)
        .where('IDmodule', isEqualTo: widget.idmodule)
        .get();

    if (query.docs.isNotEmpty) {
      // Assuming there's only one document in the query result
      DocumentSnapshot doc = query.docs.first;

      // Get the current 'feed' map from the document
      Map<String, dynamic> feed = doc.get('Feed') as Map<String, dynamic>;

      // Add the new message to the feed
      if (path != null && url != null) {
        feed[formattedDate] = {'message': msg, 'file': path, 'url': url};
      } else {
        feed[formattedDate] = {'message': msg};
      }

      // Update the document with the new feed
      await FirebaseFirestore.instance
          .collection('Feed')
          .doc(doc.id)
          .update({'Feed': feed});

      // Refresh the UI by calling getdata() to update the cards list
      await getdata();
    } else {
      // Handle the case where no document was found
      print('No document found for the given criteria.');
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  TextEditingController msg = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Myinput(
                      label: "Add message",
                      type: TextInputType.text,
                      obscure: false,
                      mycontrol: msg,
                      preficon: Icon(Icons.mail),
                      suficon: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'docx',
                                  'pdf',
                                  'png',
                                  'jpeg'
                                ],
                              );
                              if (result != null) {
                                PlatformFile? pickedFile = result.files.first;
                                File file = File(pickedFile.path!);
                                final path = 'files/${pickedFile.name}';
                                filepath = pickedFile.name;
                                final ref =
                                    FirebaseStorage.instance.ref().child(path);
                                await ref.putFile(file);
                                url = await ref.getDownloadURL();
                              }
                              setState(() {}); // Refresh the UI
                            },
                            child: Icon(
                              Icons.attach_file,
                              color: widget.color,
                            ),
                          ),
                          if (url != null)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  '1',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (url != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    url = null;
                                    filepath = null;
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
                    ElevatedButton(
                      onPressed: () {
                        String message = msg.text;
                        addMessage(message, filepath, url);
                        msg.clear();
                        setState(() {
                          url = null;
                          filepath = null;
                        });
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 30, vertical: 3)),
                        elevation: WidgetStateProperty.all(5),
                      ),
                      child: Text('Send'),
                    ),
                  ],
                ),
              ),
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
        : Center(child: CircularProgressIndicator());
  }
}

class Notes extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  final color;
  const Notes(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass,
      required this.color});
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List<String> grades1 = [];
  List<String> grades2 = [];
  List<String> finale = [];
  bool status = false;
  bool isDataLoaded = false;
  List<QueryDocumentSnapshot> tab = [];

  void getData() async {
    final classes = FirebaseFirestore.instance
        .collection('etudiant_module')
        .where('idclass', isEqualTo: widget.idclass)
        .where('idmodule', isEqualTo: widget.idmodule);
    QuerySnapshot query = await classes.get();
    setState(() {
      tab.clear();
      tab.addAll(query.docs);
      isDataLoaded = true;
      grades1 = List<String>.filled(tab.length, '', growable: true);
      grades2 = List<String>.filled(tab.length, '', growable: true);
      finale = List<String>.filled(tab.length, '', growable: true);
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  void updateNote1(String note, String id, String idmod) async {
    await FirebaseFirestore.instance
        .collection('etudiant_module')
        .doc("${id}_${idmod}")
        .update({"note1": double.tryParse(note) ?? 0.0});
  }

  void updateNote2(String note, String id, String idmod) async {
    await FirebaseFirestore.instance
        .collection('etudiant_module')
        .doc("${id}_${idmod}")
        .update({"note2": double.tryParse(note) ?? 0.0});
  }

  void updatefinal(String note, String id, String idmod) async {
    await FirebaseFirestore.instance
        .collection('etudiant_module')
        .doc("${id}_${idmod}")
        .update({"final": double.tryParse(note) ?? 0.0});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            status = !status;
          });

          if (!status) {
            if (myFormKey.currentState!.validate()) {
              myFormKey.currentState!.save();
              for (int i = 0; i < tab.length; i++) {
                if (grades1[i].isNotEmpty) {
                  updateNote1(
                      grades1[i], tab[i]['idetudiant'], tab[i]['idmodule']);
                }
                if (grades2[i].isNotEmpty) {
                  updateNote2(
                      grades2[i], tab[i]['idetudiant'], tab[i]['idmodule']);
                }
                if (finale[i].isNotEmpty) {
                  updatefinal(
                      finale[i], tab[i]['idetudiant'], tab[i]['idmodule']);
                }
              }
              getData();
            }
          }
        },
        child: Row(children: const [Icon(Icons.add), Text("Note")]),
      ),
      body: isDataLoaded
          ? SingleChildScrollView(
              child: Form(
                key: myFormKey,
                child: Table(
                  border: TableBorder.all(
                    color: Colors.white,
                    width: 2.0,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      children: const [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Text('Students')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Text('grade 1')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Text('grade 2')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: Text('final')),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < tab.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: i % 2 == 0
                              ? brightenColor(widget.color, 0.5)
                              : Colors.grey[200],
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 5),
                              child: Text(tab[i]['idetudiant']),
                            ),
                          ),
                          TableCell(
                            child: status == false
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                        child:
                                            Text(tab[i]['note1'].toString())),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      maxLength:
                                          5, // Maximum length considering float values
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.grade),
                                      ),
                                      initialValue: tab[i]['note1'].toString(),
                                      onSaved: (value) {
                                        grades1[i] = value ?? '';
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter grade';
                                        }
                                        double? grade = double.tryParse(value);
                                        if (grade == null ||
                                            grade < 0 ||
                                            grade > 20) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.rightSlide,
                                            title: 'invalide grade',
                                            desc:
                                                'Grade must be between 0 and 20',
                                            btnOkOnPress: () {},
                                          ).show();
                                          return 'Grade must be between 0 and 20';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                          ),
                          TableCell(
                            child: status == false
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                        child:
                                            Text(tab[i]['note2'].toString())),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      maxLength:
                                          5, // Maximum length considering float values
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      decoration: InputDecoration(
                                        counterText: "",
                                        suffixIcon: Icon(Icons.grade),
                                        border: InputBorder.none,
                                      ),
                                      initialValue: tab[i]['note2'].toString(),
                                      onSaved: (value) {
                                        grades2[i] = value ?? '';
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter grade';
                                        }
                                        double? grade = double.tryParse(value);
                                        if (grade == null ||
                                            grade < 0 ||
                                            grade > 20) {
                                          return 'Grade must be between 0 and 20';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                          ),
                          TableCell(
                            child: status == false
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                        child:
                                            Text(tab[i]['final'].toString())),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      maxLength:
                                          5, // Maximum length considering float values
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      decoration: InputDecoration(
                                        counterText: "",
                                        suffixIcon: Icon(Icons.grade),
                                        border: InputBorder.none,
                                      ),
                                      initialValue: tab[i]['final'].toString(),
                                      onSaved: (value) {
                                        finale[i] = value ?? '';
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter grade';
                                        }
                                        double? grade = double.tryParse(value);
                                        if (grade == null ||
                                            grade < 0 ||
                                            grade > 20) {
                                          return 'Grade must be between 0 and 20';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            )
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator while data is being fetched
    );
  }
}

class Assignment extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  final color;
  const Assignment(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass,
      required this.color});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController link = TextEditingController();
  bool showLinkField = false;
  bool showAttachField = false;
  String? selectedFilePath;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Add more extensions if needed
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
        final path =
            'assignments/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           
        },
        child: Icon(Icons.book),
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
