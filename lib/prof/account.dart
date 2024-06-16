import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/prof/accountcard.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PRAccount extends StatefulWidget {
  const PRAccount({super.key});
  State<PRAccount> createState() => _PRAccountState();
}

class _PRAccountState extends State<PRAccount> {
  Map<String, dynamic> data = {};
  Map<String, dynamic> data2 = {};
  bool isLoaded = false;
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    DocumentSnapshot admin =
        await FirebaseFirestore.instance.collection('Professeur').doc(id).get();
    setState(() {
      data2 = minidata.data() as Map<String, dynamic>;
      data = admin.data() as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
    _startTimer();
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

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                "My Profile",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: primaryColor,
              actions: [
                MaterialButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, '/homepage');
                  },
                  elevation: 10,
                  child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white),
                      child: Text(
                        "Sign out",
                        style: TextStyle(color: primaryColor),
                      )),
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 185,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              AssetImage("assets/images/stident.jpeg"),
                        ),
                        SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${data['nom']} ${data['prenom']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "myfont",
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "ID : ${data['cin']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "myfont",
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                 Expanded(
                  flex: 3,
                  child: STAccountCard(telephone: data['telephone'], adress: data['adresse'], date: data['date naisance'], cin: data['cin'], email: data2['email'],),
                )
              ],
            ),
          )
        : Scaffold(body: const Center(child: CircularProgressIndicator()));
  }
}
