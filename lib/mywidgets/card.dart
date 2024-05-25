import 'package:flutter/material.dart';

class PlanningItem extends StatelessWidget {
  final String day;
  final List<String> tasks;
  final List<String> time;

  const PlanningItem({
    super.key,
    required this.day,
    required this.tasks,
    required this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color.fromARGB(255, 245, 162, 190),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children:[ Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tasks
                    .map(
                      (task) => Text(
                        '- $task',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: time
                    .map(
                      (time) => Text(
                        ' at : "$time"',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                    .toList(),
              ),
          ]),
          ],
        ),
      ),
    );
  }
}
