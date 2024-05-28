// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> myform = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obb = true;
  void hidden() {
    setState(() {
      obb = !obb;
    });
  }
  // Future<bool> etatver() async {
  //   String? uid = FirebaseAuth.instance.currentUser?.uid;
  //   DocumentSnapshot data =
  //       await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   String? status = (data.data() as Map<String, dynamic>?)?['etat'];
  //   if (status == 'non-inscrit') {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: myform,
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  child: Image.asset("assets/images/main_top.png"),
                  top: -50,
                  left: -50,
                ),
                Positioned(
                  child: Image.asset("assets/images/login_bottom.png"),
                  bottom: 0,
                  right: 0,
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
                        Text("Login",
                            style: TextStyle(
                                fontFamily: "myfont",
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 40,
                        ),
                        SvgPicture.asset("assets/icons/login.svg"),
                        SizedBox(
                          height: 40,
                        ),
                        Myinput(
                          label: "Email",
                          preficon: Icon(
                            Icons.mail,
                            color: Colors.purple,
                          ),
                          obscure: false,
                          mycontrol: email,
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Myinput(
                          label: "Password",
                          preficon: Icon(
                            Icons.lock,
                            color: Colors.purple,
                          ),
                          suficon: GestureDetector(
                            child: Icon(Icons.visibility, color: Colors.purple),
                            onTap: () => hidden(),
                          ),
                          obscure: obb,
                          mycontrol: password,
                          type: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (myform.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email.text.trim(),
                                          password: password.text.trim());
                                  String? uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  DocumentSnapshot data =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .get();
                                  Map<String, dynamic> role =
                                      data.data() as Map<String, dynamic>;
                                  if (role['role'] == "etudiant") {
                                    if (role['etat'] == 'non-inscrit') {
                                      Navigator.of(context)
                                          .pushReplacementNamed("/inscrihome");
                                    } else {
                                      const Center(
                                          child: CircularProgressIndicator());
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              "/Etudianthome");
                                    }
                                  } else if (role['role'] == "Prof") {
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .pushReplacementNamed("/profhome");
                                  } else if (role['role'] == "admin") {
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .pushReplacementNamed("/staffhome");
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'User not Found',
                                      desc: 'No user found for that email.',
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else if (e.code == 'wrong-password') {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Wrong Password',
                                      desc:
                                          'Wrong password provided for that user.',
                                      btnOkOnPress: () {},
                                    ).show();
                                  }
                                }
                              }
                            },
                            child: Text(
                              "LOGIN",
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
