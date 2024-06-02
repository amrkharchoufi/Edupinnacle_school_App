import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String? date;
  String? message;
  late int currentIndex;
  late List<Map<String, dynamic>> feedData;

  Future<void> getdata() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Feed')
        .where('IDclass', isEqualTo: 'A02')
        .where('IDprof', isEqualTo: 'AL325698')
        .where('IDmodule', isEqualTo: 'arabic')
        .get();

    List<Map<String, dynamic>> tempFeedData = [];
    for (var doc in query.docs) {
      Map<String, dynamic> feed = doc.get('Feed') as Map<String, dynamic>;
      feed.forEach((date, value) {
        Map<String, dynamic> msg = value as Map<String, dynamic>;
        tempFeedData.add({'date': date, 'message': msg['message']});
      });
    }

    setState(() {
      feedData = tempFeedData;
      currentIndex = 0;
      date = feedData[currentIndex]['date'];
      message = feedData[currentIndex]['message'];
    });
  }

  void nextField() {
    setState(() {
      if (currentIndex < feedData.length - 1) {
        currentIndex++;
        date = feedData[currentIndex]['date'];
        message = feedData[currentIndex]['message'];
      }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date ?? 'date'),
            Text(message ?? 'message'),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: nextField,
              child: Text('Next Field'),
            )
          ],
        ),
      ),
    );
  }
}
