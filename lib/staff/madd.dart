import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Moduleadd extends StatefulWidget {
  const Moduleadd({super.key});
  @override
  State<Moduleadd> createState() => _ModuleaddState();
}

Future<bool> checkDocumentExists(String documentId) async {
  // Get a reference to the document
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('module').doc(documentId);

  // Get the document
  DocumentSnapshot docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    return true;
    // Document exists, you can access its data using docSnapshot.data()
  } else {
    return false;
  }
}

class _ModuleaddState extends State<Moduleadd> {
  TextEditingController number = TextEditingController();
  TextEditingController id = TextEditingController();
  GlobalKey<FormState> k = GlobalKey();
  void Addclass(String id, int num) async {
    Map<String, List<Map<String, String>>> schedule = {};
    bool exist = await checkDocumentExists(id);
    if (!exist) {
      await FirebaseFirestore.instance
          .collection('module')
          .doc(id)
          .set({'ID': id, 'coefficient': num});
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Subject added with success !',
        btnOkOnPress: () {
          Navigator.pop(context, true);
        },
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'ERROR',
        desc: 'Subject already exist',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administration",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
      ),
      body: Form(
        key: k,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add Module",
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 80,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Module Title :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Myinput(
                        label: 'Set Title',
                        type: TextInputType.text,
                        obscure: false,
                        mycontrol: id),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Coefficient  :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Myinput(
                        label: 'Set Number',
                        type: TextInputType.number,
                        obscure: false,
                        mycontrol: number)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (k.currentState!.validate()) {
                        Addclass(id.text, int.parse((number.text)));
                        id.clear();
                        number.clear();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text("ADD"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
