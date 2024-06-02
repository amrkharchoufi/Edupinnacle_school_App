// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:edupinacle/mywidgets/PdfAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/coursedetcard.dart';
import 'package:edupinacle/mywidgets/notfound.dart';
import 'package:edupinacle/mywidgets/pdfpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    _pages = [
      Feed(
        idmodule: widget.idmodule,
        idprof: widget.idprof,
        idclass: widget.idclass,
      ),
      Notes(
        idmodule: widget.idmodule,
        idprof: widget.idprof,
        idclass: widget.idclass,
      ),
      Assignment(
        idmodule: widget.idmodule,
        idprof: widget.idprof,
        idclass: widget.idclass,
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
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 164, 45, 185),
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
  const Feed(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass});

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
  void delete(String timestamp, String msg, String filepath) async {
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
      await FirebaseStorage.instance.ref().child(filepath).delete();

      getdata();
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
                    )),
                  ),
            delete: MaterialButton(
                onPressed: () {
                  delete(date, message, fileurl);
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            // Add file parameter if needed in your Coursedetcard class
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
      isLoaded = true; // Add new cards to the list
    });
  }

  void addMessage(String msg, String path, var url) async {
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
      feed[formattedDate] = {'message': msg, 'file': path, 'url': url};

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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Colors.purple[50],
                        ),
                        child: TextField(
                          controller: _text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add message :",
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.purple[400],
                            ),
                            suffixIcon: Stack(
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
                                      PlatformFile? pickedFile =
                                          result.files.first;
                                      File file = File(pickedFile.path!);
                                      final path = 'files/${pickedFile.name}';
                                      filepath = pickedFile.name;
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child(path);
                                      ref.putFile(file);
                                      setState(() {
                                        url = path;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.attach_file,
                                    color: Colors.purple[400],
                                  ),
                                ),
                                if (url !=
                                    null) // Display the indicator if a file is chosen
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
                                        '1', // Display any number or indicator you like
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                if (url !=
                                    null) // Display cancel button if a file is chosen
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          url =
                                              null; // Reset the url to cancel the selection
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
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String message = _text.text;
                        if (message.isNotEmpty) {
                          addMessage(message, filepath!, url);
                          _text.clear();
                          setState(() {
                                          url =
                                              null; // Reset the url to cancel the selection
                                        });
                        }
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
              :Text('No Messages yet !',style: TextStyle(fontSize: 17),)
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class Notes extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  const Notes(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass});
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Map<String, String>> tab = [];
  GlobalKey<FormState> myfrom = GlobalKey();
  List<String> grades1 = ['', '', '', '', ''];
  List<String> grades2 = ['', '', '', '', ''];
  bool status = false;
void getdata()async{
  

}







 @override
  void initState() {
    
    super.initState();
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            status = !status;
            myfrom.currentState!.validate();
            myfrom.currentState!.save();
            for (int i = 0; i < tab.length; i++) {
              if (grades1[i].isNotEmpty) {
                tab[i]['grade1'] = grades1[i];
              }
              if (grades2[i].isNotEmpty) {
                tab[i]['grade2'] = grades2[i];
              }
            }
          });
        },
        child: Row(children: const [Icon(Icons.add), Text("Note")]),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: myfrom,
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
                      child: Center(child: Text('grade1')),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text('grade2')),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < tab.length; i++)
                TableRow(
                  decoration: BoxDecoration(
                    color: i % 2 == 0
                        ? const Color.fromARGB(255, 234, 183, 243)
                        : Colors.grey[200],
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(tab[i]['student']!),
                      ),
                    ),
                    TableCell(
                      child: status == false
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(child: Text(tab[i]['grade1']!)),
                            )
                          : TextFormField(
                              maxLines: 1,
                              maxLength: 2,
                              textCapitalization: TextCapitalization.characters,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.grade)),
                              initialValue: tab[i]['grade1'],
                              onSaved: (value) {
                                setState(() {
                                  grades1[i] = value!;
                                });
                              },
                            ),
                    ),
                    TableCell(
                      child: status == false
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(child: Text(tab[i]['grade2']!)),
                            )
                          : TextFormField(
                              maxLines: 1,
                              maxLength: 2,
                              textCapitalization: TextCapitalization.characters,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                counterText: "",
                                suffixIcon: Icon(Icons.grade),
                                border: InputBorder.none,
                              ),
                              initialValue: tab[i]['grade2'],
                              onSaved: (value) {
                                setState(() {
                                  grades2[i] = value!;
                                });
                              },
                            ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Assignment extends StatefulWidget {
  final idmodule;
  final idprof;
  final idclass;
  const Assignment(
      {super.key,
      required this.idmodule,
      required this.idprof,
      required this.idclass});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
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
                "Add Assignement",
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 80,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assignement Title :",
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.purple[50],
                    ),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Title :",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Due to  :",
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.purple[50],
                    ),
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Set Date :",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Assignement Link :",
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.purple[50],
                    ),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Link :",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Text("ADD"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
