import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/etud/etudhome.dart';
import 'package:edupinacle/firebase_options.dart';
import 'package:edupinacle/pages/homepage.dart';
import 'package:edupinacle/prof/profhome.dart';
import 'package:edupinacle/routes.dart';
import 'package:edupinacle/staff/staffhome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String home = '/';
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
      } else {
        DocumentSnapshot data = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.toString())
            .get();
        Map<String, String> role = data.data() as Map<String, String>;
        if (role['role'] == "etudiant") {
          home = '/Etudianthome';
        } else if (role['role'] == "Prof") {
          home = '/profhome';
        } else if (role['role'] == "admin") {
          home = '/staffhome';
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        initialRoute: home,
        routes: routes);
  }
}
