import 'package:edupinacle/mywidgets/coursedetcard.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatelessWidget {
  static String message = "demain il n'y aura pas de cours ,Cordialement";
  final String submodule;
  final String teacher;
  const CourseDetail({super.key, 
    required this.submodule,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          submodule,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Coursedetcard1(message: message, prof: teacher,date: "15 may"),
          ],
        ),
      ),
    );
  }
}
