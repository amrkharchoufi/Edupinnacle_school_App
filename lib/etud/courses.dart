
import 'package:edupinacle/etud/coursedetail.dart';
import 'package:edupinacle/mywidgets/courscard.dart';
import 'package:flutter/material.dart';

class Courses extends StatelessWidget {
  static List<Map<String, String>> tab = [
    {'module': 'Math', 'submodule': 'Algebre 2', 'Prof': 'Amr kharchoufi'},
    {
      'module': 'Physic',
      'submodule': 'Optique',
      'Prof': 'Oussama Mohamed Reda'
    },
    {
      'module': 'Computer Science',
      'submodule': 'PHP & DB',
      'Prof': 'Rachid hamrane'
    },
    {'module': 'Math', 'submodule': 'Analyse 2', 'Prof': 'Fatima Zahra Ziani'},
    {'module': 'Physic', 'submodule': 'Electronique', 'Prof': 'Ouafae Kabou'},
    {'module': 'SVT', 'submodule': 'Geologie', 'Prof': 'Zakaria Ichtarir'},
  ];
  const Courses({super.key});

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
                              builder: (context) => CourseDetail(
                                  submodule:
                                      item['submodule'] ?? "default Module",
                                  teacher:
                                  item['Prof'] ?? "default Module"),
                                      ),
                        );
                      },
                      child: Coursecard(
                          module: item['module'] ?? "Default Module",
                          title: item['submodule'] ?? "Default Module",
                          prof: item['Prof'] ?? "Default Prof")),
                ]
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
    );
  }
}
