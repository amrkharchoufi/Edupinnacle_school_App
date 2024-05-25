// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:edupinacle/mywidgets/cont1.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  static List<Map<String, String>> tab = [
    {"title":"Title", "description":"description", "img":"assets/images/form.avif"}
  ];
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 60,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/welcome");
            },
            child: Container(
              child: Text(
                "sign in",
                style: TextStyle(
                    color: const Color.fromARGB(255, 164, 45, 185),
                    fontFamily: "myfont",
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: Image.asset("assets/images/EDU.png"),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 216, 216, 216), width: 5)),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 164, 45, 185),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nouveauté :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: "myfont",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            if (tab.isNotEmpty)
                            for(var item in tab) ...[
                              Cont1(
                                title: item['title']??"",
                                description: item['description']??"",
                                imagePath: item['img']??"",
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ]
                          ],
                        )),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
