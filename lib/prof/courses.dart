import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/notfound.dart';
import 'package:edupinacle/prof/courscard.dart';
import 'package:edupinacle/prof/coursesdet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PRCourses extends StatefulWidget {
  const PRCourses({super.key});

  State<PRCourses> createState() => _PRCoursesState();
}

class _PRCoursesState extends State<PRCourses> {
  bool isDataLoaded = false;
  static List<QueryDocumentSnapshot> tab = [];
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot prof =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = prof.get('ID');
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('class_module')
        .where('IDprof', isEqualTo: id)
        .get();
    setState(() {
      tab.clear();
      tab.addAll(query.docs);
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
      appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: isDataLoaded
       ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        margin: const EdgeInsets.only(top: 20),
        child: tab.isNotEmpty 
        ?SingleChildScrollView(
          child: Column(
            children: [
                for (int i = 0; i < tab.length; i++)
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PRCoursesdet(
                              idmodule: tab[i]['IDmodule'] ,
                              idclass: tab[i]['IDclass'] ,
                              idprof: tab[i]['IDprof'] 
                            ),
                          ),
                        );
                      },
                      child: PRCoursecard(
                        module: tab[i]['IDmodule'],
                        title: tab[i]['IDmodule'],
                        classroom: tab[i]['IDclass'],
                      )),
                ]
          ),
        )
        :Notfound(text: 'No Courses Found')
      )
      : const Center(child: CircularProgressIndicator()),
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
    );
  }
}
