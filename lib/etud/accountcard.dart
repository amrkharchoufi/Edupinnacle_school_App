import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final String className;
  final String studentID;
  final String imageURL;

  const AccountCard({
    super.key,
    required this.name,
    required this.className,
    required this.studentID,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 80,width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Registration-number",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("GH7T-GA24-GHDE",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 130,height: 1,color: Colors.grey,)
                        ]
                      ),
                      ),
                      SizedBox(height: 80,width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Class",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("A0102",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 130,height: 1,color: Colors.grey,)
                        ]
                      ),
                      ),
                      SizedBox(
                          height: 80,width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("CIN",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("AD314145",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 130,height: 1,color: Colors.grey,)
                        ]
                      ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(  height: 80,width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Academic Year",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("2023-2024",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 130,height: 1,color: Colors.grey,)
                        ]
                      ),),
                      SizedBox(
                          height: 80,width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Code Apogee",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("20004962",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 130,height: 1,color: Colors.grey,)
                        ]
                      ),
                      ),
                      SizedBox(
                          height: 80,width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Date of Birth",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("29 May 2002",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 130,height: 1,color: Colors.grey,)
                        ]
                      ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  height: 80,width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Email",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("Wiame_hamrane@um5r.ac.ma",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 300,height: 1,color: Colors.grey,)
                        ]
                      ),
              ),
              SizedBox(
                  height: 80,width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Father Name",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("Rachid Hamrane",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 300,height: 1,color: Colors.grey,)
                        ]
                      ),
              ),
              SizedBox(
                  height: 80,width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Mother Name",style: TextStyle(color: Color.fromARGB(255, 167, 164, 164)),),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("Assia IdellHousse ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.lock_outline)
                        ],),
                        const SizedBox(height: 5,),
                        Container(width: 300,height: 1,color: Colors.grey,)
                        ]
                      ),
              )
            ],
          )
          ),
      ),
    );
  }
}
