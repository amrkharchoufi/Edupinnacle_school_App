import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/cont1.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static List<Map<String, String>> tab = [
    {
      "title": "Event",
      "description": "Participer au compétition d'échecs",
      "img": "assets/images/aff3.jpeg"
    },
    {
      "title": "Inscription",
      "description": "Incrivez vous au annee scolaire 2023/2024",
      "img": "assets/images/affiche1.png"
    },
    {
      "title": "Formation",
      "description": "Formation au develepment ai",
      "img": "assets/images/affiche2.png"
    }
  ];
  User? home;
  String path = '/';
  @override
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _initializeColors();
    });
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      setState(() {
        home = user;
      });

      if (user == null) {
        setState(() {
          path = '/welcome';
        });
      } else {
        DocumentSnapshot data = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData = data.data() as Map<String, dynamic>?;
        String role = userData?['role'] ?? '';

        setState(() {
          if (role == "etudiant") {
            path = '/Etudianthome';
          } else if (role == "Prof") {
            path = '/profhome';
          } else if (role == "admin") {
            path = '/staffhome';
          }
        });
      }
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 60,
        ),
        actions: [
          home == null
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/welcome");
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child:  Text(
                      "sign in",
                      style: TextStyle(
                          color: primaryColor,
                          fontFamily: "myfont",
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, path);
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(7),
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(
                        width: 17,
                      )
                    ],
                  ),
                ),
        ],
        centerTitle: true,
        backgroundColor:  primaryColor,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 216, 216, 216),
                      width: 5)),
              child: Image.asset("assets/images/EDU.png"),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                width: double.infinity,
                decoration:  BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nouveauté :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: "myfont",
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            if (tab.isNotEmpty)
                              for (var item in tab) ...[
                                Cont1(
                                  title: item['title'] ?? "",
                                  description: item['description'] ?? "",
                                  imagePath: item['img'] ?? "",
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ]
                          ],
                        )),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
