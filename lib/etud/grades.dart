// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Grades extends StatefulWidget {
  const Grades({super.key});

  State<Grades> createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  bool isLoaded = false;
  List<QueryDocumentSnapshot> data = [];
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('etudiant_module')
        .where('idetudiant', isEqualTo: id)
        .get();
    setState(() {
      data.addAll(query.docs);
      isLoaded = true;
    });
  }

  Color primaryColor = AppColors.primaryColor;
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

      isLoaded = true;
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
    getdata();
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grades",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: isLoaded  
      ? Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: data.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "There's no Marks for the moments study hard !",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      "assets/images/not found.png",
                      height: 500,
                    )
                  ],
                )
              : Table(
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
                      decoration: BoxDecoration(color: Colors.grey[200],borderRadius:BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20), )),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(child: Text('Subject')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(child: Text('Grade 1')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(child: Text('Grade 2')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(child: Text('final')),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < data.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: i % 2 == 0
                              ?  brightenColor(primaryColor, 0.5)
                              : Colors.grey[200],
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(data[i]['idmodule']),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                  child: Text(data[i]['note1'].toString())),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35,top: 20),
                              child: Text(data[i]['note2'].toString()),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35,top: 20),
                              child: Text(data[i]['final'].toString()),
                            ),
                          ),
                        ],
                      ),
                  ],
                ))
                : Center(
              child:
                  CircularProgressIndicator()), 
      backgroundColor: primaryColor,
    );
  }
}
