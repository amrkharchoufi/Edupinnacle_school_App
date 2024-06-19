import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/card.dart';
import 'package:flutter/material.dart';

class Detassign extends StatefulWidget {
  final String idmodule;
  final String idclass;
  final Color couleur;
  const Detassign({super.key, required this.idmodule, required this.idclass, required this.couleur});

  @override
  State<Detassign> createState() => _DetassignState();
}

class _DetassignState extends State<Detassign> {
   List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
void getdata() async {
    final classes = FirebaseFirestore.instance
        .collection('etudiant_assign')
        .where('idclass', isEqualTo: widget.idclass)
        .where('idmodule', isEqualTo: widget.idmodule);
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
        title: Text(widget.idmodule,style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: widget.couleur,
      ),
      body:  SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assignement :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              if (!isDataLoaded)
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(
                    child: Text(
                  "No Assignement found !",
                  style: TextStyle(fontSize: 17),
                ))
              else
                for (int i = 0; i < 4; i++)
                  acard(id: '', link: '',),
                  
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
