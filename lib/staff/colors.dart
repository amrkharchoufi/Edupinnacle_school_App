import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color _primaryColor = Colors.white; // Default color
  static late StreamController<Map<String, Color>> _colorStreamController;

  static Future<void> initialize() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('App').doc('myapp').get();
      int primaryColorValue = snapshot.get('primaryColor') as int;

      _primaryColor = Color(primaryColorValue);

      _colorStreamController = StreamController<Map<String, Color>>.broadcast();
      _colorStreamController.add({'primaryColor': _primaryColor});
    } catch (error) {
      print('Failed to fetch colors: $error');
    }
  }

  static Stream<Map<String, Color>> get colorStream =>
      _colorStreamController.stream;

  static Color get primaryColor => _primaryColor;
}
