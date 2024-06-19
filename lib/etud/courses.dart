import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/etud/coursedetail.dart';
import 'package:edupinacle/mywidgets/courscard.dart';
import 'package:edupinacle/mywidgets/notfound.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  bool isDataLoaded = false;
  static List<QueryDocumentSnapshot> tab = [];
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    DocumentSnapshot admin =
        await FirebaseFirestore.instance.collection('etudiant').doc(id).get();
    String room = admin.get('class');
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('class_module')
        .where('IDclass', isEqualTo: room)
        .get();
    setState(() {
      tab.clear();
      tab.addAll(query.docs);
      isDataLoaded = true;
    });
  }

  Color primaryColor = AppColors.primaryColor;
  @override
  void initState() {
    getdata();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      print("Timer triggered. Refreshing colors...");
      _initializeColors();
    });
  }

  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isDataLoaded = true;
    });
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
        backgroundColor: primaryColor,
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
                  ? SingleChildScrollView(
                      child: Column(children: [
                        for (int i = 0; i < tab.length; i++)
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseDetail(
                                      idmodule: tab[i]['IDmodule'],
                                      idclass: tab[i]['IDclass'],
                                      idprof: tab[i]['IDprof'],
                                      color: primaryColor,
                                    ),
                                  ),
                                );
                              },
                              child: Coursecard(
                                module: tab[i]['IDmodule'],
                                title: tab[i]['IDmodule'],
                                prof: tab[i]['IDprof'], couleur: primaryColor,
                              )),
                      ]),
                    )
                  : Notfound(text: 'No Courses Found'))
          : const Center(child: CircularProgressIndicator()),
      backgroundColor: primaryColor,
    );
  }
}
