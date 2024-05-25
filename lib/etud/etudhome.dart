import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Etudhome extends StatefulWidget {
  const Etudhome({super.key});
  @override
  State<Etudhome> createState() => _EtudhomeState();
}

class _EtudhomeState extends State<Etudhome> {
  static List<Map<String, dynamic>> tab = [
    {'icon': Icons.event, 'name': 'Planning', 'route': '/etPlanning'},
    {'icon': Icons.checklist, 'name': 'Grades', 'route': '/etGrades'},
    {'icon': Icons.school, 'name': 'Courses', 'route': '/etCourses'},
    {'icon': Icons.assignment, 'name': 'Assignment', 'route': '/etAssignment'},
    {'icon': Icons.person, 'name': 'Account', 'route': '/etAccount'},
    {'icon': Icons.message, 'name': 'Chat', 'route': '/etmessagerie'},
  ];

  DocumentSnapshot? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot data1 =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    String etu = data1.get('ID');
    DocumentSnapshot data2 =
        await FirebaseFirestore.instance.collection('etudiant').doc(etu).get();
    setState(() {
      data = data2;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Hi",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "myfont",
                                                  fontSize: 17)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            data?.get('nom') ?? '',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "myfont",
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                       Text(
                                         'Class:A01   || ID : ${data?.get('cne') ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "myfont",
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 1),
                                        child: Text("2023-2024",
                                            style: TextStyle(
                                              color: Colors.grey[900],
                                              fontFamily: "myfont",
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                const CircleAvatar(
                                  radius: 45,
                                  backgroundImage:
                                      AssetImage("assets/images/stident.jpeg"),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 100,
                                  child: const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Attendance",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "90.02%",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 30),
                                      )
                                    ],
                                  ),
                                )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 100,
                                  child: const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Assignment",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "5",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 30),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Container(
                        padding: const EdgeInsets.only(top: 40),
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 40,
                          runSpacing: 20,
                          children: [
                            for (int i = 0; i < 6; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, tab[i]['route']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 140,
                                  height: 125,
                                  child: Column(
                                    children: [
                                      Icon(
                                        tab[i]['icon'],
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        tab[i]['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
