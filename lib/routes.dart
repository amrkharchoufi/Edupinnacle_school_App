import 'package:edupinacle/pages/inscription.dart';
import 'package:edupinacle/prof/account.dart';
import 'package:edupinacle/prof/courses.dart';
import 'package:edupinacle/prof/planning.dart';
import 'package:edupinacle/staff/administration/class/addclass.dart';
import 'package:edupinacle/staff/administration/module/madd.dart';
import 'package:edupinacle/staff/register/register.dart';
import 'package:edupinacle/staff/administration/admin.dart';
import 'package:edupinacle/staff/staffaccount.dart';
import 'package:edupinacle/staff/staffhome.dart';
import 'package:flutter/material.dart';
import 'package:edupinacle/etud/courses.dart';
import 'package:edupinacle/etud/assignment.dart';
import 'package:edupinacle/etud/account.dart';
import 'package:edupinacle/etud/etudhome.dart';
import 'package:edupinacle/etud/grades.dart';
import 'package:edupinacle/etud/planning.dart';
import 'package:edupinacle/pages/homepage.dart';
import 'package:edupinacle/pages/login.dart';
import 'package:edupinacle/pages/signup.dart';
import 'package:edupinacle/pages/welcome.dart';
import 'package:edupinacle/prof/profhome.dart';

// Define routes using a Map
final Map<String, WidgetBuilder> routes = {
  '/': (context) =>  const Homepage(),
  // For homepage and Login 
  '/homepage': (context) => const Homepage(),
  '/welcome': (context) => const Welcome(),
  '/login': (context) => const Login(),
  '/signup': (context) => const Signup(),


  //  For Etudiant
  '/inscrihome': (context) =>  Inscription(),
  '/Etudianthome': (context) => const Etudhome(),
  '/etGrades': (context) => const Grades(),
  '/etPlanning': (context) => const Planning(),
  '/etAssignment': (context) => const Asignment(),
  '/etAccount': (context) => const Account(),
  '/etCourses': (context) => const Courses(),

  // For Prof 
  '/profhome': (context) => const Profhome(),
  '/prGrades': (context) => const Grades(),
  '/prPlanning': (context) => const PRPlanning(),
  '/prCourses': (context) => const PRCourses(),
  '/praccount':(context) => const PRAccount(),
  // For Staff
  '/staffhome' : (context) => const Staffhome(),
  '/Registration' : (context) => const Register(),
  '/stfaccount' : (context) => const SFAccount(),
  '/Admin' : (context) => const Administration(),
  '/classadd' : (context) => const Addclass(),
  '/moduleadd' : (context) => const Moduleadd(),

};
