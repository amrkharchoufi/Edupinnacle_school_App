import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profhome extends StatefulWidget {
  const Profhome({Key? key}) : super(key: key);
  State<Profhome> createState() => _ProfhomeState();
}

class _ProfhomeState extends State<Profhome> {
  static List<Map<String, dynamic>> tab = [
    {'icon': Icons.event, 'name': 'Planning', 'route': '/prPlanning'},
    {'icon': Icons.school, 'name': 'Courses', 'route': '/prCourses'},
    {'icon': Icons.person, 'name': 'Account', 'route': '/praccount'},
    {'icon': Icons.message, 'name': 'Chat', 'route': '/prmessagerie'},
  ];

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Map<String, dynamic> data = {};
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    DocumentSnapshot admin =
        await FirebaseFirestore.instance.collection('Professeur').doc(id).get();
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
    
      isLoaded = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    return isLoaded 
    ?Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Column(
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
                              const Text(
                                "Hi Professeur",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "myfont",
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 5),
                               Text(
                                "${data['nom']} ${data['prenom']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "myfont",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: const EdgeInsets.symmetric(
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Attendance",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "90.02%",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Messages",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "5",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
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
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                tab[i]['name'],
                                style: const TextStyle(
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
        ],
      ),
    )
    : Scaffold(body: const Center(child: CircularProgressIndicator()));
  }
}
