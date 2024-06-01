import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/etudiantcard.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Classdetail extends StatefulWidget {
  final String id;
  const Classdetail({super.key, required this.id});

  @override
  State<Classdetail> createState() => _ClassdetailState();
}

class _ClassdetailState extends State<Classdetail> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      Students(
        id: widget.id,
      ),
      Stdadd(
        id: widget.id,
      ),
      Gemploi(
        id: widget.id,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 30,
            ),
            label: 'emploie',
          ),
        ],
      ),
    );
  }
}

class Students extends StatefulWidget {
  final String id;
  const Students({
    super.key,
    required this.id,
  });

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final student = FirebaseFirestore.instance.collection('etudiant');
    QuerySnapshot query =
        await student.where("class", isEqualTo: widget.id).get();

    setState(() {
      data.clear();
      data.addAll(query.docs);
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Students :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Text("Class empty")
              else
                for (int i = 0; i < data.length; i++)
                  Reg1card(
                    id: data[i]['cne'],
                    nom: data[i]['nom'],
                    prenom: data[i]['prenom'],
                    delete: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Remove student',
                        desc: 'Are you sure you want to remove this student?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('etudiant')
                                .doc(data[i]['cne'])
                                .update({'class': ''});
                            getdata();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'Class successfully deleted.',
                              btnOkOnPress: () {},
                            ).show();
                          } catch (e) {
                            print('Error deleting document: $e');
                          }
                        },
                      ).show();
                    }, // Adjust as necessary
                    manage: () {}, // Adjust as necessary
                  ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Stdadd extends StatefulWidget {
  final String id;
  const Stdadd({
    super.key,
    required this.id,
  });
  @override
  State<Stdadd> createState() => _StdaddState();
}

class _StdaddState extends State<Stdadd> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final student = FirebaseFirestore.instance.collection('etudiant');
    QuerySnapshot query = await student.where("class", isEqualTo: '').get();

    setState(() {
      data.clear();
      data.addAll(query.docs);
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Students :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(child: Text("No students found !"))
              else
                for (int i = 0; i < data.length; i++)
                  Reg2card(
                    id: data[i]['cne'],
                    nom: data[i]['nom'],
                    prenom: data[i]['prenom'],
                    add: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('etudiant')
                            .doc(data[i].id)
                            .update({'class': widget.id});
                        QuerySnapshot query = await FirebaseFirestore.instance
                            .collection('class_module')
                            .where('IDclass', isEqualTo: widget.id)
                            .get();
                        WriteBatch batch = FirebaseFirestore.instance.batch();
                        for (var doc in query.docs) {
                          Map<String, dynamic> idmodule =
                              doc.data() as Map<String, dynamic>;
                          Map<String, dynamic> newModuleData = {
                            'idetudiant': data[i].id,
                            'idmodule': idmodule['IDmodule'],
                            'note1': 0,
                            'note2': 0,
                            'final': 0,
                          };
                          DocumentReference newDocRef = FirebaseFirestore
                              .instance
                              .collection('etudiant_module')
                              .doc('${data[i].id}_${idmodule['IDmodule']}');
                          batch.set(newDocRef, newModuleData);
                        }
                        await batch.commit();
                        getdata();
                      } catch (e) {
                        print('Error adding student : $e');
                      }
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'student added to the class with succes !',
                              btnOkOnPress: () {})
                          .show();
                    }, // Adjust as necessary
                    manage: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Classdetail(id: data[i]['ID'])));
                    }, // Adjust as necessary
                  ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Gemploi extends StatefulWidget {
  final String id;
  const Gemploi({super.key, required this.id});

  @override
  State<Gemploi> createState() => _GemploiState();
}

class _GemploiState extends State<Gemploi> {
  Map<String, List<Map<String, String>>> schedule = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
  };

  final Map<String, TextEditingController> _startTimeControllers = {};
  final Map<String, TextEditingController> _endTimeControllers = {};
  final Map<String, TextEditingController> _activityControllers = {};
  bool _isLoading = true;

  final List<String> _dayOrder = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('schedule')
          .doc(widget.id)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, List<Map<String, String>>> fetchedSchedule = {};
        data['schedule'].forEach((day, timeSlots) {
          List<Map<String, String>> slots = [];
          for (var slot in timeSlots) {
            slots.add({
              'startTime': slot['startTime'],
              'endTime': slot['endTime'],
              'activity': slot['activity'],
            });
          }
          fetchedSchedule[day] = slots;
        });
        setState(() {
          schedule = fetchedSchedule;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addTimeSlot(String day) async {
    String startTime = _startTimeControllers[day]!.text;
    String endTime = _endTimeControllers[day]!.text;
    String activity = _activityControllers[day]!.text;

    if (startTime.isNotEmpty && endTime.isNotEmpty && activity.isNotEmpty) {
      setState(() {
        schedule[day]!.add({
          'startTime': startTime,
          'endTime': endTime,
          'activity': activity,
        });
      });
      _startTimeControllers[day]!.clear();
      _endTimeControllers[day]!.clear();
      _activityControllers[day]!.clear();
      await FirebaseFirestore.instance
          .collection('schedule')
          .doc(widget.id)
          .update({'schedule': schedule});
    }
  }

  Future<void> deleteTimeSlot(String day, int index) async {
    setState(() {
      schedule[day]!.removeAt(index);
    });
    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(widget.id)
        .update({'schedule': schedule});
  }

  @override
  void dispose() {
    _startTimeControllers.values.forEach((controller) => controller.dispose());
    _endTimeControllers.values.forEach((controller) => controller.dispose());
    _activityControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: _dayOrder.length,
                itemBuilder: (context, index) {
                  String day = _dayOrder[index];

                  _startTimeControllers[day] ??= TextEditingController();
                  _endTimeControllers[day] ??= TextEditingController();
                  _activityControllers[day] ??= TextEditingController();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: schedule[day]?.length ?? 0,
                        itemBuilder: (context, idx) {
                          Map<String, String> timeSlot = schedule[day]![idx];
                          return ListTile(
                            title: Text(
                                '${timeSlot['startTime']} - ${timeSlot['endTime']}'),
                            subtitle: Text(timeSlot['activity']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteTimeSlot(day, idx),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _startTimeControllers[day],
                                decoration: const InputDecoration(
                                    labelText: 'Start Time'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _endTimeControllers[day],
                                decoration: const InputDecoration(
                                    labelText: 'End Time'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _activityControllers[day],
                                decoration: const InputDecoration(
                                    labelText: 'Activity'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => addTimeSlot(day),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
