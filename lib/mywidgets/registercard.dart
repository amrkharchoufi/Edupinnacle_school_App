
import 'package:flutter/material.dart';

class Regcard extends StatelessWidget {
  final String name;
  final Function? delete;
  final Function? manage;
  const Regcard({super.key, required this.name, required this.delete,required this.manage});
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
                    const Icon(Icons.person),
                    const SizedBox(
                      width: 5,
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
                Column(
                  children: [
                    MaterialButton(
                      onPressed: manage != null ? () => manage!() : null,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(color: Colors.blue),
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
                        decoration: const BoxDecoration(color: Colors.red),
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
