// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class Cont1 extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  const Cont1(
      {super.key,
      required this.title,
      required this.description,
      required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
          elevation: 3,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            Container(
              width: 150,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                // ClipRRect widget to apply border radius
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),bottomLeft:Radius.circular(10)), 
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),), 
                  Text(description)
                  ],
              ),
            )
          ])),
    );
  }
}
