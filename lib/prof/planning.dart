import 'dart:async';
import 'package:edupinacle/staff/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PRPlanning extends StatefulWidget {
  const PRPlanning({Key? key}) : super(key: key);

  @override
  State<PRPlanning> createState() => _PRPlanningState();
}

class _PRPlanningState extends State<PRPlanning> {
  Color primaryColor = AppColors.primaryColor;
  bool isLoaded = false;
  Map<String, List<Map<String, String>>> schedule = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _startTimer();
    await _initializeSchedule();
  }


  void _startTimer() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      print("Timer triggered. Refreshing data...");
      _initializeSchedule();
    });
  }

  Future<void> _initializeSchedule() async {
    try {
      

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('schedule')
          .doc('A02')
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
          "PRPlanning",
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

                          return PRPlanningItem(
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

class PRPlanningItem extends StatelessWidget {
  final String day;
  final List<String> tasks;
  final List<String> time;

  const PRPlanningItem({
    required this.day,
    required this.tasks,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  leading: Text(time[index],style: TextStyle(fontSize: 15),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
