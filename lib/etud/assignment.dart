// import 'package:flutter/cupertino.dart';
import 'package:edupinacle/mywidgets/asscar.dart';
import 'package:flutter/material.dart';

class Asignment extends StatelessWidget {
  const Asignment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Assignment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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
        child: const SingleChildScrollView(
          child: Column(
            children: [
              Assigncard(
                module: "math",
                Title: "Algebra",
                dateass: "17/05/2024",
                lastdate: "27/05/2024",
                status: "Not Submitted",
              ),
              Assigncard(
                module: "math",
                Title: "Algebra",
                dateass: "17/05/2024",
                lastdate: "27/05/2024",
                status: "Not Submitted",
              ),
              Assigncard(
                module: "math",
                Title: "Algebra",
                dateass: "17/05/2024",
                lastdate: "27/05/2024",
                status: "Not Submitted",
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
    );
  }
}