// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/staff/register/addprof.dart';
import 'package:edupinacle/staff/register/addstaff.dart';
import 'package:edupinacle/staff/register/addstd.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Manage(),
    Madd(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            label: 'Add',
          ),
        ],
      ),
    );
  }
}

class Manage extends StatefulWidget {
  const Manage({super.key});
  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot query =
        await users.where("role", isEqualTo: "etudiant").get();

    setState(() {
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registered Users :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                Text("No registered users found")
              else
                for (int i = 0; i < data.length; i++)
                  Regcard(
                    name: data[i]['ID'],
                    delete: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'delete user',
                        desc: 'you sure you want to delet the user ?',
                        btnOkOnPress: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('your_collection')
                                .doc(data[i]['ID'])
                                .delete();
                            Navigator.pop(context);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Succes',
                              desc: 'User successfully deleted.',
                              btnOkOnPress: () {},
                            ).show();
                          } catch (e) {
                            print('Error deleting document: $e');
                          }
                        },
                      ).show();
                    }, // Adjust as necessary
                    manage: () {
                      
                    }, // Adjust as necessary
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class Madd extends StatefulWidget {
  const Madd({super.key});
  @override
  State<Madd> createState() => _MaddState();
}

class _MaddState extends State<Madd> {
  Widget selectedUserType = MaddStd();
  void _selectUserType(Widget userType) {
    setState(() {
      selectedUserType = userType;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 83, 80, 80),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 83, 80, 80),
              ),
              child: Text(
                'Select User Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Student'),
              onTap: () => _selectUserType(MaddStd()),
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Admin'),
              onTap: () => _selectUserType(MaddStf()),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Professor'),
              onTap: () => _selectUserType(MaddPrf()),
            ),
          ],
        ),
      ),
      body: selectedUserType,
    );
  }
}
