import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Inscription extends StatefulWidget {
  Inscription({super.key});
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  GlobalKey<FormState> myform = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController cin = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController fcin = TextEditingController();
  TextEditingController date = TextEditingController();
  Future<bool> etat() async {
    DocumentSnapshot ins =
        await FirebaseFirestore.instance.collection('App').doc('myapp').get();
    bool t = ins.get('inscription');
    return t;
  }

  var l;
  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    bool registrationOpen = await etat();
    setState(() {
      l = registrationOpen;
    });
  }

  Future<void> inscription(String nom, String prenom, String date, String phone,
      String adresse, String fname, String fcin) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
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
        'class' : ''
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'etat': 'inscrit',
      });

      Navigator.of(context).pushReplacementNamed("/Etudianthome");
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
                        Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            const Text("INSCRIPTION",
                                style: TextStyle(
                                    fontFamily: "myfont",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 20,
                            ),
                            SvgPicture.asset(
                              "assets/icons/signup.svg",
                              height: 300,
                            ),
                          ],
                        ),
                        l == true
                            ? Column(
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
                                              fcin.text);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.purple),
                                        foregroundColor:
                                            WidgetStateProperty.all(
                                                Colors.white),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 7),
                                        ),
                                      ),
                                      child: const Text(
                                        "Complete inscription",
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
                            : Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 50),
                                      padding: const EdgeInsets.all(7),
                                      child: const Text(
                                        "Registration for our school hasn't begun yet. We'll inform you as soon as enrollment opens ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'myfont',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    mouseCursor: SystemMouseCursors.click,
                                    child: const Text(
                                      "HomePage",
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      Navigator.pushReplacementNamed(
                                          context, '/homepage');
                                    },
                                  )
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
