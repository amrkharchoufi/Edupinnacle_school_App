import 'package:flutter/material.dart';

class PRCoursecard extends StatelessWidget {
  final String module;
  final String title;
  final String classroom;
  const PRCoursecard({
    super.key,
    required this.module,
    required this.title,
    required this.classroom,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 244, 218, 248),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.purple, // Border color
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
                          color: const Color.fromARGB(255, 241, 164, 255),
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
                        module,
                        style:
                            const TextStyle(color: Colors.purple, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont1"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'class $classroom',
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
