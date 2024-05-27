import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/etudiantcard.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Moduledet extends StatefulWidget {
  final String id;
  const Moduledet({super.key, required this.id});

  @override
  State<Moduledet> createState() => _ModuledetState();
}

class _ModuledetState extends State<Moduledet> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      EnrolClass(
        id: widget.id,
      ),
      Moduleclass(
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
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            label: 'Add',
          ),
        ],
      ),
    );
  }
}

class EnrolClass extends StatefulWidget {
  final String id;
  const EnrolClass({
    super.key,
    required this.id,
  });

  @override
  State<EnrolClass> createState() => _EnrolClassState();
}

class _EnrolClassState extends State<EnrolClass> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final student = FirebaseFirestore.instance.collection('class_module');
    QuerySnapshot query =
        await student.where("IDmodule", isEqualTo: widget.id).get();

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
                "Classes :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(
                    child: Text(
                  "this subject have no classes in it !",
                  style: TextStyle(fontSize: 17),
                ))
              else
                for (int i = 0; i < data.length; i++)
                  Reg3card(
                    id: data[i]['IDclass'],
                    idprof: data[i]['IDprof'],
                    delete: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Remove class',
                        desc: 'Are you sure you want to remove this class?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('class_module')
                                .doc(data[i].id)
                                .delete();
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

class Moduleclass extends StatefulWidget {
  final String id;
  const Moduleclass({
    super.key,
    required this.id,
  });
  @override
  State<Moduleclass> createState() => _ModuleclassState();
}

class _ModuleclassState extends State<Moduleclass> {
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> predata = [];
  List<QueryDocumentSnapshot> allclassdata = [];
  List<QueryDocumentSnapshot> moduleclassdata = [];
  bool isDataLoaded = false;
  void getdata() async {
    QuerySnapshot allclass =
        await FirebaseFirestore.instance.collection('class').get();
    QuerySnapshot moduleclass =
        await FirebaseFirestore.instance.collection('class_module').get();
    allclassdata.addAll(allclass.docs);
    moduleclassdata.addAll(moduleclass.docs);
    List<String> moduleclassIDs =
        moduleclassdata.map((doc) => doc['IDclass'] as String).toList();

    predata = allclassdata
        .where((doc) => !moduleclassIDs.contains(doc['ID']))
        .toList();
    setState(() {
      data.clear();
      data.addAll(predata);
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  TextEditingController id = TextEditingController();

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
                "Available classes :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(
                    child: Text(
                  "No class found",
                  style: TextStyle(fontSize: 17),
                ))
              else
                for (int i = 0; i < data.length; i++)
                  Classmoduleaddcard(
                    id: data[i]['ID'],
                    add: () {
                      AwesomeDialog(
                          context: context,
                          body: Column(
                            children: [
                              const Text('Add teacher for this subject'),
                              const SizedBox(
                                height: 10,
                              ),
                              Myinput(
                                label: 'Add Teacher\'s CIN ',
                                obscure: false,
                                type: TextInputType.name,
                                mycontrol: id,
                              ),
                            ],
                          ),
                          dialogType: DialogType.infoReverse,
                          animType: AnimType.rightSlide,
                          btnOkOnPress: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('class_module')
                                  .doc('${data[i].id}_${widget.id}')
                                  .set({
                                'IDclass': data[i]['ID'],
                                'IDmodule': widget.id,
                                'IDprof': id.text
                              });
                              getdata();
                            } catch (e) {
                              print('Error adding student : $e');
                            }
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success',
                                    desc: 'Class added with success !',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {})
                                .show();
                          }).show();
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
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
