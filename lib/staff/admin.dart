import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/calsscard.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/staff/classdetail.dart';
import 'package:flutter/material.dart';

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
    const Gemploi(),
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
            icon: Icon(Icons.school),
            label: 'Classroom',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.class_,
              size: 30,
            ),
            label: 'Subjects',
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
                const Text("No Classes found")
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
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Gemploi extends StatefulWidget {
  const Gemploi({super.key});
  @override
  State<Gemploi> createState() => _GemploiState();
}

class _GemploiState extends State<Gemploi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
