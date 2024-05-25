// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Assigncard extends StatelessWidget {
  final String module;
  final String dateass;
  final String lastdate;
  final String status;
  final String Title;
  const Assigncard({
    super.key,
    required this.module,
    required this.Title,
    required this.dateass,
    required this.lastdate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: const Color.fromARGB(255, 244, 218, 248),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.purple, // Border color
          width: 1, // Border width
        ),),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                decoration: BoxDecoration(
                  boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                  ],
                    color: const Color.fromARGB(255, 241, 164, 255),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  module,
                  style: const TextStyle(color: Colors.purple,fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(Title,style: const TextStyle(
                color: Colors.purple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "myfont1"
              ),),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assign Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Last Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Status"),
                      ]),
                  Column(children: [
                    Text(dateass),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(lastdate),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(status),
                  ])
                ],
              ),
              const SizedBox(height: 20),
              if (status == "Not Submitted")
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.purple),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                    child: const Text(
                      "To be Submitted",
                      style: TextStyle(color: Colors.white,fontSize: 17),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
