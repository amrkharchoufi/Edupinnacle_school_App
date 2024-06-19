import 'dart:async';
import 'package:edupinacle/mywidgets/card.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Planning extends StatefulWidget {
  const Planning({Key? key}) : super(key: key);

  @override
  State<Planning> createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  Color primaryColor = AppColors.primaryColor;
  bool isLoaded = false;
  Map<String, List<Map<String, String>>> schedule = {};
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getUserData();
    _startTimer();
    await _initializeSchedule();
  }

  Future<void> _getUserData() async {
    try {
      String user = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot minidata =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      String id = minidata.get('ID');
      DocumentSnapshot admin =
          await FirebaseFirestore.instance.collection('etudiant').doc(id).get();
      setState(() {
        data = admin.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle the error appropriately here, maybe set an error state
    }
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      print("Timer triggered. Refreshing data...");
      _initializeSchedule();
    });
  }

  Future<void> _initializeSchedule() async {
    try {
      if (data.isEmpty) {
        print('User data is not loaded yet.');
        return;
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('schedule')
          .doc(data['class'])
          .get();

      if (doc.exists) {
        Map<String, dynamic> scheduleData = doc.data() as Map<String, dynamic>;
        Map<String, List<Map<String, String>>> fetchedSchedule = {};

        scheduleData['schedule'].forEach((day, timeSlots) {
          List<Map<String, String>> slots = [];
          for (var slot in timeSlots) {
            slots.add({
              'startTime': slot['startTime'],
              'endTime': slot['endTime'],
              'activity': slot['activity'],
            });
          }
          fetchedSchedule[day] = slots;
        });

        setState(() {
          schedule = _sortScheduleByDay(fetchedSchedule);
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      setState(() {
        isLoaded = true;
      });
    }
  }

  Map<String, List<Map<String, String>>> _sortScheduleByDay(
      Map<String, List<Map<String, String>>> unsortedSchedule) {
    // Define the desired order of days
    List<String> dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Sort the schedule map based on the defined day order
    Map<String, List<Map<String, String>>> sortedSchedule = {};

    for (var day in dayOrder) {
      if (unsortedSchedule.containsKey(day)) {
        sortedSchedule[day] = unsortedSchedule[day]!;
      }
    }

    return sortedSchedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Planning",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Week of May 10 - May 16',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              isLoaded
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: schedule.length,
                        itemBuilder: (context, index) {
                          String day = schedule.keys.toList()[index];
                          List<Map<String, String>> tasks = schedule[day]!;

                          return PlanningItem(
                            day: day,
                            tasks:
                                tasks.map((task) => task['activity']!).toList(),
                            time: tasks
                                .map((task) =>
                                    '${task['startTime']} - ${task['endTime']}')
                                .toList(),
                          );
                        },
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      backgroundColor: primaryColor,
    );
  }
}

