import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/prof/accountcard.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SFAccount extends StatefulWidget {
  const SFAccount({super.key});
  State<SFAccount> createState() => _SFAccountState();
}

class _SFAccountState extends State<SFAccount> {
  Map<String, dynamic> data = {};
  Map<String, dynamic> data2 = {};
  bool isLoading = true;
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    String id = minidata.get('ID');
    DocumentSnapshot admin =
        await FirebaseFirestore.instance.collection('Admin').doc(id).get();
    setState(() {
      data2=minidata.data() as Map<String, dynamic>;
      data = admin.data() as Map<String, dynamic>;
      isLoading = false; // Move the setState here
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor:  AppColors.primaryColor,
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
                child:  Text(
                  "Sign out",
                  style: TextStyle(color:  AppColors.primaryColor),
                )),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 185,
                    decoration:  BoxDecoration(
                      color:  AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              AssetImage("assets/images/stident.jpeg"),
                        ),
                        SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${data['nom']}  ${data['prenom']}",
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
                              "ID : ${data['cin']}",
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
                 Expanded(
                  flex: 3,
                  child: STAccountCard(email: data2['email'], telephone: data['telephone'], date: data['date naisance'], adress: data['adresse'], cin: data['cin'],),
                )
              ],
            ),
    );
  }
}
