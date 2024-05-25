// ignore_for_file: prefer_const_constructors

import 'package:edupinacle/mywidgets/coursedetcard.dart';
import 'package:flutter/material.dart';

class PRCoursesdet extends StatefulWidget {
  final String submodule;
  const PRCoursesdet({super.key, required this.submodule});

  @override
  State<PRCoursesdet> createState() => _PRCoursesState();
}

class _PRCoursesState extends State<PRCoursesdet> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Feed(),
    Notes(),
    Assignment(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String submodule = widget.submodule;
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
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String prof = "Moi";
  String date = "25 may";
  List<String> messages = [];
  List<Coursedetcard> cards = [];
  final TextEditingController _text = TextEditingController();
  void addMessage(String m) {
    messages.add(m);
  }

  void addItem() {
    setState(() {
      cards.insert(
          0,
          Coursedetcard(
              message: messages[cards.length % messages.length],
              prof: prof,
              date: date));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      suffixIcon: Icon(
                        Icons.attach_file,
                        color: Colors.purple[400],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String message = _text.text;
                  if (message.isNotEmpty) {
                    addMessage(message);
                    _text.clear();
                    addItem();
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
        Expanded(
          child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return cards[index];
            },
          ),
        ),
      ],
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Map<String, String>> tab = [
    {'student': 'Ahmed', 'grade1': '10', 'grade2': '11'},
    {'student': 'wiame', 'grade1': '20', 'grade2': '8'},
    {'student': 'Lina', 'grade1': '14', 'grade2': '20'},
    {'student': 'amr', 'grade1': '17', 'grade2': '20'},
    {'student': 'jaafar', 'grade1': '5', 'grade2': '16'},
  ];
  GlobalKey<FormState> myfrom = GlobalKey();
  List<String> grades1 = ['', '', '', '', ''];
  List<String> grades2 = ['', '', '', '', ''];
  bool status = false;
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
        child: Row(children:const [
            Icon(Icons.add),
          Text("Note")
          ]),
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
  const Assignment({super.key});
  @override
  State<Assignment> createState() => _AssignmentState();
}
class _AssignmentState extends State<Assignment>{
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
              Text("Add Assignement",
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
              ),
              SizedBox(height: 80,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assignement Title :",
                  style: TextStyle(
                color: Colors.grey[900],
                fontSize: 15,
                fontWeight: FontWeight.w700
              ),
              ),
                  SizedBox(height:10),
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
                  SizedBox(height: 10,),
                  Text("Due to  :",
                  style: TextStyle(
                color: Colors.grey[900],
                fontSize: 15,
                fontWeight: FontWeight.w700
              ),
              ),
                  SizedBox(height:10),
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
                      SizedBox(height: 10,),
                      Text("Assignement Link :",
                  style: TextStyle(
                color: Colors.grey[900],
                fontSize: 15,
                fontWeight: FontWeight.w700
              ),
              ),
                  SizedBox(height:10),
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
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, child: Padding(
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
