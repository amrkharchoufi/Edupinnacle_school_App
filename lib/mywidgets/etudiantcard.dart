import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reg1card extends StatelessWidget {
  final String id;
  final Function? delete;
  final Function? manage;
  String? nom;
  String? prenom;
   Reg1card(
      {super.key,
      this.nom,
      this.prenom,
      required this.id,
      required this.delete,
      required this.manage});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.blueGrey, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.person),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          id,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "myfont1"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Text(
                      "nom : $nom",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "prenom : $prenom",
                      style: const TextStyle(color: Colors.white),
                    )
                  ]
                ),
                MaterialButton(
                  onPressed: delete != null ? () => delete!() : null,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
class Reg2card extends StatelessWidget {
  final String id;
  final Function? add;
  final Function? manage;
  String? nom;
  String? prenom;
   Reg2card(
      {super.key,
      this.nom,
      this.prenom,
      required this.id,
      required this.add,
      required this.manage});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.blueGrey, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.person),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          id,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "myfont1"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Text(
                      "nom : $nom",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "prenom : $prenom",
                      style: const TextStyle(color: Colors.white),
                    )
                  ]
                ),
                MaterialButton(
                  onPressed: add != null ? () => add!() : null,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,size: 50,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
class Classmoduleaddcard extends StatelessWidget {
  final String id;
  final Function? add;
  final Function? manage;
   Classmoduleaddcard(
      {super.key,
      required this.id,
      required this.add,
      required this.manage});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.blueGrey, // Border color
              width: 1, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.school),
                    const SizedBox(
                      width:10,
                    ),
                    Text(
                      id,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "myfont1"),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: add != null ? () => add!() : null,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,size: 50,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
