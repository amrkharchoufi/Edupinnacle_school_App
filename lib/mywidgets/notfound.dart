import 'package:flutter/material.dart';

class Notfound extends StatelessWidget {
  final text;
  const Notfound({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/not found.png',
              height: 500,
            ),
            Text(
              '$text !',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
