import 'package:edupinacle/etud/accountcard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
        actions: [
          MaterialButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/homepage');
            },
            elevation: 10,
            child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white),
                child: const Text(
                  "Sign out",
                  style: TextStyle(color: Colors.purpleAccent),
                )),
          )
        ]
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: 185,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 164, 45, 185),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/images/stident.jpeg"),
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Wiame Hamrane",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "myfont",
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Class : A0102 || ID : 20004962",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "myfont",
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: AccountCard(name: "Wiame", className: "className", studentID: "studentID", imageURL: "assets/images/stident.jpeg")
          )
        ],
      ),
    );
  }
}