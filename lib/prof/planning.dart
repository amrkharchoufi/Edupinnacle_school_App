import 'package:edupinacle/mywidgets/card.dart';
import 'package:flutter/material.dart';

class PRPlanning extends StatelessWidget {
  const PRPlanning({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Planning",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 164, 45, 185),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
              Expanded(
                child: ListView(
                  children: const [
                    PlanningItem(
                      day: 'Monday',
                      tasks: ['Task 1', 'Task 2'],
                      time: ['8-10','10-12'],
                    ),
                    PlanningItem(
                      day: 'Tuesday',
                      tasks: ['Task 3', 'Task 4', 'Task 5'],
                      time: ['8-10','10-12','13-15'],
                    ),
                    PlanningItem(
                      day: 'Wednesday',
                      tasks: ['Task 6'],
                      time: ['8-10'],
                    ),
                    PlanningItem(
                      day: 'Thursday',
                      tasks: ['Task 7', 'Task 8'],
                      time: ['8-10','10-12'],
                    ),
                    PlanningItem(
                      day: 'Friday',
                      tasks: ['Task 9', 'Task 10'],
                      time: ['8-10','10-12'],
                    ),
                    PlanningItem(
                      day: 'Saturday',
                      tasks: ['Task 11'],
                      time: ['8-10'],
                    ),
                    PlanningItem(
                      day: 'Sunday',
                      tasks: ['Task 12', 'Task 13', 'Task 14'],
                      time: ['8-10','10-12','16-18'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 164, 45, 185),
    );
  }
}