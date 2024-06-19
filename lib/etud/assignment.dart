// import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/asscar.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Asignment extends StatefulWidget {
  const Asignment({super.key});

  State<Asignment> createState() => _AsignmentState();
}

class _AsignmentState extends State<Asignment> {
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> data2 = [];
  bool isDataLoaded = false;
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    DocumentSnapshot admin =
        await FirebaseFirestore.instance.collection('etudiant').doc(id).get();
    final classes = FirebaseFirestore.instance
        .collection('Assignement')
        .where('idclass', isEqualTo: admin.get('class'));
    QuerySnapshot query = await classes.get();
    final assign = FirebaseFirestore.instance
        .collection('etudiant_assign')
        .where('idetudiant', isEqualTo: id)
        .where('idclass', isEqualTo: admin.get('class'));
    QuerySnapshot query1 = await assign.get();
    setState(() {
      data.clear();
      data.addAll(query.docs);
      data2.addAll(query1.docs);
      isDataLoaded = true;
    });
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _initializeColors();
    });
  }

  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assignement",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assignement :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              if (!isDataLoaded)
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(
                    child: Text(
                  "No Assignement found !",
                  style: TextStyle(fontSize: 17),
                ))
              else
                for (int i = 0; i < data.length; i++)
                  Assign2card(
                    module: data[i]['idmodule'],
                    Title: data[i]['title'],
                    dateass: data[i]['createdAt'].toString(),
                    lastdate: data[i]['duedate'].toString(),
                    link: data[i]['link'],
                    filename: data[i]['filename'],
                    fileurl: data[i]['fileUrl'],
                    status: data2[i]['status'],
                    idoc: data2[i].id, // Adjust as necessary
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
