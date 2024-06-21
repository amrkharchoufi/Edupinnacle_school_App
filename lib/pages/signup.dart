// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Future<void> signUp(
      String email, String CNE, String role, String name) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: CNE,
      );

      // Get the current user's UID
      String uid = userCredential.user!.uid;

      // Store additional user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'ID': CNE,
        'etat': 'non-inscrit'
        // Add more fields as needed
      });
      Navigator.of(context).pushReplacementNamed("/inscrihome");
    } on FirebaseAuthException catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Erreur',
        desc: e.message,
        btnOkOnPress: () {},
      ).show();
    }
  }

  GlobalKey<FormState> myform = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController cne = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: myform,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  child: Image.asset("assets/images/signup_top.png"),
                  top: 0,
                  left: 0,
                ),
                Positioned(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text("Preinscription",
                            style: TextStyle(
                                fontFamily: "myfont",
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        SvgPicture.asset(
                          "assets/icons/signup.svg",
                          height: 300,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        MyinputS(
                          label: "Name",
                          preficon: Icon(
                            Icons.person,
                            color: Colors.purple,
                          ),
                          obscure: false,
                          mycontrol: name, type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyinputS(
                          label: "CNE",
                          preficon: Icon(
                            Icons.view_comfortable_outlined,
                            color: Colors.purple,
                          ),
                          obscure: false,
                          mycontrol: cne, type: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyinputS(
                          label: "Email",
                          preficon: Icon(
                            Icons.mail,
                            color: Colors.purple,
                          ),
                          obscure: false,
                          mycontrol: email, type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: ElevatedButton(
                            onPressed: () {
                              if (myform.currentState!.validate()) {
                                signUp(email.text, cne.text, "etudiant",
                                    name.text);
                              }
                            },
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "myfont",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.purple),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(vertical: 7),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an Account ? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
