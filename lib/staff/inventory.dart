import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/staff/administration/class/classdetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String? _selectedValue = 'all';
  final List<String> _dropdownItems = ['all', 'Salle', 'datashow', 'amphie'];
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;

  void getdata() async {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/resourceadd');
          if (result == true) {
            getdata();
          }},
        child: FaIcon(FontAwesomeIcons.plus)
      ),
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
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
          SizedBox(height: 20),
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
                        Ressourcecard(
                          id: data[i]['ID'],
                          delete: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: 'Delete Ressource',
                              desc:
                                  'Are you sure you want to delete this Ressource?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('inventory')
                                      .doc(data[i].id)
                                      .delete();
                                  getdata();
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success',
                                    desc: 'Ressource successfully deleted.',
                                    btnOkOnPress: () {
                                      // Optionally, you can also call Refresh() here
                                      // Refresh();
                                    },
                                  ).show();
                                } catch (e) {
                                  print('Error deleting document: $e');
                                }
                              },
                            ).show();
                          },
                          manage: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Classdetail(id: data[i]['ID']),
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
