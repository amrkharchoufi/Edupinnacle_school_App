import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Resadd extends StatefulWidget {
  const Resadd({super.key});
  @override
  State<Resadd> createState() => _ResaddState();
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

class _ResaddState extends State<Resadd> {
  String? _selectedValue;
  final List<String> _dropdownItems = ['Salle', 'datashow', 'amphie'];
  TextEditingController id = TextEditingController();
  GlobalKey<FormState> k = GlobalKey();
  void Addclass(String id, String type) async {
    Map<String, List<Map<String, String>>> schedule = {};
    bool exist = await checkDocumentExists(id);
    if (!exist) {
      await FirebaseFirestore.instance
          .collection('inventory')
          .doc(id)
          .set({'ID': id, 'type': type});
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Ressource added with success !',
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
        desc: 'Resource already exist',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inventory",
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
                  "Add Ressource",
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
                      "Ressource ID :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Myinput(
                        label: 'Set ID',
                        type: TextInputType.text,
                        obscure: false,
                        mycontrol: id),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Ressource type  :",
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(
                  height: 00,
                ),
                SizedBox(
                  width: 280,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    focusColor: Colors.purple[50],
                    dropdownColor: Colors.purple[50],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    hint: Text('Select a type'),
                    value: _selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                    items: _dropdownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (k.currentState!.validate()) {
                        Addclass(id.text, _selectedValue!);
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
