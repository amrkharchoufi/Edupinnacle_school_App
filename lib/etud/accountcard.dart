import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String className;
  final String studentID;
  final String date;
  final String email;
  final String fname;
  final String fcin;
  final String address;
  final String phone;

  const AccountCard({
    super.key,
    required this.className,
    required this.studentID,
    required this.date,
    required this.email,
    required this.fname,
    required this.fcin, required this.address, required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 160,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Class",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 167, 164, 164)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      className,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.lock_outline)
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 80,
                          width: 160,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Code Apogee",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 167, 164, 164)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      studentID,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.lock_outline)
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 80,
                          width: 160,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Father Name",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 167, 164, 164)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      fname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.lock_outline)
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 160,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Academic Year",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 167, 164, 164)),
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "2023-2024",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.lock_outline)
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 80,
                          width: 160,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date of Birth",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 167, 164, 164)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.lock_outline)
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 80,
                          width: 160,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Father's CIN",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 167, 164, 164)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      fcin,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.lock_outline)
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Father's Phone Number",
                          style: TextStyle(
                              color: Color.fromARGB(255, 167, 164, 164)),
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              phone,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.lock_outline)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 300,
                          height: 1,
                          color: Colors.grey,
                        )
                      ]),
                ),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Adresse",
                          style: TextStyle(
                              color: Color.fromARGB(255, 167, 164, 164)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              address,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.lock_outline)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 300,
                          height: 1,
                          color: Colors.grey,
                        )
                      ]),
                ),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              color: Color.fromARGB(255, 167, 164, 164)),
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              email,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.lock_outline)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 300,
                          height: 1,
                          color: Colors.grey,
                        )
                      ]),
                ),
              ],
            )),
      ),
    );
  }
}
