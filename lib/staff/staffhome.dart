import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Staffhome extends StatefulWidget {
  const Staffhome({Key? key});
  State<Staffhome> createState() => _StaffhomeState();
}

class _StaffhomeState extends State<Staffhome> {
  static List<Map<String, dynamic>> tab = [
    {'icon': Icons.inventory, 'name': 'Inventory', 'route': '/Inventory'},
    {
      'icon': Icons.app_registration,
      'name': 'Registration',
      'route': '/Registration'
    },
    {'icon': Icons.payment, 'name': 'Facture', 'route': '/Facture'},
    {'icon': Icons.school_rounded, 'name': 'Administration', 'route': '/Admin'},
    {'icon': Icons.settings, 'name': 'App Panel', 'route': '/Settings'},
    {'icon': Icons.message, 'name': 'Chat', 'route': '/stfmessagerie'},
    {'icon': Icons.person, 'name': 'Account', 'route': '/stfaccount'},
  ];

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = true;
  Map<String, dynamic> data = {};
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    DocumentSnapshot admin =
        await FirebaseFirestore.instance.collection('Admin').doc(id).get();
    setState(() {
      data = admin.data() as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
    _startTimer(); // Start the timer when the widget is initialized
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
    
      isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Hi Admin",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "myfont",
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${data['nom']} ${data['prenom']}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "myfont",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 1,
                                      ),
                                      child: Text(
                                        "2023-2024",
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontFamily: "myfont",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 45,
                                backgroundImage:
                                    AssetImage("assets/images/stident.jpeg"),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 40,
                          runSpacing: 20,
                          children: [
                            for (int i = 0; i < tab.length; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, tab[i]['route']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 140,
                                  height: 125,
                                  child: Column(
                                    children: [
                                      Icon(
                                        tab[i]['icon'],
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        tab[i]['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
