import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/calsscard.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/staff/administration/class/classdetail.dart';
import 'package:edupinacle/staff/administration/module/moduledet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Administration extends StatefulWidget {
  const Administration({super.key});
  @override
  State<Administration> createState() => _AdminState();
}

class _AdminState extends State<Administration> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Gclass(),
    const Gmodule(),

  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administration",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.school),
            label: 'Classroom',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.class_,
              size: 30,
            ),
            label: 'Subjects',
          ),
        ],
      ),
    );
  }
}

class Gclass extends StatefulWidget {
  const Gclass({super.key});
  @override
  State<Gclass> createState() => _GclassState();
}

class _GclassState extends State<Gclass> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final classes = FirebaseFirestore.instance.collection('class');
    QuerySnapshot query = await classes.get();

    setState(() {
      data.clear(); // Clear the existing data before adding new data
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/classadd');
          if (result == true) {
            getdata();
          }
        },
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Classes :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(child: Text("No Classes found !",style: TextStyle(fontSize: 17),))
              else
                for (int i = 0; i < data.length; i++)
                  Classcard(
                    numberetu: data[i]['nbretudiant'],
                    maxnumber: data[i]['maxetu'],
                    name: data[i]['ID'],
                    delete: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Delete Class',
                        desc: 'Are you sure you want to delete this class?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('class')
                                .doc(data[i].id)
                                .delete();
                            getdata();
                            await FirebaseFirestore.instance
                                .collection('schedule')
                                .doc(data[i].id)
                                .delete();
                            QuerySnapshot query = await FirebaseFirestore
                                .instance
                                .collection('etudiant')
                                .where('class', isEqualTo: data[i].id)
                                .get();
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();
                            // Update each student's class field to an empty string
                            for (var doc in query.docs) {
                              batch.update(doc.reference, {'class': ''});
                            }
                            // Commit the batch
                            await batch.commit();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'Class successfully deleted.',
                              btnOkOnPress: () {
                                // Optionally, you can also call Refresh() here
                                // Refresh();
                              },
                            ).show();
                          } catch (e) {
                            print('Error deleting document: $e');
                          }
                        },
                      ).show();
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
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Gmodule extends StatefulWidget {
  const Gmodule({super.key});
  @override
  State<Gmodule> createState() => _GmoduleState();
}

class _GmoduleState extends State<Gmodule> {
    List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final classes = FirebaseFirestore.instance.collection('module');
    QuerySnapshot query = await classes.get();

    setState(() {
      data.clear(); // Clear the existing data before adding new data
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/moduleadd');
          if (result == true) {
            getdata();
          }
        },
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Subjects :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(child: Text("No Subjects found",style: TextStyle(fontSize: 17),))
              else
                for (int i = 0; i < data.length; i++)
                  Mcard(
                    id: data[i]['ID'],
                    delete: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Delete Subject',
                        desc: 'Are you sure you want to delete this Subject?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('module')
                                .doc(data[i].id)
                                .delete();
                            getdata();
                            QuerySnapshot query = await FirebaseFirestore
                                .instance
                                .collection('etudiant')
                                .where('class', isEqualTo: data[i].id)
                                .get();
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();
                            // Update each student's class field to an empty string
                            for (var doc in query.docs) {
                              batch.update(doc.reference, {'class': ''});
                            }
                            // Commit the batch
                            await batch.commit();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'Subject successfully deleted.',
                              btnOkOnPress: () {
                                // Optionally, you can also call Refresh() here
                                // Refresh();
                              },
                            ).show();
                          } catch (e) {
                            print('Error deleting document: $e');
                          }
                        },
                      ).show();
                    }, // Adjust as necessary
                    manage: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Moduledet(id: data[i]['ID'])));
                    }, // Adjust as necessary
                  ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

