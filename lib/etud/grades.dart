// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Grades extends StatelessWidget {
  static List<Map<String, dynamic>> grades = [
    {'subject': 'Math', 'grade': 'A', 'teacher': 'Mr. Smith'},
    {'subject': 'Science', 'grade': 'B', 'teacher': 'Ms. Johnson'},
    {'subject': 'History', 'grade': 'C', 'teacher': 'Mr. Brown'},
    {'subject': 'English', 'grade': 'A', 'teacher': 'Ms. Davis'},
    {'subject': 'Art', 'grade': 'A', 'teacher': 'Ms. White'},
  ];
  const Grades({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grades",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 30),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: grades.isEmpty
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
                      decoration: BoxDecoration(color: Colors.grey[200]),
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
                            child: Center(child: Text('Grade')),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(child: Text('Teacher')),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < grades.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: i % 2 == 0
                              ? const Color.fromARGB(255, 234, 183, 243)
                              : Colors.grey[200],
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(grades[i]['subject']),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(child: Text(grades[i]['grade'])),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(grades[i]['teacher']),
                            ),
                          ),
                        ],
                      ),
                  ],
                )),
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
    );
  }
}
