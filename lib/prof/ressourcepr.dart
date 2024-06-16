import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/prof/ressdetpr.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PRressource extends StatefulWidget {
  const PRressource({super.key});

  @override
  State<PRressource> createState() => _PRressourceState();
}

class _PRressourceState extends State<PRressource> {
  String? _selectedValue = 'all';
  final List<String> _dropdownItems = ['all', 'Salle', 'datashow', 'amphie'];
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  String id = "";
  void getdata() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot minidata =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
     id = minidata.get('ID');
    final classes;
    if (_selectedValue != 'all') {
      classes = FirebaseFirestore.instance
          .collection('inventory')
          .where('type', isEqualTo: _selectedValue);
    } else {
      classes = FirebaseFirestore.instance.collection('inventory');
    }
    QuerySnapshot query = await classes.get();
    setState(() {
      data.clear();
      data.addAll(query.docs);
      isDataLoaded = true;
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
        title: Text(
          'Ressource',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Ressource type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 25),
              DropdownButton<String>(
                dropdownColor: Colors.purple[50],
                borderRadius: BorderRadius.all(Radius.circular(30)),
                hint: Text('Select a type'),
                value: _selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                    isDataLoaded = false;
                    getdata();
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
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (!isDataLoaded)
                      const Center(child: CircularProgressIndicator())
                    else if (data.isEmpty)
                      const Center(
                          child: Text(
                        "No Resources found!",
                        style: TextStyle(fontSize: 17),
                      ))
                    else
                      for (int i = 0; i < data.length; i++)
                        RessourcePRcard(
                          id: data[i]['ID'],
                          manage: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PRRessourcedet(id: data[i]['ID'],idprof:id),
                              ),
                            );
                          },
                        ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
