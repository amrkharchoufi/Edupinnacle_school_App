import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Coursecard extends StatefulWidget {
  final String module;
  final String prof;
  final String title;
  final  Color couleur;
  const Coursecard({
    super.key,
    required this.module,
    required this.title,
    required this.prof, required this.couleur,
  });

  State<Coursecard> createState() => _CoursecardState();
}

class _CoursecardState extends State<Coursecard> {
  var nom = '';
  void getdata() async {
    DocumentSnapshot admin = await FirebaseFirestore.instance
        .collection('Professeur')
        .doc(widget.prof)
        .get();
    setState(() {
      nom = "${admin.get('nom')} ${admin.get('prenom')}";
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }
  Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: brightenColor(widget.couleur,0.5) ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side:  BorderSide(
              color: widget.couleur, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 4),
                      decoration: BoxDecoration(
                        color: brightenColor(widget.couleur,0.4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: Text(
                        widget.module,
                        style:
                             TextStyle(color: widget.couleur, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.title,
                      style:  TextStyle(
                          color: widget.couleur,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont1"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Professor $nom',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 34, 34, 34), // Text color
                        fontSize: 16.0, // Font size
                        fontWeight: FontWeight.bold, // Text weight
                      ),
                    )
                  ]))),
    );
  }
}
