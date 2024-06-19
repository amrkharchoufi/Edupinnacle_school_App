import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';

class Coursedetcard extends StatefulWidget {
  final String prof;
  final String message;
  final String date;
  final Widget delete;
  final Widget file;
  const Coursedetcard({
    super.key,
    required this.message,
    required this.prof,
    required this.date,
    required this.delete,
    required this.file,
  });
  State<Coursedetcard> createState() => _Coursedetcard();
}

class _Coursedetcard extends State<Coursedetcard> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      print("Timer triggered. Refreshing colors...");
      _initializeColors();
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

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: brightenColor(primaryColor, 0.5),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: primaryColor, width: 2), // Top border
                bottom:
                    BorderSide(color: primaryColor, width: 2), // Bottom border
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage("assets/images/stident.jpeg"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.prof,
                                    style: TextStyle(
                                      color: Colors.grey[900], // Text color
                                      fontSize: 16.0, // Font size
                                      fontWeight:
                                          FontWeight.bold, // Text weight
                                    ),
                                  ),
                                  Text(
                                    widget.date,
                                    style: TextStyle(
                                      color: Colors.grey[900], // Text color
                                      fontSize: 12.0, // Font size
                                      // Text weight
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          widget.delete
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.message,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: "myfont",
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.file
                    ])),
          )),
    );
  }
}

class Coursedetcard1 extends StatefulWidget {
  final String prof;
  final String message;
  final String date;
  final Widget file;
  const Coursedetcard1({
    super.key,
    required this.message,
    required this.prof,
    required this.date,
    required this.file,
  });
  State<Coursedetcard1> createState() => _Coursedetcard1();
}

class _Coursedetcard1 extends State<Coursedetcard1> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _initializeColors();
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

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  var nom = '';
  void getdata() async {
    DocumentSnapshot admin = await FirebaseFirestore.instance
        .collection('Professeur')
        .doc(widget.prof)
        .get();
    setState(() {
      nom = "${admin.get('nom')} ${admin.get('prenom')}";
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
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: brightenColor(primaryColor, 0.5),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: primaryColor, width: 2), // Top border
                bottom:
                    BorderSide(color: primaryColor, width: 2), // Bottom border
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage("assets/images/stident.jpeg"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nom,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  color: Colors.grey[900], // Text color
                                  fontSize: 12.0, // Font size
                                  // Text weight
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.message,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: "myfont",
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.file
                    ])),
          )),
    );
  }
}
