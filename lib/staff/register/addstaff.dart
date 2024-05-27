import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaddStf extends StatefulWidget {
  const MaddStf({super.key});

  @override
  State<MaddStf> createState() => _MaddStfState();
}

class _MaddStfState extends State<MaddStf> {
  GlobalKey<FormState> myform = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController cin = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  Future<void> inscription(String nom, String prenom, String cin, String date,
      String phone, String adresse, String email, String pwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );

      // Get the current user's UID
      String uid = userCredential.user!.uid;

      // Store additional user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'role': 'admin',
        'ID': cin,
      });
      DocumentSnapshot data =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String prid = data.get('ID');
      await FirebaseFirestore.instance.collection('Admin').doc(prid).set({
        'nom': nom,
        'prenom': prenom,
        'cin': cin,
        'date naisance': date,
        'adresse': adresse,
        'telephone': phone,
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'etat': 'inscrit',
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Registration done',
        desc: 'User added with succes !',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Erreur',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: myform,
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset("assets/images/signup_top.png"),
              ),
              Positioned(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text("INSCRIPTION",
                                style: TextStyle(
                                    fontFamily: "myfont",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Myinput(
                              label: "Name",
                              preficon: const Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: name,
                              type: TextInputType.name,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Family name",
                              preficon: const Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),
                              type: TextInputType.name,
                              obscure: false,
                              mycontrol: prenom,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "email",
                              preficon: const Icon(
                                Icons.mail,
                                color: Colors.purple,
                              ),
                              type: TextInputType.emailAddress,
                              obscure: false,
                              mycontrol: email,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Password",
                              preficon: const Icon(
                                Icons.lock,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: pwd,
                              type: TextInputType.text,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "CIN",
                              preficon: const Icon(
                                Icons.view_comfortable_outlined,
                                color: Colors.purple,
                              ),
                              type: TextInputType.text,
                              obscure: false,
                              mycontrol: cin,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Birth Date",
                              preficon: const Icon(
                                Icons.calendar_month,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: date,
                              type: TextInputType.datetime,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Adresse",
                              preficon: const Icon(
                                Icons.home,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: adresse,
                              type: TextInputType.text,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Phone number",
                              preficon: const Icon(
                                Icons.phone,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: telephone,
                              type: TextInputType.phone,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 280,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (myform.currentState!.validate()) {
                                    inscription(
                                        name.text,
                                        prenom.text,
                                        cin.text,
                                        date.text,
                                        telephone.text,
                                        adresse.text,
                                        email.text,
                                        pwd.text);
                                    name.clear();
                                    prenom.clear();
                                    date.clear();
                                    telephone.clear();
                                    adresse.clear();
                                    email.clear();
                                    pwd.clear();
                                    cin.clear();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.purple),
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 7),
                                  ),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "myfont",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
