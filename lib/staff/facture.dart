import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/mywidgets/calsscard.dart';
import 'package:edupinacle/mywidgets/registercard.dart';
import 'package:edupinacle/staff/administration/class/classdetail.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';

class Facturisation extends StatefulWidget {
  const Facturisation({super.key});
  @override
  State<Facturisation> createState() => _FacturisationState();
}

class _FacturisationState extends State<Facturisation> {
  List<QueryDocumentSnapshot> data = [];
  bool isDataLoaded = false;
  void getdata() async {
    final classes = FirebaseFirestore.instance.collection('facture');
    QuerySnapshot query = await classes.get();

    setState(() {
      data.clear(); // Clear the existing data before adding new data
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
        title: Text("Facture",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/factureadd');
          if (result == true) {
            getdata();
          }
        },
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Invoice :",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              if (!isDataLoaded) // Display loading indicator if data is not loaded
                const CircularProgressIndicator()
              else if (data.isEmpty) // Display message only if data is empty
                const Center(
                    child: Text(
                  "No invoice found !",
                  style: TextStyle(fontSize: 17),
                ))
              else
                for (int i = 0; i < data.length; i++)
                  Facturecard(
                    title:data[i]['title'] ,
                    id: data[i]['id'],
                    total: "${data[i]['montant'].toString()} dh",
                    delete: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Delete invoice',
                        desc: 'Are you sure you want to delete this invoice?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('facture')
                                .doc(data[i].id)
                                .delete();
                            getdata();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'Class successfully deleted.',
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
                    }, // Adjust as necessary
                  ),
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