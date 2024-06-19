import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaddStd extends StatefulWidget {
  const MaddStd({super.key});
  @override
  State<MaddStd> createState() => _MaddStdState();
}

class _MaddStdState extends State<MaddStd> {
  GlobalKey<FormState> myform = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController cin = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController fcin = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  Future<void> inscription(
      String nom,
      String prenom,
      String date,
      String phone,
      String adresse,
      String fname,
      String fcin,
      String email,
      String pwd) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? uid1 = currentUser!.uid;

      DocumentSnapshot adminSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid1).get();
      String adminEmail = adminSnapshot.get('email');
      String adminPassword = adminSnapshot.get('pwd');

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
        'role': 'etudiant',
        'ID': pwd,
        'etat': 'inscrit'
        // Add more fields as needed
      });
      DocumentSnapshot data =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String stdid = data.get('ID');
      await FirebaseFirestore.instance.collection('etudiant').doc(stdid).set({
        'nom': nom,
        'prenom': prenom,
        'cne': stdid,
        'date naisance': date,
        'adresse': adresse,
        'nom pere': fname,
        'cin  pere': fcin,
        'num pere': phone,
        'class': '',
        // Add more fields as needed
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'etat': 'inscrit',
      });
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );
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
                              label: "CNE",
                              preficon: const Icon(
                                Icons.view_comfortable_outlined,
                                color: Colors.purple,
                              ),
                              type: TextInputType.text,
                              obscure: false,
                              mycontrol: pwd,
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
                              type: TextInputType.streetAddress,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Father's Name",
                              preficon: const Icon(
                                Icons.person_4_sharp,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: fname,
                              type: TextInputType.name,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Father's CIN",
                              preficon: const Icon(
                                Icons.view_comfortable_outlined,
                                color: Colors.purple,
                              ),
                              obscure: false,
                              mycontrol: fcin,
                              type: TextInputType.text,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Myinput(
                              label: "Father's Phone number",
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
                                        date.text,
                                        telephone.text,
                                        adresse.text,
                                        fname.text,
                                        fcin.text,
                                        email.text,
                                        pwd.text);
                                    name.clear();
                                    prenom.clear();
                                    date.clear();
                                    telephone.clear();
                                    adresse.clear();
                                    fname.clear();
                                    fcin.clear();
                                    email.clear();
                                    pwd.clear();
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
