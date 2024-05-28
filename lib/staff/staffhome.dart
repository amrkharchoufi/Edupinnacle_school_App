import 'package:flutter/material.dart';

class Staffhome extends StatelessWidget {
  static List<Map<String, dynamic>> tab = [
    {'icon': Icons.inventory, 'name': 'Inventory', 'route': '/Inventory'},
    {'icon': Icons.app_registration, 'name': 'Registration', 'route': '/Registration'},
    {'icon': Icons.payment, 'name': 'Facture', 'route': '/Facture'},
    {'icon': Icons.school_rounded, 'name': 'Administration', 'route': '/Admin'},
    {'icon': Icons.settings, 'name': 'App Panel', 'route': '/Settings'},
    {'icon': Icons.message, 'name': 'Chat', 'route': '/stfmessagerie'},
    {'icon': Icons.person, 'name': 'Account', 'route': '/stfaccount'},
  ];

  const Staffhome({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 83, 80, 80),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Hi Admin",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "myfont",
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Fatima Zahra Ziani",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "myfont",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 1,
                                ),
                                child: Text(
                                  "2023-2024",
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontFamily: "myfont",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage("assets/images/stident.jpeg"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 40,
                  runSpacing: 20,
                  children: [
                    for (int i = 0; i < tab.length; i++) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, tab[i]['route']);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 83, 80, 80),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 140,
                          height: 125,
                          child: Column(
                            children: [
                              Icon(
                                tab[i]['icon'],
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 15),
                              Text(
                                tab[i]['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
