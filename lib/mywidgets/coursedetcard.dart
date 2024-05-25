// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Coursedetcard extends StatelessWidget {
  final String prof;
  final String message;
  final String date;
  const Coursedetcard({
    super.key,
    required this.message,
    required this.prof,
    required this.date,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 244, 218, 248),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.purple, width: 2), // Top border
                bottom:
                    BorderSide(color: Colors.purple, width: 2), // Bottom border
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                prof,
                                style: TextStyle(
                                  color: Colors.grey[900], // Text color
                                  fontSize: 16.0, // Font size
                                  fontWeight: FontWeight.bold, // Text weight
                                ),
                              ),
                              Text(
                                date,
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
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        message,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: "myfont",
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ])),
          )),
    );
  }
}
