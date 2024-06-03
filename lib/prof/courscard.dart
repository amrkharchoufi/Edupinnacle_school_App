import 'dart:async';

import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';
Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }

class PRCoursecard extends StatefulWidget {
  final String module;
  final String title;
  final String classroom;
  const PRCoursecard({
    super.key,
    required this.module,
    required this.title,
    required this.classroom,
  });
  State<PRCoursecard> createState() => _PRCoursecardState();
}

class _PRCoursecardState extends State<PRCoursecard> {
  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
void initState() {
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
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: brightenColor(primaryColor,0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side:  BorderSide(
              color: primaryColor, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 4),
                      decoration: BoxDecoration(
                        color: brightenColor(primaryColor,0.3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: Text(
                        widget.module,
                        style:
                             TextStyle(color: primaryColor, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.title,
                      style:  TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont1"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'class ${widget.classroom}',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 34, 34, 34),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont1"),
                    ),
                  ]))),
    );
  }
}
