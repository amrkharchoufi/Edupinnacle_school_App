import 'package:edupinacle/prof/courscard.dart';
import 'package:edupinacle/prof/coursesdet.dart';
import 'package:flutter/material.dart';

class PRCourses extends StatelessWidget {
  static List<Map<String, String>> tab = [
    {'module': 'Math', 'submodule': 'Algebre 2', 'classroom': 'class A02'},
    {'module': 'Physic', 'submodule': 'Optique', 'classroom': 'class A02'},
    {'module': 'Computer Science','submodule': 'PHP & DB','classroom': 'class A02'},
    {'module': 'Math', 'submodule': 'Analyse 2', 'classroom': 'class A02'},
    {'module': 'Physic', 'submodule': 'Electronique', 'classroom': 'class A02'},
    {'module': 'SVT', 'submodule': 'Geologie', 'classroom': 'class A02'},
  ];
  const PRCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (tab.isNotEmpty)
                for (var item in tab) ...[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PRCoursesdet(
                              submodule: item['submodule'] ?? "default Module",
                            ),
                          ),
                        );
                      },
                      child: PRCoursecard(
                        module: item['module'] ?? "Default Module",
                        title: item['submodule'] ?? "Default Title",
                        classroom: item['classroom'] ?? "Default Class",
                      )),
                ]
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
    );
  }
}
