import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Classcard extends StatelessWidget {
  final String name;
  final int numberetu;
  final int maxnumber;
  final Function? delete;
  final Function? manage;
  const Classcard(
      {super.key,
      required this.name,
      required this.delete,
      required this.manage,
      required this.numberetu,
      required this.maxnumber,
      });
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
                        const FaIcon(FontAwesomeIcons.school),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          name,
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
                      "nombre d'etudiant : $numberetu",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "max number : $maxnumber",
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: manage != null ? () => manage!() : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration:  BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(5)),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    MaterialButton(
                      onPressed: delete != null ? () => delete!() : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration:  BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(5)),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
